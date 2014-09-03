---
title: Persec python script
author: bramp
layout: post
date: 2010-08-31
permalink: /2010/08/31/persec-python-script/
categories:
  - Blog
tags:
  - Linux
  - python
  - scripting
---
A while ago I wrote a python script that does a similar job to GNU&#8217;s [watch][1] command. You use it like so:

<pre>./persec.py [--interval=&lt;n&gt;] &lt;command&gt;
</pre>

so for example

<pre>./persec.py ifconfig
</pre>

Now in a similar way to watch, it executes the command every second, and highlights the differences between each execution. However, in addition to this it finds any numbers that have changed and works out the rate at which they are changing. So for example, ifconfig would typically output this:

<pre>usb0      Link encap:Ethernet  HWaddr 02:04:4b:00:d3:cf
          inet addr:10.0.0.2  Bcast:10.0.0.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:1017422291 errors:0 dropped:0 overruns:0 frame:0
          TX packets:549382406 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1910704266 (1.9 GB)  TX bytes:1834667124 (1.8 GB)
</pre>

but now outputs something like:

<pre>usb0      Link encap:Ethernet  HWaddr 02:04:4b:00:d3:cf
          inet addr:10.0.0.2  Bcast:10.0.0.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:<b>2001/s</b> errors:0 dropped:0 overruns:0 frame:0
          TX packets:<b>2002/s</b> errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:<b>168120/s</b> (1.9 GB)  TX bytes:<b>217144/s</b> (1.8 GB)
</pre>

Notice the per second (/s) values for RX/TX packets and RX/TX bytes. I have found this quite useful many times in the past, on commands such as:

<pre>./persec.py cat /proc/interrupts
./persec.py df
./persec.py ls -l somefile
</pre>

[Download version 1.1][2] or [View on Github][3]

 [1]: http://linux.die.net/man/1/watch
 [2]: https://raw.github.com/gist/1275275/2da6db303e784bdbdb8a095cec2a374465a28779/persec.py
 [3]: https://gist.github.com/1275275