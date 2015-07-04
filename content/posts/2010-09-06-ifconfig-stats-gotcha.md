---
title: ifconfig stats gotcha
author: bramp
layout: post
date: 2010-09-06
permalink: /2010/09/06/ifconfig-stats-gotcha/
categories:
  - Blog
tags:
  - ifconfig
  - Linux
  - stats
---
I&#8217;ve recently been running network benchmarks and I wanted to highlight a quick gotcha that caught me out. My benchmark script would run ifconfig before and after the experiment and record the number of packets sent and received. The same would be recorded on another machine which was generating the packets.

I started to notice a problem that more packets were being received than being sent. It was only a small number, but nevertheless an seemingly impossible situation to have occurred. I tracked the problem down to the fact that the network card driver did not always report accurate and up to date stats. In fact, after checking the source, the e1000, ixgb, ixgbe and most likely the other Intel drivers all refresh their stats every 2 seconds. The other NIC I was using, an embedded smsc9500, always updated its stats in realtime. 

Delaying the update of stats is obviously a performance optimisation, which no doubt avoids costly locking, or problems such as cache line bouncing. I did some searching and other people have noticed similar delays in other networking devices, in some cases as much as 30 seconds on [cisco routers][1].

From now on I will always pause my scripts for a few seconds to allow the ifconfig stats to catch up before I record my data. An alternative would be to hack the drivers to either stay up to date, or offer a API that forces a update.

 [1]: http://fixunix.com/snmp/443079-how-handle-interface-counter-update-delay.html
 