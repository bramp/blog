---
title: linuxoffsets for FreeBSD
author: bramp
layout: post
date: 2009-01-11
permalink: /2009/01/11/linuxoffsets-for-freebsd/
categories:
  - Blog
tags:
  - FreeBSD
  - Linux
  - linuxoffset
  - VMWare
---
VMWare 6 and above has this neat debugging functionality where you can attach gdb running on a host, to a guest running inside VMWare. This allows you to debug a running kernel, or on linux running processes.

However, VMWare seems to have coded a bit of a hack to allow gdb to understand what process/threads are inside the virtual machine. Now this hack involves using something called linuxoffsets, which provides the offset for certain fields in a linux kernel struct.

So I thought I could abuse these offsets, and hopefully make them work for FreeBSD. The Linux offsets are:<table border=1 cellpadding=3 cellspacing=0> <tr height=20 style='height:15.0pt'> <td height=20style='height:15.0pt'></td> 

</tr> <tr height=20 style='height:15.0pt'> <td height=20 style='height:15.0pt'><version></td> 

</tr> <tr height=20 style='height:15.0pt'> <td height=20 style='height:15.0pt'><mm></td> 

</tr> <tr height=20 style='height:15.0pt'> <td height=20 style='height:15.0pt'><next_task></td> 

</tr> <tr height=20 style='height:15.0pt'> <td height=20 style='height:15.0pt'><tasks></td> 

</tr> <tr height=20 style='height:15.0pt'> <td height=20 style='height:15.0pt'><comm></td> 

</tr> <tr height=20 style='height:15.0pt'> <td height=20 style='height:15.0pt'><pid></td> 

</tr> <tr height=20 style='height:15.0pt'> <td height=20 style='height:15.0pt'><thread></td> 

</tr> <tr height=20 style='height:15.0pt'> <td height=20 style='height:15.0pt'><pgd></td> 

</tr> <tr height=20 style='height:15.0pt'> <td height=20 style='height:15.0pt'><rsp0/esp0></td> 

</tr> <tr height=20 style='height:15.0pt'> <td height=20 style='height:15.0pt'><fs></td> 

</tr> <tr height=20 style='height:15.0pt'> <td height=20 style='height:15.0pt'><threadsize></td> 

</tr> <tr height=20 style='height:15.0pt'> <td height=20 style='height:15.0pt'><grouplead></td> 

</tr> <tr height=20 style='height:15.0pt'> <td height=20 style='height:15.0pt'><threadgroup></td> 

</tr> <tr height=20 style='height:15.0pt'> <td height=20 style='height:15.0pt'><commsize></td> 

</tr> </table> 

However, after some time I feel this isn&#8217;t going to be possible. Each value represents a offset into a Linux task\_struct struct, however, nothing represents the location of the first task\_struct in RAM. I suspect VMWare is figuring out the location via some other means. Since FreeBSD doesn&#8217;t have a task_struct it most likely won&#8217;t be able to find what it needs.

Regardless I&#8217;ve posted this entry in case someone wants to continue my work. However, not all is lost as my next solution involves playing with gdb-python.