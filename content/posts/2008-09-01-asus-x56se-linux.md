---
title: ASUS X56Se Linux
author: bramp
layout: post
date: 2008-09-01
permalink: /2008/09/01/asus-x56se-linux/
categories:
  - Blog
tags:
  - ASUS
  - Install
  - Linux
---
My girlfriend just purchased a [ASUS X56Se from eBuyer][1] and I wanted to install Linux on it.

If you google for this laptop you won&#8217;t find many pages about it, in fact I could find no information about the laptop on all of ASUS&#8217;s website. However, there is the [ASUS M51Se][2] which looks very similar in the photographs. I&#8217;ve even [asked on the ASUS forums][3] if anyone know more information.

Using Vista (which was pre-installed) I was able to get this list of hardware, which should help me with the installation process:

<pre>Atheros L1 Gigabit Ethernet
Intel Wireless 3945ABG
JMicron JMB36X
ATI Mobility Radeon HD 3470
Intel ICH8
Intel(R) 82801HBM/HEM I/O controller hub (ICH8M) SATA Controller
Intel ICH8M Ultra ATA Storage Controller 2850
Realtek HD Audio
Intel(R) GM965 Express Chipset
Intel 82GM965 Memory Controller
Intel(R) 965GM Graphics And Memory Controller Hub(GMCH)
</pre>

Regardless of knowing if Linux would install or not, I went ahead and tried [Debian lenny beta 2][4]. However, as it was booting it would crash and fill the screen with &#8220;pretty&#8221; colours. I then tried a old Debian disc I had lying around, then a new and old Ubuntu disk, and all these failed to load. So then I tried different kernel options, and eventually I found this command worked:

<pre>acpi=off</pre>

To make it clear, at the Debian boot menu for the installer, you select &#8220;Install&#8221;, but then press tab instead of enter. Then select the 2nd line, press e, and then type the command on the very end. After this press enter, then b to boot the installer.

This command disables most power management controls, but at least allows Linux to be installed and boot. Here comes the next problem, X won&#8217;t start. When X attempts to start it again dies either with pretty colours, or with just a full black screen. I haven&#8217;t finished debugging this, but I&#8217;ve tried the Radeon driver, the Radeonhd driver, and the official ATI fglrx.

 [1]: http://www.ebuyer.com/product/147001
 [2]: http://www.asus.com/products.aspx?l1=5&l2=74&l3=604&l4=0&model=2109&modelmenu=1
 [3]: http://vip.asus.com/forum/view.aspx?board_id=3&model=X53Se&id=20080831051338546&page=1&SLanguage=en-us
 [4]: http://www.debian.org/devel/debian-installer/