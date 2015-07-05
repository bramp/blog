---
title: linuxoffsets for FreeBSD
author: bramp
layout: post
date: 2009-01-11
categories:
  - Blog
tags:
  - FreeBSD
  - Linux
  - linuxoffset
  - VMWare
aliases:
  - /2009/01/11/linuxoffsets-for-freebsd/
---
VMWare 6 and above has this neat debugging functionality where you can attach gdb running on a host, to a guest running inside VMWare. This allows you to debug a running kernel, or on linux running processes.

However, VMWare seems to have coded a bit of a hack to allow gdb to understand what process/threads are inside the virtual machine. Now this hack involves using something called linuxoffsets, which provides the offset for certain fields in a linux kernel struct.

So I thought I could abuse these offsets, and hopefully make them work for FreeBSD. The Linux offsets are:

|  | Linux Values | FreeBSD 7.1 Values | Notes |
|-------------------|------------------------------------------------------------|---------------------------------------|-----------------------------------------------------|
| &lt;version&gt; |  |  | Version number of linux kernel, ie 0x020609 (2.6.9) |
| &lt;mm&gt; | task_struct-&gt;mm |  |  |
| &lt;next_task&gt; | task_struct-&gt;next_task (linux &lt; 2.4.15) | struct proc-&gt;p_list-&gt;le_next | Pointer to next task struct |
| &lt;tasks&gt; | task_struct-&gt;tasks (linux &gt;= 2.4.15) | 0 | Pointers to prev and next task struct |
| &lt;comm&gt; | task_struct-&gt;comm | struct proc-&gt;p_comm | executable name |
| &lt;pid&gt; | task_struct-&gt;pid | struct proc-&gt;p_pid | pid of the process |
| &lt;thread&gt; | task_struct-&gt;thread |  |  |
| &lt;pgd&gt; | mm_struct-&gt;pgd |  |  |
| &lt;rsp0/esp0&gt; | thread_struct-&gt;rsp0 (or thread_struct-&gt;esp0 32bit) | struct thread-&gt;td_sigstk-&gt;ss_sp |  |
| &lt;fs&gt; | thread_struct-&gt;fs |  |  |
| &lt;threadsize&gt; | 0x2000 or sizeof(union thread_union-&gt;stack) (linux &gt;= 2.6) |  |  |
| &lt;grouplead&gt; | task_struct-&gt;group_leader (linux &gt;= 2.6.11) | 0 |  |
| &lt;threadgroup&gt; | task_struct-&gt;thread_group (linux &gt;= 2.6.11) | 0 |  |
| &lt;commsize&gt; | sizeof(struct task_struct-&gt;comm) | sizeof(struct proc-&gt;p_comm) | executable name’s max len |

However, after some time I feel this isn&#8217;t going to be possible. Each value represents a offset into a Linux task\_struct struct, however, nothing represents the location of the first task\_struct in RAM. I suspect VMWare is figuring out the location via some other means. Since FreeBSD doesn&#8217;t have a task_struct it most likely won&#8217;t be able to find what it needs.

Regardless I&#8217;ve posted this entry in case someone wants to continue my work. However, not all is lost as my next solution involves playing with gdb-python.