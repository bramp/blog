---
title: Intel ucode firmware version parser
author: bramp
layout: post
date: 2011-01-24
permalink: /2011/01/24/intel-ucode-firmware-version-parser/
categories:
  - Blog
tags:
  - Linux
  - python
  - ucode
---
Out of fun I wrote a simple Python script to pull the version number out of Intel&#8217;s ucode firmware, for example, the firmware used by my wifi driver. I needed this so I could see what version I was running versus a new version I had downloaded from [Intel&#8217;s Linux Wireless site][1].

So here is the code if anyone finds it interesting:  


and example of using it is:

<pre>> ./ucode.py /lib/firmware/*.ucode
iwlwifi-1000-3.ucode    : ver 128.50.3.1
iwlwifi-3945-1.ucode    : ver 15.28.1.6
iwlwifi-3945-2.ucode    : ver 15.32.2.9
iwlwifi-4965-1.ucode    : ver 228.57.1.21
iwlwifi-4965-2.ucode    : ver 228.61.2.24
iwlwifi-5000-1.ucode    : ver 5.4.1.16
iwlwifi-5000-2.ucode    : ver 8.24.2.12
iwlwifi-5150-2.ucode    : ver 8.24.2.2
iwlwifi-6000-4.ucode    : ver 9.221.4.1
iwlwifi-6000g2a-5.ucode : ver 17.168.5.1 (6000g2a fw v17.168.5.1 build 33993)
iwlwifi-6000g2b-5.ucode : ver 17.168.5.1 (6000g2b fw v17.168.5.1 build 33993)
iwlwifi-6050-4.ucode    : ver 9.201.4.1
iwlwifi-6050-5.ucode    : ver 41.28.5.1 (6050 fw v41.28.5.1 build 33926)
</pre>

 [1]: http://intellinuxwireless.org/?n=Downloads