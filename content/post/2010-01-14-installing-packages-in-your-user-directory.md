---
title: Installing packages into your user directory
author: bramp
layout: post
date: 2010-01-14
categories:
  - Blog
tags:
  - FreeBSD
  - Linux
aliases:
  - /blog/2010/01/14/installing-packages-in-your-user-directory/
---
Today I had the need to install some [FreeBSD][1] and [Ubuntu][2] packages inside my home directory because I did not have root permissions to install them.

It was quite simple to install the packages on FreeBSD

```bash
pkg_add -rRP /home/bramp nano
```

Where nano is the name of the package I wanted.

I should point out you don&#8217;t need to be root to do this!, but the installed packages only work for you, and in future could cause you hassle if the base OS is updated.

On Ubuntu I however failed :( I tried the &#8220;&#8211;root&#8221; option and did some [Googleing][3] but I didn&#8217;t find a solution. Unitl then I&#8217;ll just install from source.

 [1]: http://www.freebsd.org/
 [2]: http://www.ubuntu.com/
 [3]: http://ubuntuforums.org/archive/index.php/t-513933.html
 
