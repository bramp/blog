---
title: Archive Mount
author: bramp
layout: post
date: 2011-11-08
categories:
  - Blog
tags:
  - archivemount
  - c
  - fuse
  - zip
aliases:
  - /blog/2011/11/08/archive-mount/
---
[Archive Mount][1] is a [FUSE application][2] that allows you to mount any zip/gz/bz/tar file (in fact anything that [libarchive][3] supports). This is very useful if you don&#8217;t want to get at the files inside a archive without extracting it.

In my use case I&#8217;m using Archive Mount with a zip file containing 10,000 files. This seemed to be very problematic as Archive Mount would take ~20 seconds to actually mount the zip file, and just as long to run a &#8220;ls&#8221; in the mounted directory.

So I downloaded the source, and started to make some tweaks to improve the performance. All my changes can be found on [github][4], and so far I&#8217;ve done the following:

  1. Fixed a couple of minor problems. [1][5] [2][6] 
  2. I made some tweaks to store the head child, as well as the last child. This improves the start up speed by ~20%. [3][7] 
  3. I also now store the basename as well as the full file name. This reduced the calls to strrchr, and actually had a measurable improvement (At the cost of using one additional pointer for each file). [4][8] 
  4. I also changed init\_node and free\_node a little bit. This simplified the code in places. [5][9] [6][10] 
  5. Finally, I actually completely replaced the linked list structure with a hash table. For small archives the speed difference is not noticeable, for large archives I had a 50x speed improvement! The awesome [uthash library][11] helped me do that. [7][12] 

I&#8217;m also currently working on a complete re-haul of the open/read code. Once done, I&#8217;ll be able to very efficiently open and read from files. At the moment a read bizarrely takes O(N) (where N is the number of files in the zip file), and then each read requires re-reading the entire file up until the seek point.

I&#8217;m sending all these changes [upstream][13], so hopefully my work will appear in your local copy of archivemount soon! Until then [follow my project on github][14].

 [1]: http://en.wikipedia.org/wiki/Archivemount
 [2]: http://en.wikipedia.org/wiki/Filesystem_in_Userspace
 [3]: http://code.google.com/p/libarchive/
 [4]: https://github.com/bramp/archivemount
 [5]: https://github.com/bramp/archivemount/commit/f173bb8766aed2ae62a53115c6f7a0a0a157b081
 [6]: https://github.com/bramp/archivemount/commit/457e8f9199d0829b247229eb3910d94c1d98263c
 [7]: https://github.com/bramp/archivemount/commit/882ff0979ec379b8e46e25c2bbf23ba0bbe19f6c
 [8]: https://github.com/bramp/archivemount/commit/10178dc167e06598468a644cb5b5469aac4ea098
 [9]: https://github.com/bramp/archivemount/commit/a996236177a8f742aa91cf8b5b90feb943d41ddd
 [10]: https://github.com/bramp/archivemount/commit/0c022825795c2394e8788f289a869f05be9537ce
 [11]: http://uthash.sourceforge.net/
 [12]: https://github.com/bramp/archivemount/commit/1f152876b1f39f53622d89d7fbb7b34fd70cfd10
 [13]: http://www.cybernoia.de/software/archivemount/
 [14]: https://github.com/bramp/archivemount/
