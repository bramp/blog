---
title: Linux kernel patch for TCP timestamping
author: bramp
layout: post
date: 2008-04-05
permalink: /2008/04/05/linux-kernel-patch-for-tcp-timestamping/
categories:
  - Blog
tags:
  - Linux
  - patch
  - TCP
---
Recently I needed to measure the time it takes a packet to travel though the Linux network stack. To begin with I thought I&#8217;ll hack the kernel to add my own timing measurements, but then I found this was already built in! I could use the SIOCGSTAMP or SIOCGSTAMPNS ioctl calls to retrieve the timestamp assigned by the network driver when the packet first enters the stack.

```c
SOCKET s;
struct timeval tv = {0,0};
if ( ioctl(s, SIOCGSTAMP, &tv) )
   return 0; // error
printf( "%ld seconds and %ld nanoseconds",  tv.tv_sec,  tv.tv_usec );
```

This works great for UDP packets or RAW sockets, but does not work for TCP. There are many good reasons why TCP isn&#8217;t supported, mainly because TCP is a stream protocol, whereas UDP and RAW sockets typically operate on discrete packets.

Ignoring this fact I decided to hack the kernel anyway to record the timestamps for TCP. It is a simple patch which hopefully others might find useful if they ever need to profile the TCP stack. It applys cleanly to 2.6.24 kernels.

```diff
--- a/linux-2.6.24/net/ipv4/tcp.c	2008-01-24 22:58:37.000000000 +0000
+++ b/linux-2.6.24/net/ipv4/tcp.c	2008-02-11 19:40:41.000000000 +0000
@@ -1180,6 +1180,10 @@
 		/* Next get a buffer. */
 
 		skb = skb_peek(&sk-&gt;sk_receive_queue);
+		
+		if (skb)
+			sock_recv_timestamp(msg, sk, skb); /* HACK */
+			
 		do {
 			if (!skb)
 				break;
```