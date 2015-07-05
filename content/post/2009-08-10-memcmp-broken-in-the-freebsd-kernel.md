---
title: memcmp broken in the FreeBSD kernel
author: bramp
layout: post
date: 2009-08-10
categories:
  - Blog
tags:
  - FreeBSD
  - kernel
  - memcmp
aliases:
  - /2009/08/10/memcmp-broken-in-the-freebsd-kernel/
---
I&#8217;ve spent a day tracking down a bug in a FreeBSD kernel module I&#8217;m developing, and to my surprise the bug was due to memcmp being broken! For those that don&#8217;t know, memcmp is used to compare two byte strings and returns 0 if they are identical, a negative number of the first string is less than the second, and a positive number of the first string is greater than the second.

However, the implementation of memcmp in the FreeBSD kernel looks like this:

```c
static __inline int
memcmp(const void *b1, const void *b2, size_t len) {
    return (bcmp(b1, b2, len));
}
```

The problem with this is that bcmp is defined to return 0 if the strings are identical, otherwise returns a non-zero integer. This is not the same as memcmp, and you would only notice this if you are testing the signedness of the return value. I suspect this has not been noticed because traditionally FreeBSD has favoured bcmp, and in the few cases it does uses memcmp it only compares it with zero.

There is some good news, obrien@ noticed this problem in September 2008 and commited a patch (svn r183299). However, it looks like this fix won&#8217;t be included until FreeBSD 8.0. In the mean time I&#8217;m implementing a minor hack to fix this.

```c
int my_memcmp(const void *s1, const void *s2, size_t n) {
	if (n != 0) {
		const unsigned char *p1 = s1, *p2 = s2;

		do {
			if (*p1++ != *p2++)
				return (*--p1 - *--p2);
		} while (--n != 0);
	}
	return (0);
}
#define memcmp my_memcmp
```