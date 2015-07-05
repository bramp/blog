---
title: VMWare breaks shift key
author: bramp
layout: post
date: 2010-03-19
categories:
  - Blog
tags:
  - Linux
  - setxkbmap
  - VMWare
aliases:
  - /blog/2010/03/19/vmware-breaks-shift-key/
---
I came into my office today to find that my keyboard would no longer type capital letters. The shift, caps lock, and even num lock keys seemed to be broken. After a quick WTF [it was pointed out to me][1] that VMWare occasionally does this to Linux machines. Thanks to [Matt][2] who showed me a quick solution. In a terminal just type:

```bash
setxkbmap
```

And everything should be back to normal. After using VMWare on Linux for a couple of years I&#8217;ve never encountered this problem!

 [1]: http://www.evolution-systems.co.uk/blogs/matt/view_post&id=37/
 [2]: http://twitter.com/bigkebabman
 
