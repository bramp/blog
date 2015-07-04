---
title: Default to curses interface for mtr
author: bramp
layout: post
date: 2011-08-07
permalink: /2011/08/07/default-to-curses-interface-for-mtr/
categories:
  - Blog
tags:
  - curses
  - Linux
  - mtr
---
I really like [mtr][1] (the traceroute tool), however, it always bugged me that it launches a GUI app instead of using the [curses][2] interface. You can easily pass the &#8220;-t&#8221; or &#8220;&#8211;curses&#8221; flag to default to the curses interface, but I always forget.

So today I set about writing a patch for mtr to read a environment varable to force the curses interface. While I was reading the source I noticed there was already a simple undocumented way!

```bash
export MTR_OPTIONS=-t
```

Voila the curses interface is now used by default. This is certainly going into my ~/.bashrc

 [1]: http://www.bitwizard.nl/mtr/
 [2]: http://en.wikipedia.org/wiki/Curses_(programming_library)
 