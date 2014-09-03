---
title: Groovy / Grails
author: bramp
layout: post
date: 2012-07-04
permalink: /2012/07/04/groovy-grails/
categories:
  - Blog
tags:
  - grails
  - groovy
  - java
---
Over the past couple of weeks I&#8217;ve been playing with Groovy and Grails, and after a somewhat frustrainting week I thought I&#8217;d share my thoughts. [Groovy][1] is a dynamic language that runs in a standard JVM, and effectively extends the Java langugage. This makes it easy for existing Java programmer to pick it up and ease into it. [Grails][2] is the Groovy equilivant of [Ruby on Rails][3], a rapid web development framework. I had high hopes for both as Groovy adds lots of interesting features to Java, such as [Closures][4], [Dynamic typing][5], [Mixins][6], and lots of clever syntax to reduce code and to speed up the average developer. On top of this Grails can quickly scaffold a [MVC][7] framework, allowing you to literally build a [CRUD][8] based application in minutes.

<!--more-->

This all sounds great but I think both of these technologies are still young and there are a lot of things to work out. I was consistently hitting bugs in Grails, and I found the support for Groovy to be lacking in my IDE of choice Ecplise, forcing me to move to IntelliJ which did a lot better job.

# Groovy

## Dynamic typing

The dynamic variable typing allows you to create a variable and not declare what type it is. Then as you use the variable you can very easily convert it between types. To be honest, and maybe I miss the point, but I&#8217;ve never been fond of dynamic typing in other languages. I tend to create a variable and ensure I keep it a particular type. I do this because dynamic typing can introduce all sorts of errors, and you have to truely understand the rules. For example, if I try and convert a String to a boolean (as I might do in a condition), what type of Strings evaluate to true and false? In Groovy a empty string is false, but a string with a single whitespace char would be true.

<pre class="prettyprint">def someString = ""
if (someString) {
...
}
// a useful example of String-&gt;boolean conversion</pre>

Groovy also adds [duck typing][9]. If a variable walks like a duck, quacks like a duck then it must be a duck. This is effectively a way to avoid having to implement a interface by checking at runtime if the class has a particular method. This is only useful because at runtime Groovy allows methods to be add (and removed) from classes. This thus allow from some interesting programming, however I find it very error prone. As a method could be added to a class at runtime there is no compile-time checking.

<pre class="prettyprint">class SomeObject {

}
SomeObject o = new SomeObject();
o.someMethod();
// This code is valid at compile time, but only at runtime with an MissingMethod exception be thrown.
</pre>

Because of the dynamic nature a lot of the silly typo errors that should be caught at compile time, will only now be found at run time. Mistyping a method name wasn&#8217;t caught until that line of code was reached. Also, due to dynamic typing, errors such as calling a method with the wrong argument types were not caught. I found this very frustrating as it slowed down my development.  This also makes me dread what will happen if this code is pushed into production without a very rigorous 100% line test coverage.

It looks like Groovy 2.0 is trying to resolve this concern with [GEP 8][10], a new type of annotation that will force Groovy to statically check your class/method at compile time.

# Grails

## GORM

The GORM is Grails&#8217;s [ORM][11], which sits on top of [Hibernate][12]. It takes advantage of Groovy&#8217;s [collection syntax][13] to make configuring a model easy. However, I think due to the young nature of Grails I found multiple problems with GORM. I started by using the super convenient [H2][14] data source for testing. Then as I progressed I moved to MySQL. However, the code that worked perfectly with with H2 stopped working in MySQL. There were little things, like reserved keywords being different, which tripped up MySQL. Looking at the generated SQL the MySQL queries weren&#8217;t being escaped, which would have solved this issue. Secondly, and a bigger issue, but I was using hierarchical data models. That is, I had a generic abstract Base model, and multiple specific models that extended from the base. This worked well in H2 and avoided a lot of duplication of code, but with the MySQL data source it was handled incorrectly, causing me to spend hours investigating and modifying the code.

I also tried the [MongoDB plugin][15], as the document store concept works great for my heirachy concept. However it wasn&#8217;t a direct drop in replacement for H2/MySQL, and I even found some bugs, which I [reported][16].

## Scaffolding

This was one of the coolest features, but also one of the biggest let downs. Scaffolding generates all the code you quickly need for a simple CRUD application. There are two modes, dynamic and static. A dynaimic one literally allows you to create a controller in just a few lines, with all the code for create/read/update/delete hidden behind the scenes. Static scaffolding is very similar in features, but placed all the code in the groovy file ready for you to edit.

<pre class="prettyprint">class SomeController {
    static scaffold = Author
}
// This is all you need for a CRUD controller that maps to the Author model</pre>

The problem I found here is that it dynamic scaffolding served little purpose than showing off how little you could write. To actually customise it you would have to use static scaffolding. Even then, the static scaffolding didn&#8217;t seem particular neat and simple (as compared to other rapid dev frameworks I&#8217;ve used), and you eventually had to throw 90% of that generated code away and write it all yourself.

## Closures

The concept of closures and anonymous functions is a very cool one, which in fact I have quite liked using in Python and JavaScript. The implementation here also seemed quite good, except for some minor pet pevs I had. The real issue I had with closures is how it polluted the call stack. Some of my call stacks were now chains of methods like:

<pre class="prettyprint">at _GrailsCompile_groovy$_run_closure2.doCall(_GrailsCompile_groovy:46)
at com.springsource.loaded.ri.ReflectiveInterceptor.jlrMethodInvoke(ReflectiveInterceptor.java:1231)
at org.codehaus.gant.GantMetaClass.invokeMethod(GantMetaClass.java:133)
at com.springsource.loaded.ri.ReflectiveInterceptor.jlrMethodInvoke(ReflectiveInterceptor.java:1231)
at org.codehaus.gant.GantMetaClass.invokeMethod(GantMetaClass.java:133)</pre>

This is no doubt a limitation of being built onto of the JVM that couldn&#8217;t provide more helpful output.

## Run-app

Grails comes with a CLI tool that does a lot of the code generation for you. One of the useful commands is `grails run-app`, this will start up an embedded webserver which runs your application, and better yet, allows you to make code changes without recompiling/redeploying. This truly makes it quicker to develop and test your Java/Groovy, and allows those minor tweaks to your Controllers, etc without a wait. However, yet again I was let down by this feature. Lots of simple changes would cause the run-app to stop serving my pages with odd exception. The solution was to stop the webserver and start it again, which defeats the purpose. Even worse, I sometimes had to `grails clean` as it did not always pick up my code changes.

# Conclusion

I liked everything that Groovy and Grails was trying to do, but I think their implementation isn&#8217;t good enough yet, and there are too many gotchas for me to considering using this in a production environment. I no doubt will follow it&#8217;s progress and play with it every so often.

 [1]: http://groovy.codehaus.org/ "Groovy"
 [2]: http://grails.org/
 [3]: http://rubyonrails.org/
 [4]: http://en.wikipedia.org/wiki/Closure_(computer_science)
 [5]: http://en.wikipedia.org/wiki/Type_system
 [6]: http://en.wikipedia.org/wiki/Mixin
 [7]: http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller
 [8]: http://en.wikipedia.org/wiki/Create,_read,_update_and_delete
 [9]: http://en.wikipedia.org/wiki/Duck_typing
 [10]: http://docs.codehaus.org/display/GroovyJSR/GEP+8+-+Static+type+checking
 [11]: http://en.wikipedia.org/wiki/Object-relational_mapping
 [12]: http://www.hibernate.org/
 [13]: http://groovy.codehaus.org/Collections
 [14]: http://www.h2database.com/
 [15]: http://grails.org/plugin/mongodb
 [16]: http://jira.grails.org/browse/GPMONGODB-210