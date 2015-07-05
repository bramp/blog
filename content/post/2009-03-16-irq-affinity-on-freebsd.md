---
title: IRQ Affinity on FreeBSD
author: bramp
layout: post
date: 2009-03-16
categories:
  - Blog
tags:
  - affinity
  - cpu
  - irq
aliases:
  - /2009/03/16/irq-affinity-on-freebsd/
---
On Linux it is quite simple to set the CPU affinity of a IRQ, by for example issuing the following command:

```bash
cat 1 > /proc/irq/#/smp_affinity
```

This will ensure that IRQ # will always fire on core 1. It is also possible to specify affinities such as 3, which pins the IRQ to just core 1 and 2.

This can be very helpful to stop your IRQ interrupts bouncing between all the cores. For example, if you have a single threaded app which is generating all the network traffic then it makes sense to ensure the network card&#8217;s interrupt will fire on the same core, or at least a core which is close (in terms of cache sharing).

Recently I was looking for a way to pin IRQ on FreeBSD, however, it appears FreeBSD 7.1 still doesn&#8217;t support this feature, but FreeBSD-CURRENT does! I don&#8217;t advise people try FreeBSD-CURRENT yet, but when it turns into FreeBSD 8.0, then you can issue a command such as:

```bash
cpuset -l 0 -x irq#
```

which will pin the IRQ to core 0, or

```bash
cpuset -l 0,1 -x irq#
```

which will pin the IRQ to cores 0 and 1.

Hopefully this feature will be back ported to FreeBSD 7.X. I&#8217;m a unsure how likely this will be considering there is a chunk of code missing from the 7.X kernel, which I assume will only be in FreeBSD 8.0.