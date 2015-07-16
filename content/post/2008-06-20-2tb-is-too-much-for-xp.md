---
title: 2TB is too much for XP
author: bramp
layout: post
date: 2008-06-20
categories:
  - Blog
tags:
  - RAID
  - Windows XP
aliases:
  - /blog/2008/06/20/2tb-is-too-much-for-xp/
---
I just got a new motherboard and 4 new shiny 750GB [Samsung F1 hard drives][1]. So I thought I would use the Intel Matrix Storage feature of my motherboard to create a RAID 5 array from these drives.

A day or so later I finally managed to get an array set up, however it was not larger than 2 Terabytes. The problem appears to be the lack of support of partitions in Windows XP (32 bit edition) which are greater than 2 TB in size. If I was using Windows XP (64 bit) or Vista I would not have had this problem. In fact there didn&#8217;t even seem to be a problem, which is why it took me so long to figure this out.

Within the Intel application I could see my nice larger than 2TB drive; however inside Windows&#8217; Disk Management the array would not appear. Oddly it would appear in Device manager under the Disk Drive heading. After thinking something was wrong with a drive, or my new windows installed, I set to Google. However that proved useless as I couldn&#8217;t find anyone reporting their RAID would not appear. Also the Intel docs were not helpful, not once pointing out that a single partition of over 2TB was not supported on XP.

Finally the solution to my problem was found on [Carlton Bale&#8217;s blog][2]. I could either buy a [piece of software][3], upgrade to Vista, or make multiple 2TB sized arrays. I finally decided to go with option 3, multiple 2TB arrays. This [Microsoft article][4] has more information.

 [1]: http://www.samsung.com/global/business/hdd/productmodel.do?type=61&subtype=63&model_cd=248
 [2]: http://www.carltonbale.com/2007/05/how-to-break-the-2tb-2-terabyte-file-system-limit/
 [3]: http://www.mediafour.com/products/gptmounter/
 [4]: http://www.microsoft.com/whdc/device/storage/LUN_SP1.
 
