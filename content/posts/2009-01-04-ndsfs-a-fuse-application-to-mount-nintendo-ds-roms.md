---
title: ndsfs – A FUSE application to mount Nintendo DS roms
author: bramp
layout: post
date: 2009-01-04
permalink: /2009/01/04/ndsfs-a-fuse-application-to-mount-nintendo-ds-roms/
categories:
  - Blog
tags:
  - fuse
  - ndsfs
  - nintendo ds
  - rom
---
I brought my dad Professor Layton for the Nintendo DS this Christmas, and being a curious fellow I decided to see if I could reverse engineer the game to extract all the questions/answers. It turns out it wasn&#8217;t that hard. On my journey however I had to work out how to browse the file system stored on the rom.

To do this I found a tool call [ndstool][1], which can browse and extract the file system in the rom image. However, being a nerd I decided to write a FUSE file system application to do the same task.

So here is the [source code][2] for ndsfs, you will have to compile it yourself like so:

<pre>gcc -lfuse ndsfs.c -o ndsfs</pre>

and then run it like so:

<pre>ndsfs &lt;rom file&gt; &lt;mount point&gt;</pre>

I&#8217;m not sure it will work on all roms, but it is worth a try.

**Update: Version 1.1 released** &#8211; A few months ago I worked a bit more on this and have now released a new version. I fixed many problems but as I did this months ago, and I didn&#8217;t document anything, I don&#8217;t know what I fixed <img src="http://bramp.net/blog/wp-includes/images/smilies/icon_smile.gif" alt=":)" class="wp-smiley" /> 

[Version 1.1][2]  
[Version 1.0][3]

 [1]: http://darkfader.net/ds/
 [2]: /projects/ndsfs/ndsfs-1.1.tar.bz2
 [3]: /projects/ndsfs/ndsfs-1.0.tar.bz2