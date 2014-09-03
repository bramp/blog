---
title: Building PHP’s Debian package nightmare
author: bramp
layout: post
date: 2011-11-22
permalink: /2011/11/22/building-phps-debian-package-nightmare/
categories:
  - Blog
tags:
  - build
  - debian
  - Linux
  - PHP
---
I just tried to compile the Debian PHP packages, so I could make some [minor tweaks][1] to the source, to fix a bug I&#8217;m hopefully going to document shortly. This turned out to be very problematic, mainly due to the testing phase!

To build the Debian packages you typically do the following:

<pre class="prettyprint">mkdir php
cd php
apt-get source php5
cd php5-*
debuild -us -uc -j4
</pre>

While testing, the debian/setup_mysql.sh script is called, to create a temporary MySQL database. This however failed to execute correctly because I had some custom options in my [~/.my.cnf][2]. Thus it failed like so:

<pre># start our own mysql server for the tests
/bin/sh debian/setup-mysql.sh 1029 /home/bramp/vendor/php/php5-5.3.8.0/mysql_db
mysqladmin: connect to server at 'localhost' failed
error: 'Access denied for user 'root'@'localhost' (using password: YES)'
make: *** [test-results.txt] Error 1
dpkg-buildpackage: error: debian/rules build gave error exit status 2
debuild: fatal error at line 1348:
dpkg-buildpackage -rfakeroot -D -us -uc -j8 failed
</pre>

After removing the my.cnf things were ok. The below patch fixes it in a more general way:

<pre class="prettyprint">--- debian/setup-mysql.sh.org	2011-11-21 21:57:07.244481175 -0500
+++ debian/setup-mysql.sh	2011-11-21 21:40:39.384455880 -0500
@@ -16,7 +16,7 @@
 
 socket=$datadir/mysql.sock
 # Commands:
-mysqladmin="mysqladmin -u root -P $port -h localhost --socket=$socket"
+mysqladmin="mysqladmin --no-defaults -u root -P $port -h localhost --socket=$socket"
 mysqld="/usr/sbin/mysqld --no-defaults --bind-address=localhost --port=$port --socket=$socket --datadir=$datadir"
 
 # Main code #
</pre>

The next problem I encountered is that all the automated PHP unit tests were failing, and they would eventually get stuck and use all my RAM and swap space (at least 16GiB of it) <img src="http://bramp.net/blog/wp-includes/images/smilies/icon_sad.gif" alt=":(" class="wp-smiley" /> I&#8217;m not sure what made the machine run out of RAM, but the tests were failing because the version of PHP that was running the tests was incorrectly loading extensions from my system. The quick fix for this was to disable any extensions I had installed to my system. I just 

<pre>sudo mv /etc/php5/conf.d /etc/php5/conf.d.tmp</pre>

to do that.

This made me think that in future I should perhaps find a cleaner environment to build these packages. In fact, it makes me wonder if the builds are just broken if my environment clearly impacts the successful run of tests.

One trick I found while building again and again, is that you can pass &#8220;-nc&#8221; to debuild so that it does not clean, and thus reuses the existing build materials for a faster build. Either way, I now have my own version of PHP built and installed! Next time I might just ignore the .deb files and build direct from source.

 [1]: http://www.howtoforge.com/recompiling-php5-with-bundled-support-for-gd-on-ubuntu
 [2]: http://dev.mysql.com/doc/refman/5.1/en/option-files.html