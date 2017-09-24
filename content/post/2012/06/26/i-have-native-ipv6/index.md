---
title: I have native IPv6
slug: i-have-native-ipv6
author: bramp
layout: post
date: 2012-06-26
categories:
  - Blog
tags:
  - android
  - Internet
  - IPv6
aliases:
  - /blog/2012/06/26/i-have-native-ipv6/
---
I&#8217;m more excited than I should be, but today I noticed that Comcast has enabled IPv6 on my home internet connection. All my devices in the home have picked up one or more Internet routable IPv6 addresses. Here are a few screen shots: <!--more-->

{{< figure src="ifconfig-v6.png" title="IPv6 ifconfig" >}}
{{< figure src="google-v6.png"   title="IPv6 Google!" >}}
{{< figure src="facebook-v6.png" title="IPv6 Facebook" >}}
{{< figure src="bramp-v6.png"    title="IPv6 my website (thanks to Amazon AWS)" >}}
{{< figure src="android-v6.png"  title="even my Android phone has IPv6!" >}}

So this is very cool, but this has identified a few issues. The most important of which, is that I had previously been using my NAT as a firewall, protecting all devices on the internal network. However, now they all have external IP addresses, they are effectively open to the Internet and un-firewalled. That&#8217;s not an issue for my Linux machines, but could be problematic for my girlfriend&#8217;s Windows laptop, and my various embedded devices (phones, tablets, and TVs).
