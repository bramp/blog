---
title: "Unsafe Part 2: Using sun.misc.Unsafe to create a contiguous array of objects"
author: bramp
categories:
- Blog
date: 2015-08-26T17:51:02-07:00
layout: post
tags:
- unsafe
- java
---

I recently came across an article from the [Mechanical Sympathy blog][1], that used the [flyweight pattern][2] to build a “compact off-heap” array of objects. They basically allocated an area of memory large enough to store N copies of their object. Then using a single instance of a proxy object, would pack/unpack fields into this memory. For example, let's say we needed to store an array of [Point][3] objects. We could construct a simple array like so:

```java
Point[] points = new Point[N];
```

The inefficiency here is that each instance of a Point requires 12-16 bytes of overhead to store metadata about the object (such as class, GC state, etc), and each additional instance adds to the cost of garbage collection. Additionally, the array actually contains references to Point objects stored elsewhere in RAM. These references require a memory indirection when accessing the actual instances.

In the [Mechanical Sympathy][1] article, they instead packed all the fields of the instances into a contiguous array. For simplification I changed their example, but it was something like this:

```java
int[] memory = new int[N*2];

class ProxyPoint {
    private int index = 0;

    public void setIndex(int index) {
        this.index = index;
    }

    public int getX() {
    	return memory[index*2 + 0]
    }

    public int getY() {
    	return memory[index*2 + 1]
    }
}
```

With this approach there is no overhead for each Point object (as there is only ever one PointProxy, and one array). This also has the interesting property that the fields for all the Points are stored in the same contiguous region of memory.  Which leads to some great cache/CPU benefits. For example, if you read all the points sequentially, adjacent objects share the same CPU cache line, and the CPU can predictably prefetch the next point. This would not be possible with an array of references to Points, as each Point could potentially be stored anywhere in RAM.

Now with this primer, it would be interesting to have a normal Java [List][4] that stored fields packed together like this. The above solution only works if you create a proxy object ahead of time knowing what class you would be storing. Using the recently released [UnsafeHelper class][9] ([discussed previously][10]), I went about to build something that looked like a standard generic ArrayList, that could store any type. But with the benefit of storing all elements in contiguous region of memory.

The final solution is [UnsafeArrayList.java][5]. This implements the Java List interface, but instead of storing references to objects, it copies the object into a contiguous region of memory. If you are a C++ programmer, you can think of this as a `std::vector<Point>` instead of a `std::vector<Point*>`. This minor change comes with it’s own pros and cons, outlined later.

To begin with the list is constructed like so `new UnsafeArrayList<Point>(Point.class)`. The `Point.class` is passed in so that the list knows what kind of objects it will be storing. This is required due to a limitation in Java’s implementation of generics, that makes it [impossible for a class to know its own generic type][6].

The constructor begins by calculating the size of an instance, and uses the UnsafeHelper to calculates the offset to the first field within an instance.

```java
public UnsafeArrayList(Class<T> type, int capacity) {
    this.firstFieldOffset = UnsafeHelper.firstFieldOffset(type);
    this.elementSize      = UnsafeHelper.sizeOf(type) - firstFieldOffset;
    this.unsafe           = UnsafeHelper.getUnsafe();
```

An area of memory is then allocated, like so:

```java
    base = unsafe.allocateMemory(elementSize * capacity);
```

This base variable holds the address to the beginning of the memory, and can only be used via the Unsafe class. The memory is large enough to hold `capacity` objects of `elementSize` bytes. 

Unlike a Java reference, this base address allows [pointer arithmetic][7], and thus to access a particular element we have a simple method to calculate the memory offset:

```java
    private long offset(int index) {
        return base + (index * elementSize);
    }
```

Then to [set][12] an element within this List, we copy its fields into the allocated memory:

```java
    @Override
    public T set(int index, T element) {
        unsafe.copyMemory(element, firstFieldOffset, // src, src_offset
                          null, offset(index),       // dst, dst_offset
                          elementSize);              // size
```

This copies from object `element`, starting at offset `firstFieldOffset`, into the raw memory address determined by `offset(index)`.

The [get][11] method is a little more problematic, as the List interface expects get to return an instance of the object. Since we aren’t actually storing references to the objects (but copies of their fields), we need to construct an instance and populate it. This is quite costly, and defeats the point of this UnsafeArrayList. Instead an additional [get][13] method is provided, that allows an object to be passed in, which will have its fields replaced.

```java
    public T get(T dest, int index) {
        unsafe.copyMemory(null, offset(index),
                          dest, firstFieldOffset,
                          elementSize);
        return dest;
    }
```

For completeness a standard `get(int index)` method is provided, which creates a new instance of the object (using unsafe.allocateInstance() instead of `new Type`).

```java
    public T get(int index) {
        return get((T) unsafe.allocateInstance(type), index);
    }
```

You can inspect the rest of the [code via GitHub][8], but these are the main parts.

In conclusion, this approach has some pros and cons, but was mostly created for fun.

* Pros
 * List<> interfaces that stores objects in contiguous memory
 * Better cache locality and CPU performance
 * Minimal memory overhead

* Cons
 * Uses sun.misc.Unsafe
 * Additional CPU cycles needed to copies objects in and out of array
 * Copies the class out of the garbage collector’s view, thus if a stored object contains the only references to other objects, the garbage collector will not know it is still used.

In the [next article][14], we'll benchmark this UnsafeArrayList, and investigate the performance impact of the cache locality, and other overheads.

[1]: http://mechanical-sympathy.blogspot.com/2012/10/compact-off-heap-structurestuples-in.html
[2]: https://en.wikipedia.org/wiki/Flyweight_pattern
[3]: https://docs.oracle.com/javase/7/docs/api/java/awt/Point.html
[4]: https://docs.oracle.com/javase/8/docs/api/java/util/List.html
[5]: https://bramp.github.io/unsafe/index.html?net/bramp/unsafe/UnsafeArrayList.html
[6]: http://stackoverflow.com/q/182636/88646
[7]: https://www.cs.umd.edu/class/sum2003/cmsc311/Notes/BitOp/pointer.html
[8]: https://github.com/bramp/unsafe/blob/master/unsafe-collection/src/main/java/net/bramp/unsafe/UnsafeArrayList.java
[9]: https://bramp.github.io/unsafe/index.html?net/bramp/unsafe/UnsafeHelper.html
[10]: https://blog.bramp.net/post/2015/08/24/unsafe-part-1-sun.misc.unsafe-helper-classes/
[11]: https://bramp.github.io/unsafe/net/bramp/unsafe/UnsafeArrayList.html#get-int-
[12]: https://bramp.github.io/unsafe/net/bramp/unsafe/UnsafeArrayList.html#set-int-T-
[13]: https://bramp.github.io/unsafe/net/bramp/unsafe/UnsafeArrayList.html#get-T-int-
[14]: https://blog.bramp.net/post/2015/08/27/unsafe-part-3-benchmarking-a-java-unsafearraylist/
