---
title: Google Chrome Javascript console.log bug?
author: bramp
layout: post
date: 2011-08-02
permalink: /2011/08/02/google-chrome-javascript-consolelog-bug/
categories:
  - Blog
tags:
  - bug
  - Chrome
  - Javascript
---
I recently stumbled across this issue while debugging some Javascript. Take the following example code:

```javascript
var array = [1,2,3,4,5,6,7,8,9,10];
var i = 0;
while(array.length > 0) {
	console.log(i++, array);
	//alert("pause");
	array.pop();
}
```

If you run it in your browser you would expect to see the following printed (in your Javascript console):

```text
0 [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
1 [1, 2, 3, 4, 5, 6, 7, 8, 9]
2 [1, 2, 3, 4, 5, 6, 7, 8]
3 [1, 2, 3, 4, 5, 6, 7]
4 [1, 2, 3, 4, 5, 6]
5 [1, 2, 3, 4, 5]
6 [1, 2, 3, 4]
7 [1, 2, 3]
8 [1, 2]
9 [1]
```

However, I instead saw:

```text
1 []
2 []
3 []
4 []
5 []
6 []
7 []
8 []
9 []
```

The issue seems to be that console.log() does not log straight away. In fact it most likely logs in a background thread for performance reasons. Thus by the time it actually logs the array it has changed. I tested this in Firefox (with Firebug) and it logged everything correctly. I also tried slowing down the loop by adding a alert() call. That fixed the issue at the cost of a popup every iterations.

What really should happen is either

  * `console.log()` should block until the logging is complete
  * `console.log()` should copy all objects to avoid them being changed after log() returns but before they are printed.
  * add a `console.flush()` and make me aware this race condition could occur.

I filed this as a [bug report][1] on the Chromium site, but I suspect I should have filed it over at the Webkit site.

For the moment I came up with a &#8220;fix&#8221;. I copy the array before I log it, so in this case I do the following:

```javascript
console.log(i++, array.slice(0));
```

**Update:** I previously searched for this bug, but didn&#8217;t find it before writing this article. However, I have just found someone else had [reported][2] it a few days ago:

 [1]: https://code.google.com/p/chromium/issues/detail?id=91303
 [2]: https://code.google.com/p/chromium/issues/detail?id=50316
