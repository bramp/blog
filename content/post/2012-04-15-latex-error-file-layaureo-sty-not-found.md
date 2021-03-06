---
title: 'LaTeX Error: File `layaureo.sty’ not found'
author: bramp
layout: post
date: 2012-04-15
disqus_identifier: 1614115227
categories:
  - Blog
tags:
  - debian
  - LaTeX
aliases:
  - /blog/2012/04/15/latex-error-file-layaureo-sty-not-found/
---
I was getting the error ``./cv.tex:11: LaTeX Error: File `layaureo.sty' not found.`` when trying to compile an [old tex document][1] of mine.

It seems layaureo is missing from [TexLive][2] 2009, the default on Debian at the moment (even though it&#8217;s 2012 now!). So I had to install TexLive 2011 from Debian Unstable using [Apt Pinning][3] to fix this problem.

Once TexLive 2011 is installed `apt-get install -t unstable texlive-lang-italian` to bring in the layaureo package.

I also encountered the following problems that was easier to resolve:

```
LaTeX Error: File `marvosym.sty' not found. solution: apt-get install texlive-fonts-recommended
LaTeX Error: File `fullpage.sty' not found. solution: apt-get install texlive-latex-extra
LaTeX Error: File `multibib.sty' not found. solution: apt-get install texlive-bibtex-extra
LaTeX Error: File `algorithm.sty' not found. solution: apt-get install texlive-science
```

 [1]: https://github.com/bramp/curriculum-vitae "Curriculum Vitae latex project"
 [2]: http://www.tug.org/texlive/ "TeX Live"
 [3]: http://wiki.debian.org/AptPreferences
 
