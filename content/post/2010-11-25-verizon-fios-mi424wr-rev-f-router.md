---
title: Verizon FiOS MI424WR rev. F Router
author: bramp
layout: post
date: 2010-11-25
categories:
  - Blog
tags:
  - hacking
  - router
  - verizon
aliases:
  - /blog/2010/11/25/verizon-fios-mi424wr-rev-f-router/
---
I just got a FiOS wifi router and I must say I really like it. The web interface has many more options than any home router I&#8217;ve ever played with, and it seems like it&#8217;d be easy for a beginner but doesn&#8217;t get in the way of an expert. It also telnet access (optionally over SSL), which puts you into a custom shell. Poking around the commands I find one awesome one:

```bash
Wireless Broadband Router> help system shell
shell   Spawn busybox shell in foreground

Wireless Broadband Router> system shell
BusyBox v1.01 (2005.09.07-07:38+0000) Built-in shell (lash)
Enter 'help' for a list of built-in commands.

/ # 
```

This is very clearly running Linux, with BusyBox. For those interested here are some interesting bits of information:

```bash
/ # cat /proc/version 
Linux version 2.6.16.14 #1 SMP Sat Nov 28 00:38:50 PST 2009
```

A four year old kernel. Well what do you expect from this kind of device :)

```bash
/ # cat /proc/cpuinfo 
system type		: MC524WR
processor		: 0
cpu model		: Cavium Networks Octeon CN50XX V0.1
BogoMIPS		: 1000.48
wait instruction	: yes
microsecond timers	: yes
tlb_entries		: 64
extra interrupt vector	: yes
hardware watchpoint	: yes
ASEs implemented	:
VCED exceptions		: not available
VCEI exceptions		: not available
processor		: 1
cpu model		: Cavium Networks Octeon CN50XX V0.1
BogoMIPS		: 1000.48
wait instruction	: yes
microsecond timers	: yes
tlb_entries		: 64
extra interrupt vector	: yes
hardware watchpoint	: yes
ASEs implemented	:
VCED exceptions		: not available
VCEI exceptions		: not available
```

w00t, a [Dual Cores 64bit MIPS chip][1]

```bash
/ # cat /proc/meminfo 
MemTotal:        53200 kB
MemFree:         11588 kB
Buffers:          9252 kB
Cached:           9228 kB
SwapCached:          0 kB
Active:           7796 kB
Inactive:        16220 kB
HighTotal:           0 kB
HighFree:            0 kB
LowTotal:        53200 kB
LowFree:         11588 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:               0 kB
Writeback:           0 kB
Mapped:          11272 kB
Slab:            13700 kB
CommitLimit:     26600 kB
Committed_AS:    11384 kB
PageTables:        196 kB
VmallocTotal: 1073741824 kB
VmallocUsed:      2752 kB
VmallocChunk: 1073738692 kB
HugePages_Total:     0
HugePages_Free:      0
Hugepagesize:     2048 kB
```

Only ~53MB of RAM if I&#8217;m reading that right. Seems most likely to be 64MB to me, but I will investigate further.

Also, as this is Linux, the [source code][2] has been made available. The [README][3] reveals it is a MC524 Router (MI424WR-GEN2 REV E/F).

The device doesn&#8217;t seem to have many of the standard Linux tools, no doubt to save space. It does however have an external USB port. My plan is to compile more of busybox, as well as some other binaries, and run them from an external USB stick.

Hacking an router has never been so easy! I&#8217;ll post more when I know more!

 [1]: http://www.caviumnetworks.com/OCTEON-Plus_CN50XX.html
 [2]: http://opensource.actiontec.com/
 [3]: http://opensource.actiontec.com/sourcecode/mi424wr/rev_ef/mi424wr-fw-20.10.7.5_readme
 
