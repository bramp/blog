---
title: ndsfs – A FUSE application to mount Nintendo DS roms
author: bramp
layout: post
date: 2009-01-04
categories:
  - Blog
tags:
  - fuse
  - ndsfs
  - nintendo ds
  - rom
aliases:
  - /2009/01/04/ndsfs-a-fuse-application-to-mount-nintendo-ds-roms/
---
I brought my dad Professor Layton for the Nintendo DS this Christmas, and being a curious fellow I decided to see if I could reverse engineer the game to extract all the questions/answers. It turns out it wasn&#8217;t that hard. On my journey however I had to work out how to browse the file system stored on the rom.

To do this I found a tool call [ndstool][1], which can browse and extract the file system in the rom image. However, being a nerd I decided to write a FUSE file system application to do the same task.

The [source code][2] is available on GitHub, you can compile it yourself:

```bash
make
```

and then run it like so:

```bash
ndsfs &lt;rom file&gt; &lt;mount point&gt;
```

I&#8217;m not sure it will work on all roms, but it is worth a try.

 [1]: http://darkfader.net/ds/
 [2]: https://github.com/bramp/ndsfs
 