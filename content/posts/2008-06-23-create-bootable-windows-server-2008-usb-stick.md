---
title: Create Bootable Windows Server 2008 USB Stick
author: bramp
layout: post
date: 2008-06-23
permalink: /2008/06/23/create-bootable-windows-server-2008-usb-stick/
dsq_thread_id:
  - 1614115731
categories:
  - Blog
tags:
  - Install
  - USB
  - Windows Server
---
I recently had the need to install Windows Server 2008 from a USB stick. This was because I didn&#8217;t have a working DVD drive to hand. I found a couple of [tutorials][1] [online][2] explaining how to create the disk. They generally explained this technique:

```bash
C:\> diskpart

DISKPART> list disk

     Select the USB device from the list and substitute the disk number below
     when necessary

DISKPART> select disk 1
DISKPART> clean
DISKPART> create partition primary
DISKPART> select partition 1
DISKPART> active
DISKPART> format fs=fat32
DISKPART> assign
DISKPART> exit

xcopy X:\*.* /s/e/f Y:\

     where X:\ is your mounted image or physical DVD and Y:\ is your USB
     device
```

However it appears diskpart is unable to see USB sticks under Windows XP. I have later tried on Vista and this limitation appears removed. But for those using Windows XP I have found an alternative method.

Firstly find the bootsect.exe tool on the Windows Server disc (in the boot directory). Then run this command where U is the drive letter of the USB stick.

```bash
D:\boot> bootsect.exe /nt60 U:
```

Now copy all the files from the Windows Server disc onto the USB stick. This can be done by dragging in the GUI or using the xcopy method shown previously.

I have yet to repeat this procedure and I might have previous partitioned or formatted my USB stick in a unique way. So if this method doesn&#8217;t work [drop me a mail][3] and I&#8217;ll see what I can do.

 [1]: http://blogs.dirteam.com/blogs/sanderberkouwer/archive/2008/05/01/installing-windows-server-2008.aspx
 [2]: http://www.jesscoburn.com/archives/2007/10/15/installing-windows-2008-via-usb-thumbdrive/
 [3]: /about/#contact
