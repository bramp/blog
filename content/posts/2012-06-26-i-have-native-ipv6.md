---
title: I have native IPv6
author: bramp
layout: post
date: 2012-06-27
permalink: /2012/06/26/i-have-native-ipv6/
categories:
  - Blog
tags:
  - android
  - Internet
  - IPv6
---
I&#8217;m more excited than I should be, but today I noticed that Comcast has enabled IPv6 on my home internet connection. All my devices in the home have picked up one or more Internet routable IPv6 addresses. Here are a few screen shots: <!--more-->

<div id="attachment_360" style="width: 713px" class="wp-caption alignleft">
  <a href="http://bramp.net/blog/wp-content/uploads/ifconfig-v6.png"><img src="http://bramp.net/blog/wp-content/uploads/ifconfig-v6.png" alt="" title="ifconfig-v6" width="703" height="195" class="size-full wp-image-360" /></a>
  
  <p class="wp-caption-text">
    IPv6 ifconfig
  </p>
</div>

<div id="attachment_365" style="width: 798px" class="wp-caption alignleft">
  <a href="http://bramp.net/blog/wp-content/uploads/google-v6.png"><img src="http://bramp.net/blog/wp-content/uploads/google-v6.png" alt="" title="google-v6" width="788" height="204" class="size-full wp-image-365" /></a>
  
  <p class="wp-caption-text">
    IPv6 Google!
  </p>
</div>

<div id="attachment_362" style="width: 1309px" class="wp-caption alignleft">
  <a href="http://bramp.net/blog/wp-content/uploads/facebook-v6.png"><img src="http://bramp.net/blog/wp-content/uploads/facebook-v6.png" alt="" title="facebook-v6" width="1299" height="544" class="size-full wp-image-362" /></a>
  
  <p class="wp-caption-text">
    IPv6 Facebook
  </p>
</div>

<div id="attachment_363" style="width: 1260px" class="wp-caption alignleft">
  <a href="http://bramp.net/blog/wp-content/uploads/bramp-v6.png"><img src="http://bramp.net/blog/wp-content/uploads/bramp-v6.png" alt="" title="bramp-v6" width="1250" height="266" class="size-full wp-image-363" /></a>
  
  <p class="wp-caption-text">
    IPv6 my website (thanks to Amazon AWS)
  </p>
</div>

<div id="attachment_368" style="width: 180px" class="wp-caption alignleft">
  <a href="http://bramp.net/blog/wp-content/uploads/android-v6.png"><img src="http://bramp.net/blog/wp-content/uploads/android-v6-170x300.png" alt="" title="android-v6" width="170" height="300" class="size-medium wp-image-368" /></a>
  
  <p class="wp-caption-text">
    even my Android phone has IPv6!
  </p>
</div>

<div style="clear:both">
</div>

So this is very cool, but this has identified a few issues. The most important of which, is that I had previously been using my NAT as a firewall, protecting all devices on the internal network. However, now they all have external IP addresses, they are effectively open to the Internet and un-firewalled. That&#8217;s not a issue for my Linux machines, but could be problematic for my girlfriend&#8217;s Windows laptop, and my various embedded devices (phones, tablets, and TVs).