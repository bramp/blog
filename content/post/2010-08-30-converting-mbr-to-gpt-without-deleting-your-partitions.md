---
title: Converting MBR to GPT without deleting your partitions
author: bramp
layout: post
date: 2010-08-30
categories:
  - Blog
tags:
  - gpt
  - gptgen
  - mbr
  - windows
aliases:
  - /blog/2010/08/30/converting-mbr-to-gpt-without-deleting-your-partitions/
---
Today I tired to convert my Windows 2TB RAID disk from a [master boot record][1] (MBR) layout to a [GUID partition table][2] (GPT) one. The reason I wanted to swap is that GPT supports partitions larger than 2TB. Normally it is easy to convert a MBR disk to a GPT one by [using the Disk Management GUI][3]. However, Microsoft do not allow you to convert you disk if you have any partitions on the disk. 

After some searching I found that you could [convert the disk non-destructively on Linux][4], but due to various reasons, my RAID [does not work][5] inside my Debian Linux :( I had also read a [document outlining how to the conversion works][6], and it seems such a simple process I was surprised that Microsoft didn&#8217;t support it.

Some more searching and I found a Linux/Windows tool that will convert MBR to GPT quite easily. [Gptgen][7] is a simple command line tool that seemed to work like a charm. I will quickly outline the steps I took to use it &#8220;safely&#8221;.

Firstly I identified with disk I wanted to alter. This is done by looking at which number the disk is in Disk Management. I then quickly tested the tool without writing the changes

```bash
gptgen.exe \\.\\physicaldrive1
```

This outputted quite a few lines, including the following:

```text
Write primary.img to LBA address 0.
Write secondary.img to LBA address 4395431903.
```

When you don&#8217;t write the changes to disk, gptgen creates two binary files &#8220;primary.img&#8221;, and &#8220;secondary.img&#8221;, which contain what it would have written to disk. The console output from gptgen tells me it would have written primary to [LBA address][8] 0, and secondary.img to LBA address 4395431903. So I figured it was a good idea to make a backup of those sections first. To do this I use the [Windows version of the classic tool dd][9]

```bash
dd if=\\.\\physicaldrive1 of=primary-backup.img bs=512 count=34 
dd if=\\.\\physicaldrive1 of=secondary-backup.img bs=512 count=33 skip=4395431903
```

The count and skip values might have to change. The two count values relate to the file sizes of primary.img and secondary.img. Find their file sizes and divide them by 512. In my case, primary.img was exactly 17,408 bytes, so 17408 / 512 = 34. Do the same for secondary.img. The skip number is the LBA address shown by gptgen just a minute ago.

Ok, if you have run dd ok, you should have backups of the two sections it is going to overwrite. Now you can tell gptgen to actually make the changes:

```bash
gptgen.exe -w \\.\\physicaldrive1
```

That should be it, BUT if you need to (for whatever reason) restore the backups issue these commands:

```bash
dd if=primary-backup.img   of=\\.\\physicaldrive1 bs=512 count=34 
dd if=secondary-backup.img of=\\.\\physicaldrive1 bs=512 count=33 seek=4395431903
```

(notice how the &#8220;if&#8221; and &#8220;of&#8221; arguments have swapped, and the word &#8220;skip&#8221; has changed to &#8220;seek&#8221;.)

 [1]: http://en.wikipedia.org/wiki/Master_boot_record
 [2]: http://en.wikipedia.org/wiki/GUID_Partition_Table
 [3]: http://technet.microsoft.com/en-us/library/cc738416(WS.10).aspx
 [4]: https://bbs.archlinux.org/viewtopic.php?id=62984
 [5]: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=411172
 [6]: http://www.rodsbooks.com/gdisk/mbr2gpt.html
 [7]: http://sourceforge.net/projects/gptgen/
 [8]: http://en.wikipedia.org/wiki/Logical_block_addressing
 [9]: http://www.chrysocome.net/dd
