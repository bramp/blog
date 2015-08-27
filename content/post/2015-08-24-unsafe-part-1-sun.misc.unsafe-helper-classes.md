---
title: "Unsafe Part 1: sun.misc.Unsafe Helper Classes"
author: bramp
categories:
- Blog
date: 2015-08-24T20:13:58-07:00
layout: post
tags:
- unsafe
- java
---

I recently came across the [sun.misc.Unsafe class][1], a poorly documented, internal API that gives your java program direct access to the JVM’s memory. Of course accessing the JVM’s memory can be considered unsafe, but allows for some exciting opportunities.

You can use Unsafe to inspect and manipulate the layout of your objects in RAM, allocate memory off the heap, do interesting things with threads, or even [hack in multiple inheritance][2]. Multiple people have [written about Unsafe][3] before, and there are some really [good articles][4], so we won’t cover it here.

Using unsafe is not too difficult, but I found the need for a few helper methods, thus I created a collection of classes wrapping the Unsafe code, starting with [UnsafeHelper][10]. The main methods of interest are [getUnsafe()][11], [sizeOf()][12], [firstFieldOffset()][13], [toByteArray()][14] and [hexDump()][15]. The [javadoc][9] is the best place to look for documentation, however I’ll quickly explain their use.

To get an sun.misc.Unsafe instance, you have to extract it from a private static field within sun.misc.Unsafe class. For ease, the [UnsafeHelper.getUnsafe()][11] method does that.

When accessing an object, you typically need to know the size of the object (in bytes), and be able to find the offset to individual fields. If you [understand the memory layout][5] the JVM uses, you’ll know there is a header in front of the Object’s fields. Typically it looks like this, but varies based on CPU architecture, platform, etc:

<table class="table table-bordered" style="margin-bottom: 0px">
  <tr>
    <th class="text-center">0</th>
    <th class="text-center">1</th>
    <th class="text-center">2</th>
    <th class="text-center">3</th>
    <th class="text-center">4</th>
    <th class="text-center">5</th>
    <th class="text-center">6</th>
    <th class="text-center">7</th>
    <th class="text-center">8</th>
    <th class="text-center">9</th>
    <th class="text-center">10</th>
    <th class="text-center">11</th>
    <th class="text-center">12</th>
    <th class="text-center">13</th>
    <th class="text-center">14</th>
    <th class="text-center">15</th>
  </tr>
  <tr>
    <td class="text-center" colspan="8">mark word(8)</td>
    <td class="text-center" colspan="4">klass pointer(4)</td>
    <td class="text-center" colspan="4">padding</td>
  </tr>
</table>
<div class="text-right">More information [here][6] and [here][7].</div>

To hide some of the details, [headerSize()][16] returns the size of the header, and [sizeOf()][12] return the total size an object including the header in bytes. [firstFieldOffset()][13] is then useful as it provides the the offset to the first field. Note that [headerSize()][16] and [firstFieldOffset()][13] do not always return identical results, as padding (not part of the header) may be used to correctly align the first field.

Next [toByteArray()][14] will take an object, and copy it (and its header) into a byte array. Useful for easily inspecting, and serialising the object. Finally, [hexDump()][15] uses the [toByteArray()][14] to grab an object, and print out a hex representation of the memory, for example:

```java
/**
 * hexDump(new Class4()) prints:
 * 0x00000000: 01 00 00 00 00 00 00 00  8A BF 62 DF 67 45 23 01
 */
static class Class4 {
    int i = 0x01234567;
}

/**
 * Longs are always 8 byte aligned, so 4 bytes of padding
 * hexDump(new Class8()) prints:
 * 0x00000000: 01 00 00 00 00 00 00 00  9B 81 61 DF 00 00 00 00
 * 0x00000010: EF CD AB 89 67 45 23 01
 */
static class Class8 {
    long l = 0x0123456789ABCDEFL;
}
```

In the first example, Class4, a simple class with a single int field, takes up 16 bytes of memory, with the first 8 used by the JVM, the 2nd 4 bytes being a class pointer (basically how the object knows what kind of class it is), and the last four actually being the value of the field. The second example shows a similar header, but with bytes 12-16 being used as padding, so that the long field value is 8 byte aligned.

These helper methods are available in [new project on Github][8], and downloadable via Maven. Just [download the jar file][17], or include a maven dependency, and ```import net.bramp.unsafe.UnsafeHelper```.

```xml
<dependency>
    <groupId>net.bramp.unsafe</groupId>
    <artifactId>unsafe-helper</artifactId>
    <version>1.0</version>
</dependency>
```

[Next article][18], we'll make use of this new UnsafeHelper to build a special List which copies objects, instead of storing references.

[1]: http://www.docjar.com/docs/api/sun/misc/Unsafe.html
[2]: http://mishadoff.com/blog/java-magic-part-4-sun-dot-misc-dot-unsafe/
[3]: https://dzone.com/articles/understanding-sunmiscunsafe
[4]: http://mydailyjava.blogspot.com/2013/12/sunmiscunsafe.html
[5]: http://www.codeinstructions.com/2008/12/java-objects-memory-structure.html
[6]: http://www.codeinstructions.com/2008/12/java-objects-memory-structure.html
[7]: http://stackoverflow.com/a/17348396/88646
[8]: https://github.com/bramp/unsafe
[9]: https://bramp.github.io/unsafe/
[10]: https://bramp.github.io/unsafe/index.html?net/bramp/unsafe/UnsafeHelper.html
[11]: https://bramp.github.io/unsafe/net/bramp/unsafe/UnsafeHelper.html#getUnsafe--
[12]: https://bramp.github.io/unsafe/net/bramp/unsafe/UnsafeHelper.html#sizeOf-java.lang.Object-
[13]: https://bramp.github.io/unsafe/net/bramp/unsafe/UnsafeHelper.html#firstFieldOffset-java.lang.Class-
[14]: https://bramp.github.io/unsafe/net/bramp/unsafe/UnsafeHelper.html#toByteArray-java.lang.Object-
[15]: https://bramp.github.io/unsafe/net/bramp/unsafe/UnsafeHelper.html#hexDump-java.io.PrintStream-java.lang.Object-
[16]: https://bramp.github.io/unsafe/net/bramp/unsafe/UnsafeHelper.html#headerSize-java.lang.Object-
[17]: https://oss.sonatype.org/service/local/repositories/releases/content/net/bramp/unsafe/unsafe-helper/1.0/unsafe-helper-1.0.jar
[18]: https://blog.bramp.net/post/2015/08/26/unsafe-part-2-using-sun.misc.unsafe-to-create-a-contiguous-array-of-objects/
