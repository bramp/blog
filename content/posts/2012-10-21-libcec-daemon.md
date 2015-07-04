---
title: libcec-daemon
author: bramp
layout: post
date: 2012-10-21
permalink: /2012/10/21/libcec-daemon/
categories:
  - Blog
---
Many months ago I purchased this cool little device from [Pulse Eight][1], called a [USB CEC Adapter][2]. Basically it allows your computer to speak to a HDMI device over a protocol called [CEC][3]. This is useful for using your PC to control your TV, and for using your TV remote to control your PC. This device now allows me to use my normal TV remote to control XBMC, and to turn my PC on standby if I turn my TV off. <!--more-->

It&#8217;s all pretty neat, but each application needed to add libcec support, which means many applications do not support this little adapter. So I decided to write a simple uinput daemon that bridged Linux input events, and this CEC device. My project, [libcec-daemon][4], has been [available for many months][5] now, and I&#8217;ve been using it successfully on my television. I just had forgotten to write a quick blog post about it <img src="http://bramp.net/blog/wp-includes/images/smilies/icon_smile.gif" alt=":)" class="wp-smiley" /> 

So please check it out, and support the great guys at Pulse Eight.

 [1]: http://www.pulse-eight.com
 [2]: http://www.pulse-eight.com/store/products/104-usb-hdmi-cec-adapter.aspx
 [3]: http://en.wikipedia.org/wiki/HDMI#CEC
 [4]: https://github.com/bramp/libcec-daemon
 [5]: http://forums.pulse-eight.com/default.aspx?g=posts&t=430
 