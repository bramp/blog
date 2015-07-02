---
title: Useful scripts/configurations
author: bramp
layout: post
date: 2009-11-28
permalink: /2009/11/28/useful-scriptsconfigurations/
categories:
  - Blog
tags:
  - configuration
  - FreeBSD
  - Git
  - Linux
  - nano
  - scripts
  - whitespace
---
Make [git][1] colourful

<pre>git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
</pre>

Make [nano][2] colourful

<pre>cp /usr/local/share/examples/nano/nanorc.sample ~/.nanorc
or
 zcat /usr/share/doc/nano/examples/nanorc.sample.gz >~/.nanorc
then
 nano ~/.nanorc
</pre>

To trim trailing whitespace from *.cc on Linux (taken from [this blog][3]):

<pre>find . -name '*.cc' -exec sed -i {} -e 's/[ \t]*$//' ';'</pre>

and on BSDs:

<pre>find . -name '*.cc' -exec sed -i '' -e 's/\ *$//' {} ';'</pre>

Linux style &#8216;ls&#8217; colours on FreeBSD (taken from [here][4]):

<pre>export CLICOLOR="YES"
export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
</pre>

To ensure the http_proxy environmental variable is passed to sudo. Edit the sudoers file by running visudo. Then add the following.

<pre>Defaults env_keep += "ftp_proxy http_proxy https_proxy"
</pre>

Bash autocompletion on FreeBSD:

<pre>cd  /usr/ports/shells/bash-completion
sudo make install clean
</pre>

Edit ~/.bashrc and add

<pre>if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi
</pre>

Make svn output colorful  
Edit ~/.subversion/config

<pre>[helpers]
diff-cmd = /usr/bin/colordiff
</pre>

Create diffs with function names and ignoring whitespace

<pre>svn diff -x -uwp
</pre>

To be continued&#8230;

 [1]: http://git-scm.com
 [2]: http://www.nano-editor.org/
 [3]: http://zebert.blogspot.com/2009/06/clean-up-trailing-whitespaces-in.html
 [4]: http://www.puresimplicity.net/~hemi/freebsd/misc.html