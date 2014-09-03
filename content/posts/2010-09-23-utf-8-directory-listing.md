---
title: UTF-8 Directory Listing
author: bramp
layout: post
date: 2010-09-23
permalink: /2010/09/23/utf-8-directory-listing/
categories:
  - Blog
tags:
  - directory listing
  - python
  - utf8
  - windows
---
I had a need to create a directory listing with all the UTF-8 characters intact. This seems quite a chore on Windows, as doing anything via the shell seems to mangle the characters and show ???? instead of the real characters. For example, both the built in **dir** and Cygwin **ls** or **find** seemed affected. This turns out to be a [limitation in the windows shell][1].

To solve this problem I wrote a bit of python to read the file names in full UTF-8 and output the results directly to a file (and not via a pipe, which would again be via the shell). The resulting very simple script is as follows:

<pre class="prettyprint">import os
import codecs

log = codecs.open('listing', mode='w', encoding="utf-8")

for root, dirs, files in os.walk(u'.'):
	log.write(root + u"\n")

	for file in sorted(files):
		log.write(os.path.join(root, file) + u"\n")

log.close()

</pre>

 [1]: http://stackoverflow.com/questions/379240/is-there-a-windows-command-shell-that-will-display-unicode-characters