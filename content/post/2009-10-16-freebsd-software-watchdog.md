---
title: FreeBSD Software Watchdog
author: bramp
layout: post
date: 2009-10-16
categories:
  - Blog
tags:
  - FreeBSD
  - panic
  - watchdog
aliases:
  - /blog/2009/10/16/freebsd-software-watchdog/
---
Recently I&#8217;ve been doing some kernel hacking and I managed to deadlock my system. The system still responded to pings but the terminal was unresponsive, and it needed a hard reboot to fix. I would have loved to drop into a debugger or panic&#8217;ed the kernel to get a suitable back-trace.

I found that FreeBSD has a software watchdog feature, that will panic the kernel if a problem like this occurs. The watchdog does not seem to be built into the kernel by default, and I found the documentation a bit lacking. So here is what I did:

Firstly, build and install a custom kernel which includes: ```options SW_WATCHDOG```

Secondly, edit the ```/etc/rc.conf``` file and add a line: ```watchdogd_enable="YES"```

When you next reboot, the watchdogd daemon will run, enabling the watchdog feature. Every second the watchdogd will reset a timer within the kernel. If after 16 seconds the timer has not been reset, the kernel will print out some interrupt information, and panic.

Watchdogd seems to have some useful features, for example, you can configure it to execute a specific command every second, and if that command fails the timer will not be reset. The configuration option I use is: ```watchdogd_flags="-e /bin/ps"```

Read [WATCHDOGD(8)][1] for more information.

 [1]: http://www.freebsd.org/cgi/man.cgi?query=watchdogd&sektion=8
 
