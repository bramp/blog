---
author: bramp
categories:
- Blog
date: 2017-12-22T12:50:31-08:00
layout: post
tags:
- java
- SRE
- production
title: "Running Java in Production: A SRE’s Perspective"
slug: running-java-in-production
---

_Originally [published](https://www.javaadvent.com/2017/12/running-java-in-production.html) as part of the Java Advent 2017 series_

As a [Site Reliability Engineer](https://landing.google.com/sre/) (SRE) I make sure our production services are efficient, scalable, and reliable. A typical SRE is a master of production, and has to have a good understanding of the wider architecture, and be well versed in many of the finer details.

It is common that SREs are polyglot programmer, expected to understand multiple different languages. For example, C++ may be hard to write, test and get right, but has high performance, perfect for backend systems such as database. Whereas Python is easy to write, and great for quick scripting, useful for automation. Java is somewhere in the middle, and even though it is a compiled language, it provides type safety, performance, and many other advantages that make it a good choice for writing web infrastructure.

Even though many of the [best practices that SREs adopt](https://landing.google.com/sre/book.html) can be generalised to any language, there are some unique challenges with Java. This article plans to highlight some of them, and talk about what we can do to address them.

# Deployment
A typical java application consists of 100s of class files, either written by your team, or from common libraries that the application depends on. To keep the number of class files under control, and to provide better versioning, and compartmentalisation, they are typically bundled up into [JAR](https://en.wikipedia.org/wiki/JAR_(file_format)) or [WAR](https://en.wikipedia.org/wiki/WAR_(file_format)) files.

There are many ways to host a java application, one popular method is using a [Java Servlet Container](https://en.wikipedia.org/wiki/Web_container) such as [Tomcat](https://tomcat.apache.org/), or [JBoss](https://www.jboss.org/). These provide some common web infrastructure, and libraries to make it, in theory, easier to deploy and manage the java application. Take Tomcat, a java program that provides the actual webserver and loads the application on your behalf. This may work well in some situations, but actually adds additional complexity. For example, you now need to keep track of the version of the JRE, the version of Tomcat, and the version of your application. Testing for incompatibility, and ensuring everyone is using the same versions of the full stack can be problematic, and lead to subtle problems. Tomcat also brings along its own bespoke configuration, which is yet another thing to learn.

A good tenant to follow is to “[keep it simple](https://landing.google.com/sre/book/chapters/simplicity.html)”, but in the Servlet Container approach, you have to keep track of a few dozen Tomcat files, plus one or more WAR files that make up the application, plus all the Tomcat configuration that goes along with it.

Thus there are some frameworks that attempt to reduce this overhead by instead of being hosted within a full application server, they embed their own web server. There is still a JVM but it invokes a single JAR file that contains everything needed to run the application. Popular frameworks that enable these standalone apps are [Dropwizard](http://www.dropwizard.io/) and [Spring Boot](https://projects.spring.io/spring-boot/). To deploy a new version of the application, only a single file needs to be changed, and the JVM restarted. This is also useful when developing and testing the application, because everyone is using the same version of the stack. It is also especially useful for rollbacks (one of SRE’s core tools), as only a single file has to be changed (which can be as quick as a symlink change).

One thing to note with a Tomcat style WAR file, the file would contain the application class files, as well as all the libraries the application depends on as JAR files.  In the standalone approach, all the dependencies are merged into a single, [Fat JAR](https://stackoverflow.com/questions/19150811/what-is-a-fat-jar). A single JAR file that contains the class files for the entire application. These Fat or Uber JARs, not only are easier to version and copy around (because it is a single immutable file), but can actually be smaller than an equivalent WAR file due to pruning of unused classes in the dependencies.

This can even be taken further, by not requiring a separate JVM and JAR file. Tools like [capsule.io](http://www.capsule.io/), can actually bundle up the JAR file, JVM, and all configuration into a single executable file. Now we can really ensure the full stack is using the same versions, and the deployment is agnostic to what may already be installed on the server.

> Keep it simple, and make the application as quick and easy to version, using a single Fat JAR, or executable where possible.

# Startup
Even though Java is a compiled language, it is not compiled to machine code, it is instead compiled to bytecode. At runtime the Java Virtual Machine (JVM) interprets the bytecode, and executes it in the most efficient way. For example, [just-in-time](https://en.wikipedia.org/wiki/Just-in-time_compilation) (JIT) compilation allows the JVM to watch how the application is used, and on the fly compile the bytecode into optimal machine code. Over the long run this may be advantageous for the application, but during startup can make the application perform suboptimally for tens of minutes, or longer. This is something to be aware of, as it has implications on load balancing, monitoring, capacity planning, etc.

In a multi-server deployment, it is best practice to slowly ramp up traffic to a newly started task, giving it time to warm up, and to not harm the overall performance of the service. You may be tempted to warm up new tasks by sending it artificial traffic, before it is placed into the user-serving path. Artificial traffic can be problematic if the warm up process does not approximate normal user traffic. In fact, this fake traffic may trigger the JIT to optimise for cases that don’t normally occur, thus leaving the application in a sub-optimal or in an even worse state than not being JIT’d.

Slow starts should also be considered when capacity planning. Don’t expect cold tasks to handle the same load as warm tasks. This is important when rolling out a new version of the application, as the capacity of the system will drop until the tasks warms up. If this is not taken into account, too many tasks may be reloaded concurrently, causing a capacity based cascading outage.

> Expect cold starts, and try to warm the application up with real traffic.

# Monitoring
This advice is generic [monitoring advice](https://landing.google.com/sre/book/chapters/monitoring-distributed-systems.html), but it is worth repeating for Java. Make sure the most important and useful metrics are exported from the Java application, are collected and easily graphed. There are many tools and frameworks for exporting metrics, and even more for collecting, aggregating, and displaying.

When something breaks, [troubleshooting](https://landing.google.com/sre/book/chapters/effective-troubleshooting.html) the issue should be possible from only the metrics being collected. You should not be to depending on log files, or looking at code, to deal with an outage.

Most outages are caused by change. That is, a new version of the application, a config change, new source of traffic, a hardware failure, or a backend dependencies behaving differently. The metrics exported by the application, should include ways to identify the version of Java, application, and configuration in use. It should break down sources of traffic, mix, error counts, etc. It should also track the health, latency, error rates, etc of backend dependencies. Most of the time, this is enough to diagnose a outage quickly.

Specific to Java, there are metrics that can be helpful to understand the health, and performance of the application. Guiding future decisions on how to scale and optimise the application. Garbage collection time, heap size, thread count, JIT time are all important and Java specific.

Finally, a note about measuring response times, or latency. That is, the time it takes the application to handle a request. Many make the mistake of looking at average latency, in part because it can be easily calculated. [Averages can be misleading](https://www.elastic.co/blog/averages-can-dangerous-use-percentile), because it doesn’t show the [shape of the distribution](https://en.wikipedia.org/wiki/Percentile_rank). The majority of requests may be handled quickly, but there may be a long tail of requests that are rare but take a while.  This is especially troubling for JVM application, because during garbage collection there is a [stop the world](https://www.cubrid.org/blog/understanding-java-garbage-collection) (STW) phase, where the application must pause, to allow the garbage collection to finish. In this pause, no requests will be responded to, and users may wait multiple seconds.

It is better to collect either the max, or 99 (or higher) percentile latency. For percentile, that say for every every 100 requests, 99 are served quicker than this number. Looking at the worst case latency is more meaningful, and more reflective of the user perceived performance.

> Measure metrics that matter, and you can later depend on.

# Memory Management
A good investment of your time is to learn about the various [JVM garbage collection algorithms](https://plumbr.io/handbook/garbage-collection-algorithms-implementations). The current state of the art are the concurrent collectors, either [G1](https://www.redhat.com/en/blog/part-1-introduction-g1-garbage-collector), or [CMS](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/cms.html). You can decide on what may be best for your application, but for now G1 is the likely winner. There are many great articles that explain how they work, but I’ll cover some key topics.

When starting up, the Java Virtual Machine (JVM) typically reserves a large chunk of OS memory and splits it into heap and non-heap. The non-heap contains areas such as [Metaspace](https://blogs.oracle.com/poonam/about-g1-garbage-collector,-permanent-generation-and-metaspace) ([formally called Permgen](https://dzone.com/articles/java-8-permgen-metaspace)), and stack space. Metaspace is for class definitions, and stack space is for each thread's stacks. The heap is used for the objects that are created, which normally takes up the majority of the memory usage. Unlike a typical executable, the JVM has the [`-Xms` and `-Xmx` flags](https://alvinalexander.com/blog/post/java/java-xmx-xms-memory-heap-size-control) that control the minimum and maximum size of the heap. These limits constrain the maximum amount of RAM the JVM will use, which can make the memory demands on your servers predictable. It is common to set both these flags to the same value, provisioning them to fill up the available RAM on your server. There are also best practices for [sizing this for Docker containers](https://developers.redhat.com/blog/2017/03/14/java-inside-docker/).

Garbage collection (GC) is the process of managing this heap, by finding java objects that are no longer in use (i.e no longer referred to), and can be reclaimed. It most cases the JVM scans the full graph of objects, marking which it finds. At the end, any that weren’t visited, are deleted. To ensure there aren’t race conditions, the GC typically has to stop the world (STW), which pauses the application for a short while, while it finishes up.

The GC is a source of (perhaps unwarranted) resentment because it is blamed for many performance problems. Typically this boils down to not understanding how the GC works. For example, if the heap is sized too small, the JVM can aggressive garbage collect, trying to futilely free up space. The application can then get stuck in this “[GC thrashing](http://javaagile.blogspot.com/2013/07/the-thrashing-of-garbage-collector.html)” cycle, that makes very little progress freeing up space, and spending a larger and larger proportion of time in GC, instead of running the application code.

Two common cases where this can happen, are [memory leaks](https://plumbr.io/blog/memory-leaks/what-is-a-memory-leak), or [resource exhaustion](http://www.oracle.com/technetwork/articles/java/trywithresources-401775.html). Garbage collected languages shouldn’t allow what is conventionally called memory leaks, however, they can occur. Take for example, maintaining a cache of objects that never expire. This cache will grow forever, and even though the objects in the cache may never be used again, they are still referenced, thus ineligible to be garbage collected.

Another common cases is [unbounded queues](https://blog.bramp.net/post/2015/12/17/the-importance-of-tuning-your-thread-pools/). If your application places incoming requests on a unbounded queue, this queue could grow forever. If there is a spike of request, objects retained on the queue could increase the heap usage, causing the application to spend more and more time in GC. Thus the application will have less time to process requests from the queue, causing the backlog to grow. This spirals out of control as the GC struggles to find any objects to free, until the application can make no forward progress.

One addition detail, is the garbage collector algorithms has many optimisations to try and reduce total GC time. One important observation, the [weak generational hypothesis](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/generations.html), is that objects either exist for a short time (for example, related to the handling a request), or last a long time (such as global objects that manage long lived resources).

Because of this, the heap is further divided into young and old space. The GC algorithm that runs across the young space assume the object will be freed, and if not, the GC promotes the object into old space. The algorithm for old space, makes the opposite assumption, the the object won’t be freed.  The size of the [young/old may thus also be tuned](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/sizing.html
), and depending on G1 or CMS the approach will be different. But, if the young space is too small, objects that should only exist for short time end up getting promoted to old space. Breaking some of the assumptions the old GC algorithms make, causing GC to run less efficiently, and causing secondary issues such as memory fragmentation.

As mentioned earlier, GC is a source of [long tail latency](https://www.weave.works/blog/the-long-tail-tools-to-investigate-high-long-tail-latency/), so should be monitored closed. The time taken for each phase of the GC should be recorded, as well as the fullness of heap space (broken down by young/old/etc) before and after GC runs. This provides all the hints needed to either tune, or improve the application to get GC under control.

> Make GC your friend. Careful attention should be paid to the heap, and garbage collector, and it should be tuned (even coarsely) to ensure there is enough heap space even in the fully loaded/worst case.

# Other tips

## Debugging
Java has many rich tools for debugging during development and in production. For example, it is possible to capture live stack traces, and heap dumps from the running application. This can be useful to understand memory leaks, or deadlocks. However, typically you must ensure the application is started to allow these features, and that the typical tools, [jmap](https://docs.oracle.com/javase/6/docs/technotes/tools/share/jmap.html), [jcmd](https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/tooldescr006.html), etc are actually available on the server. Running the application inside a [Docker container](http://trustmeiamadeveloper.com/2016/03/18/where-is-my-memory-java/), or non-standard environment, may make this more difficult, so test and write a playbook on how to do this now.

Many frameworks, also expose much of this information via webservices, for easier debugging, for example the Dropwizard /threads resource, or the [Spring Boot production endpoints](https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-endpoints.html).

> Don’t wait until you have a production issue, test now how to grab heap dumps and stack traces.

## Fewer but larger tasks
There are many features of the JVM that have a fixed cost per running JVM, such as JIT and garbage collection. Your application may also have fixed overheads, such as resource polling (backend database connections), etc. If you run fewer, but larger (in terms of CPU and RAM) instances, you can reduce this fixed cost, getting an economy of scale. I’ve seen doubling the amount of CPU and RAM a Java application had, allowed it to handle 4x the requests per second (with no impact to latency). This however makes some assumption about the application’s ability to scale in a multi-threaded way, but generally scaling vertically is easier than horizontally.

*Make your JVM as large as possible.*

## 32-bit vs. 64-bit Java
It used to be common practice to run a 32-bit JVM if your application didn’t use more than 4GiB of RAM. This was because 32-bit pointers are half the size of 64-bit, which reduced the overhead of each java object. However, as modern CPUs are 64-bit, typically with 64-bit specific performance improvements, and that the cost of RAM being cheap this make 64-bit JVMs the clear winner.

> Use 64-bit JVMs.

## Load Shedding
Again general advice, but important for java. To [avoid overload](https://landing.google.com/sre/book/chapters/handling-overload.html) caused by GC thrashing, or cold tasks, the application should aggressively load shed. That is, beyond some threshold, the application should reject new requests. It may seem bad to reject some requests early, but it is better than allowing the application to become unrecoverably unhealthy and fail all requests. There are many ways to avoid overload, but common approaches are to ensure queues are bounded, and that [thread pools are sized correctly](https://blog.bramp.net/post/2015/12/17/the-importance-of-tuning-your-thread-pools/). Additionally, outbound request should have [appropriate deadlines](https://www.datawire.io/guide/traffic/deadlines-distributed-timeouts-microservices/), to ensure a slow backend doesn’t cause problems for your application.

> Handle as many requests as you can, and no more.

# Conclusion
Hopefully this article has made you think about your java production environment. While not be prescriptive, we highlight some areas to focus. The links throughout should guide you in the right direction.
