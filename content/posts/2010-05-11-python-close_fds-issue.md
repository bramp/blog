---
title: Python close_fds issue
author: bramp
layout: post
date: 2010-05-11
permalink: /2010/05/11/python-close_fds-issue/
categories:
  - Blog
tags:
  - Git
  - python
  - trac
---
So I spent the better part of my evening trying to track down a bug, which turns out to be a &#8220;feature&#8221; of python.

I had just installed the [GitPlugin][1] for [trac][2] but I started to experience problems. When browsing the source inside trac it was taking over 30seconds to load the page and sometimes it would fail completely. A lot of searching didn&#8217;t help much, so I attempted to debug the problem myself. The first thing I noticed was Apache was taking 100% of the processor for a good 30seconds. I attached [strace][3] to it and saw something like this:

<pre>[pid 22682] close(43029)                = -1 EBADF (Bad file descriptor)
[pid 22682] close(43030)                = -1 EBADF (Bad file descriptor)
[pid 22682] close(43031)                = -1 EBADF (Bad file descriptor)
[pid 22682] close(43032)                = -1 EBADF (Bad file descriptor)
[pid 22682] close(43033)                = -1 EBADF (Bad file descriptor)
[pid 22682] close(43034)                = -1 EBADF (Bad file descriptor)
[pid 22682] close(43035)                = -1 EBADF (Bad file descriptor)
[pid 22682] close(43036)                = -1 EBADF (Bad file descriptor)
</pre>

This obviously didn&#8217;t look good! After some tinkering I found the problem went away when I ran trac [standalone][4], instead of using [mod_python][5] or [fcgi][6]. This turned out to be a bit of a red herring because I spent my time trying to figure out what was different between a standalone executable and one being run inside Apache.

After playing around with environment variables, I gave up and attempted to printf debug the trac git plugin. I found that the actual call to git was taking on the order of seconds, whereas calling it myself from the command took milliseconds. The line of code (in PyGIT.py) looked a bit like this:

<pre class="prettyprint">p = Popen(self.__build_git_cmd(git_cmd, *cmd_args), stdin=None, 
        stdout=PIPE, stderr=PIPE, close_fds=True)
</pre>

Now, when I removed the close_fds argument the problems went away! After some more digging I found this [bug report][7] which describes the behaviour of close_fds. Python will spin in a tight loop calling close for all possible valid fd number. WTF! You can see the python [code here][8]:

<pre class="prettyprint">def _close_fds(self, but):
            os.closerange(3, but)
            os.closerange(but + 1, MAXFD)
</pre>

So the simple fix to this was to remove the close_fds, so that Python doesn&#8217;t stupidly spin calling close(). I suspect the reason I only noticed this when running inside Apache, is because Apache must have a larger MAXFD. Hopefully in the future Python will change this behaviour and find a more sensible way to close all file descriptors, especially when I read this [bug report][9] which advises changing close_fds default to true.

 [1]: http://trac-hacks.org/wiki/GitPlugin
 [2]: http://trac.edgewall.org/
 [3]: http://en.wikipedia.org/wiki/Strace
 [4]: http://trac.edgewall.org/wiki/TracStandalone
 [5]: http://www.modpython.org/
 [6]: http://en.wikipedia.org/wiki/FastCGI
 [7]: http://bugs.python.org/issue8052
 [8]: http://svn.python.org/projects/python/tags/r311/Lib/subprocess.py
 [9]: http://bugs.python.org/issue7213