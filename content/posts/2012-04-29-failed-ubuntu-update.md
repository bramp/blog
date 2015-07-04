---
title: Failed Ubuntu update
author: bramp
layout: post
date: 2012-04-29
permalink: /2012/04/29/failed-ubuntu-update/
categories:
  - Blog
tags:
  - ubuntu
---
While trying to do a &#8220;do-release-upgrade&#8221;, to upgrade to [Ubuntu Precise][1], I encountered a error that Google did not find a satisfactory answer for:

```text
An unresolvable problem occurred while calculating the upgrade:
E:Error, pkgProblemResolver::Resolve generated breaks, this may be caused by held packages.

This can be caused by:
* Upgrading to a pre-release version of Ubuntu
* Running the current pre-release version of Ubuntu
* Unofficial software packages not provided by Ubuntu

If none of this applies, then please report this bug using the command 'ubuntu-bug update-manager' in a terminal.
```

The problem was I had some packages installed that had no upgrade path, that is, are not available in Precise. To debug this I looked in the `/var/log/dist-upgrade/apt.log` file, and it identifies the packages that were &#8220;broken&#8221;. I just had to &#8220;apt-get remove&#8221; them, do the release upgrade, and afterwards I could reinstall them.

Problem solved.

 [1]: http://releases.ubuntu.com/12.04/
 