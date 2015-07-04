---
title: Android Linux SDK revision 6 aapt library bug
author: bramp
layout: post
date: 2010-05-23
permalink: /2010/05/23/android-sdk-r6-aapt-library-bug/
categories:
  - Blog
tags:
  - aapt
  - android
  - bug
  - sdk
---
**UPDATE &#8211; I [reported this bug][1] and it was promptly fixed the next day. Read the [bug report][1] for solution on how to fix.**

[Android 2.2][2] just came out and along with it came a updated set of [SDK tools][3]. I&#8217;ve been using these tools on Windows, but today I took my Linux laptop out and I&#8217;ve been sat in a [coffee shop][4] hyped up on caffeine but completely unproductive because I&#8217;m going round in circles with what I think is a bug.

So, I&#8217;m trying the [new library feature][5], where you can have a Android library project, which is referenced by one or more Android projects. This allows multiple projects to easily share the same code. The problem is when I set-up my Android project to use a library project I get the following error printed in my eclipse console:

```text
ERROR: Unknown option '--auto-add-overlay'
Android Asset Packaging Tool
```

and the code fails to compile. If I remove the reference to the library project this error goes away.

The error is coming from the aapt command, which seems to be installed multiple times, once for each SDK version:

```bash
$ locate -r "aapt$"
/home/bramp/android-sdk-linux_86/platforms/android-3/tools/aapt
/home/bramp/android-sdk-linux_86/platforms/android-4/tools/aapt
/home/bramp/android-sdk-linux_86/platforms/android-7/tools/aapt
/home/bramp/android-sdk-linux_86/platforms/android-8/tools/aapt
```

Checking each command I see that only versions 7 and 8 have the *&#8211;auto-add-overlay* option. Both my library and main projects are targeted at Android 1.6 (i.e. android-4). I tried re-targeting my main project to Android 2.2 (i.e. android-8) and the problem seems to go away.

So for the moment this seems an annoyance, but I can live with it by setting my target to 2.2. Hopefully Google will release a fix so I can still use the older targets with the new library feature.

**Just a quick update:**  
I noticed that on Windows all versions of the aapt tool support the &#8216;&#8211;auto-add-overlay&#8217; option. So what I suspect has happened is that someone forgot to update the aapt binary for the old platforms.

 [1]: http://code.google.com/p/android/issues/detail?id=8498
 [2]: http://android-developers.blogspot.com/2010/05/android-22-and-developers-goodies.html
 [3]: http://developer.android.com/sdk/tools-notes.html
 [4]: http://www.juicafe.co.uk/
 [5]: http://developer.android.com/guide/developing/other-ide.html#libraryProject
 