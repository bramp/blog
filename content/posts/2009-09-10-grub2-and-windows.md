---
title: Grub2 and Windows
author: bramp
layout: post
date: 2009-09-10
permalink: /2009/09/10/grub2-and-windows/
categories:
  - Blog
tags:
  - debian
  - grub
  - grub2
  - Linux
---
I&#8217;ve just installed grub2 on my Debian laptop, and I wanted to write a quick note on how to get dual booting working. Grub2 seems to have a far more complex configuration system than grub, this may be a good or a bad thing. One feature of this is a /etc/grub.d directory which contains a set of scripts to configure what items should be listed on the boot menu.

<pre>bramp@Andrew-laptop:~$ ls /etc/grub.d/
00_header  05_debian_theme  10_linux  30_os-prober  40_custom  README
</pre>

The scripts get run in order, each adding features to the boot menu. To dual boot Windows you can acheive this in two ways.  
1) Write a script which manual adds windows  
2) Use the os-prober script.

I opted for option 2 since it seemed the easiest. However, this os-prober script does not work unless the package os-prober is installed. So:

<pre>bramp@Andrew-laptop:~$ sudo apt-get install os-prober
</pre>

Once that is installed you can reconfigure grub by doing:

<pre>bramp@Andrew-laptop:~$ sudo update-grub2
Generating grub.cfg ...
Found Debian background: moreblue-orbit-grub.png
Found linux image: /boot/vmlinuz-2.6.30-1-amd64
Found initrd image: /boot/initrd.img-2.6.30-1-amd64
Found Microsoft Windows XP Professional on /dev/sda1
done
</pre>

When you reboot you should now have Windows on your boot menu.