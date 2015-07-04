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

```bash
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
```

Make [nano][2] colourful

```bash
cp /usr/local/share/examples/nano/nanorc.sample ~/.nanorc
# or
zcat /usr/share/doc/nano/examples/nanorc.sample.gz >~/.nanorc

# then
nano ~/.nanorc
```

To trim trailing whitespace from *.cc on Linux (taken from [this blog][3]):

```bash
find . -name '*.cc' -exec sed -i {} -e 's/[ \t]*$//' ';'
```

and on BSDs:

```bash
find . -name '*.cc' -exec sed -i '' -e 's/\ *$//' {} ';'
```

Linux style &#8216;ls&#8217; colours on FreeBSD (taken from [here][4]):

```bash
export CLICOLOR="YES"
export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
```

To ensure the http_proxy environmental variable is passed to sudo. Edit the sudoers file by running visudo. Then add the following.

```bash
Defaults env_keep += "ftp_proxy http_proxy https_proxy"
```

Bash autocompletion on FreeBSD:

```bash
cd  /usr/ports/shells/bash-completion
sudo make install clean
```

Edit ~/.bashrc and add

```bash
if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi
```

Make svn output colorful  
Edit ~/.subversion/config

```ini
[helpers]
diff-cmd = /usr/bin/colordiff
```

Create diffs with function names and ignoring whitespace

```bash
svn diff -x -uwp
```

To be continued&#8230;

 [1]: http://git-scm.com
 [2]: http://www.nano-editor.org/
 [3]: http://zebert.blogspot.com/2009/06/clean-up-trailing-whitespaces-in.html
 [4]: http://www.puresimplicity.net/~hemi/freebsd/misc.html
 