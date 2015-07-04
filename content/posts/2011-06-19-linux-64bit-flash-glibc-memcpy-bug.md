---
title: Linux 64bit Flash glibc memcpy bug
author: bramp
layout: post
date: 2011-06-19
permalink: /2011/06/19/linux-64bit-flash-glibc-memcpy-bug/
categories:
  - Blog
tags:
  - 64bit
  - flash
  - Linux
  - memcpy
---
Does your Linux 64bit version of Flash now make anonying beeping/distortion noises while playing videos? Well it turns out a recent &#8220;[improvement][1]&#8221; to glibc has caused some programs to now crash or do weird things. This is to do with an improvement of [memcpy][2], which makes its use more strict, causing those applications that incorrectly used it to now crash.

On Debian, there is a simple a fix that allows you to use the original memcpy. You can load the application using an additional .so file:

```bash
LD_PRELOAD=/usr/lib/libc/memcpy-preload.so /path/to/your/program
```

As I use Google Chrome when using Flash I had to do the following:

```bash
LD_PRELOAD=/usr/lib/libc/memcpy-preload.so /usr/bin/google-chrome
```

but if you want to fix chrome on a system level, you can edit the Chrome Wrapper used to launch it.

```bash
sudo nano /opt/google/chrome/google-chrome
```

add the following line

```bash
export LD_PRELOAD="/usr/lib/libc/memcpy-preload.so"
```

for example

```bash
export LD_LIBRARY_PATH
export LD_PRELOAD="/usr/lib/libc/memcpy-preload.so"

export CHROME_VERSION_EXTRA="beta"
```

 [1]: http://lwn.net/Articles/414467/
 [2]: http://linux.die.net/man/3/memcpy
 