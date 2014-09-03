---
title: The 7 month fork bomb
author: bramp
layout: post
date: 2009-11-27
permalink: /2009/11/27/the-7-month-fork-bomb/
categories:
  - Blog
tags:
  - fork
  - Linux
---
Today I was helping a student with some C programming, and the remote machine he was compiling and running his code on was running very slowly. It was a shared machine so I assumed some other students were using it. Therefore I had a quick look at &#8220;who&#8221; and found that only one other user was logged in. Then I looked at &#8220;top&#8221; and &#8220;ps&#8221; and noticed the machine was at 100% load, but I couldn&#8217;t figure out which process was causing this.

It turns out that 7 months ago (in April), two of the students had ran the following code while they were learning about fork:

<pre class="prettyprint">while ( fork() ) {}
</pre>

Each spawned process didn&#8217;t use much CPU, but the system was heavily forking, therefore tying up all the resources. Needless to say I found the two students and gave them a quick slap before asking them to run &#8220;killall blah&#8221;.

What I found cool about this was that there was two separate fork bombs going on, and this linux machine was still usable by the other students. Additionally, I&#8217;m surprised that no one in 7 months had actually noticed this! Things were happening so fast that I saw the pid of the forked programs wrap around at least twice during the time I was debugging the issue.