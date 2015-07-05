---
title: Using Make to parallelise a task
author: bramp
layout: post
date: 2012-09-09
categories:
  - Blog
tags:
  - make
aliases:
  - /blog/2012/09/09/uses-make-to-parallelise-a-task/
---
I needed to run a CPU intensive script over a directory of files. Each file would be run independently, and I was using bash to achieve this:

```bash
for $i in *.txt; do ./script $i; done
```

This works fine, however, I have a quad core machine, and this task was CPU bound on one core. So I thought about parallelising this task so the script would run on four files at once. I didn&#8217;t want to get into the nitty gritty of changing the script to cope in this way, so instead, I &#8220;abused&#8221; Make to do this. <!--more-->

I created a file named &#8220;Makefile&#8221; with the following:

```makefile
FILES=$(shell ls *.txt)

#default target of everything
all: $(FILES)

$(FILES):
	./script $@

.PHONY: all $(FILES)
```

then you just run ` make -j4 `, and four instances of the script will start running, with the concurrency being handled by Make. You can also now type `make a.txt b.txt c.txt` and it&#8217;ll just run the script on those three files.

You can also extend this Makefile to handle dependencies, such as running a script before all the others. Make is pretty powerful, and should be considered for more than just compiling programs.
