---
title: Avoid Bloat Freezer Free
author: bramp
layout: post
date: 2012-01-14
permalink: /2012/01/14/avoid-bloat-freezer-free/
categories:
  - Blog
tags:
  - android
---
Over a month ago I install &#8220;Bloat Freezer Free&#8221;, a tool designed to kill of particular services running in the background, such as those installed back your phone manufactor. It seemed to be working fine, but in the last few days I&#8217;ve been getting a green star in my notification bar alerting me to &#8220;There is a update to the Android Market&#8221;. If I click it, it takes me to some spyware looking site to download a new market place. Then today I get an alert with the same green star saying &#8220;Badoo&#8221;. If it click that it links me via some porn advertiser and I end up at the Google Market for the Badoo app.

I got out the Android SDK, and I figured out the notification was coming from the Bloat Freezer tool! After a few searches I find [a article][1] about how that tool is using a push notification system, AirPush, to send me spam.

I have now removed this app, and writing this blog entry to helpful save others from this hassle.

 [1]: http://androidunderground.blogspot.com/2011/12/bloat-freezer-abuses-airpush-ads-to.html