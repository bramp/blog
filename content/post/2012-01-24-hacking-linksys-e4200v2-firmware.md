---
title: Hacking Linksys E4200v2 firmware
author: bramp
layout: post
date: 2012-01-24
dsq_thread_id:
  - 1614115116
categories:
  - Blog
tags:
  - e4200v2
  - firmware
  - linksys
  - Linux
aliases:
  - /blog/2012/01/24/hacking-linksys-e4200v2-firmware/
---
In a previous post I [obtained the Linksys E4200v2 firmware][1], now I plan to break it apart and see what I can find.

I start off by simplying using &#8220;file&#8221; on the firmware:

```bash
$ file FW_E4200_2.0.36.126507.SSA 

FW_E4200_2.0.36.126507.SSA: u-boot legacy uImage, Linux-2.6.35.8, Linux/ARM, OS Kernel Image (Not compressed), 2677476 bytes, Thu Dec 22 19:40:21 2011, Load Address: 0x00008000, Entry Point: 0x00008000, Header CRC: 0x6ADD9801, Data CRC: 0xB010442D
```

Well this is a great start. We know we are dealing with Linux, and that this is a normal uImage. I then move on to use a neat little tool called [binwalk][2]. By using libmagic, binwalk tries to find interesting sections of the file.

```bash
$ /usr/local/bin/binwalk FW_E4200_2.0.36.126507.SSA 

DECIMAL   	HEX       	DESCRIPTION
-------------------------------------------------------------------------------------------------------
0         	0x0       	uImage header, header size: 64 bytes, header CRC: 0x6ADD9801, created: Thu Dec 22 19:40:21 2011, image size: 2677476 bytes, Data Address: 0x8000, Entry Point: 0x8000, data CRC: 0xB010442D, OS: Linux, CPU: ARM, image type: OS Kernel Image, compression type: none, image name: Linux-2.6.35.8
1124      	0x464     	LZMA compressed data, properties: 0x87, dictionary size: 250216448 bytes, uncompressed size: 14786800 bytes
16636     	0x40FC    	gzip compressed data, from Unix, last modified: Thu Dec 22 19:40:18 2011, max compression
2752512   	0x2A0000  	JFFS2 filesystem data little endian, JFFS node length: 49
..A whole lot of JFFS2 sections..
20974612  	0x1400C14 	JFFS2 filesystem data little endian, JFFS node length: 51
20974664  	0x1400C48 	JFFS2 filesystem data little endian, JFFS node length: 193
```

We find a small LZMA section, and large gzip section, and lots of JFFS2 sections. JFFS2 is a popular embedded file system, so we can guess the bulk of the file system is here. Next we can extract each section using dd:

```bash
dd bs=1 skip=1124  count=15512   if=FW_E4200_2.0.36.126507.SSA of=image-1.lzma
dd bs=1 skip=16636 count=2735876 if=FW_E4200_2.0.36.126507.SSA of=image-2.gz
dd bs=1 skip=2752512 if=FW_E4200_2.0.36.126507.SSA of=image-3.jffs2
```

Notice we are using a block size of 1 (so we can count in bytes), and we skip the offset into the file. Then we manually work out the sizes for the lzma and gzip sections. They can be no larger than their start until the next section. If they don&#8217;t fill that full space, then not to worry as these tools will normally ignore trailing data.

As I&#8217;m interested to see what&#8217;s in the JFFS filesystem, we should mount it. You can&#8217;t mount JFFS like a normal loopback device, you have to create a fake flash device. The following set of command can solve that:

```bash
sudo modprobe mtdram total_size=32768 erase_size=256
sudo modprobe mtdblock
sudo modprobe mtdchar
# sudo mknod /dev/mtdblock0 b 31 0
dd if=image-3.jffs2 of=/dev/mtdblock0
mount -t jffs2 /dev/mtdblock0 /mnt/disk
```

The mknod line is only needed if you don&#8217;t already have a /dev/mtdblock0. Also a /mnt/disk needs to be created ahead of time so the mounting works. Anyway once that was done, I cd /mnt/disk and found that it does appear to contain most of the file system. There are all the HTML pages, and binaries (for example busybox).

Now we should go back to image-1.lzma and image-2.gz. Well straight away trying to decompress image-1

```bash
$ lzma -dc image-1.lzma > image-1
lzma: Decoder error
```

results in a error. So we can assume that was a incorrectly detected by binwalk. Lets now try and decompress image-2.gz:

```bash
$ gzip -dc image-2.gz > image-2
gzip: image-2.gz: decompression OK, trailing garbage ignored
```

So that does indeed produce a large image-2 file, so we can ignore the trailing garbage warning. A quick &#8220;file&#8221; on image-2 doesn&#8217;t reveal anything useful, so I run binwalk on it. This turns up a set of false positives. So I take a different approach. I run:

```bash
$ strings image-2
```

This produces a whole host of valid looking strings. From the contents of the strings it makes me think it&#8217;s the actual kernel. A line like this:

```text
Linux version 2.6.35.8 (root@ubuntu) (gcc version 4.2.0 20070413 (prerelease) (CodeSourcery Sourcery G++ Lite 2007q1-21)) #1 Thu Dec 22 16:40:10 PST 2011
```

helps me come to that conclusion.

I haven&#8217;t finished poking around image-2.gz, but I suspect the interesting parts are mostly in the JFFS2 filesystem. Hopefully this will lead to me getting ssh access to the router, and eventually being able to customise the firmware.

 [1]: {{< ref "2012-01-22-obtaining-the-firmware-for-linksys-e4200v2.md" >}}
 [2]: https://github.com/devttys0/binwalk
 
