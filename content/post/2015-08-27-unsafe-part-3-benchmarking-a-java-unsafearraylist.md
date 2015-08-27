---
title: "Unsafe Part 3: Benchmarking a java UnsafeArrayList"
author: bramp
categories:
- Blog
date: 2015-08-27T20:39:04-07:00
layout: post
tags:
- unsafe
- java
draft: true
---

Previously we introduced a [UnsafeArrayList][1], a ArrayList style collection that instead of storing references to the objects, it would copy them into heap allocated memory. This has the unique property of keeping all objects contiguous in memory, and avoids a pointer indirection, at the cost of needing to copy values in and out. I would argue that the copy cost is minor, as it is effectively prefetching the object’s fields into the CPU cache. Saving a memory load when the field is actually used (most likely shortly after it is pulled from the list). However, instead of speculating, this article aims to benchmark the list.

## Methodology
To test the performance of this new style of list, a series of benchmarks were devised. The new [JMH benchmark framework][3] was used, and final benchmark code is [available here][2].

Multiple iterations were run, and unless stated results were calculated with a 99% confidence interval. A couple of warmup iteration were always run and discarded. All tests were run on a Ubuntu Linux 3.19.0-22 desktop, with a 64bit Intel® Core™ i3-2125 CPU @ 3.30GHz, and 16 GiB of 1333 MHz DDR3 RAM. The JVM was OpenJDK (version 1.8.0_45-internal).

For each benchmark new ArrayLists and UnsafeArrayLists were constructed, and populated with newly created objects. The size of the lists were varied, up to a maximum that could be held in memory without disk swapping. Two artificial workloads were created,

1. Reading items from the lists start to finish, and
2. Processing the elements in a random order.

The first was reproduced by simply reading the first field of every element of the list in order, and the second by sorting the list based on the object’s fields (with a simple quicksort).

Three test classes of different sizes were created to be stored within the ArrayLists, one class had two long fields, one had four long fields, and finally one with eight long fields . Named TwoLongs, FourLongs and EightLongs requiring 16, 32, and 64 bytes for the fields respectively. Each iteration these classes were created with random values in the fields.

## The Results

<table class="table table-hover table-striped table-condensed">
	<thead>
		<tr><th>Benchmark</th><th>List</th><th>Type</th><th>Size</th><th class="text-center">Mean Time (s)</th></tr>
	</thead>
	<tbody>
		<tr><td>Iterate</td><td>ArrayList</td><td>TwoLongs</td><td>80,000,000</td><td class="text-center">2.266 ± 0.229</td></tr>
		<tr><td>Iterate</td><td>UnsafeArrayList</td><td>TwoLongs</td><td>80,000,000</td><td class="text-center">1.79 ± 0.03</td></tr>
		<tr><td>IterateInPlace</td><td>UnsafeArrayList</td><td>TwoLongs</td><td>80,000,000</td><td class="text-center">0.442 ± 0.023</td></tr>
		<tr><td></td><td></td><td></td><td></td><td></td></tr>
		<tr><td>Iterate</td><td>ArrayList</td><td>FourLongs</td><td>80,000,000</td><td class="text-center">2.277 ± 0.211</td></tr>
		<tr><td>Iterate</td><td>UnsafeArrayList</td><td>FourLongs</td><td>80,000,000</td><td class="text-center">2.126 ± 0.019</td></tr>
		<tr><td>IterateInPlace</td><td>UnsafeArrayList</td><td>FourLongs</td><td>80,000,000</td><td class="text-center">0.648 ± 0.019</td></tr>
		<tr><td></td><td></td><td></td><td></td><td></td></tr>
		<tr><td>Iterate</td><td>ArrayList</td><td>EightLongs</td><td>80,000,000</td><td class="text-center">2.792 ± 0.072</td></tr>
		<tr><td>Iterate</td><td>UnsafeArrayList</td><td>EightLongs</td><td>80,000,000</td><td class="text-center">2.672 ± 0.322</td></tr>
		<tr><td>IterateInPlace</td><td>UnsafeArrayList</td><td>EightLongs</td><td>80,000,000</td><td class="text-center">0.941 ± 0.032</td></tr>
		<tr><td></td><td></td><td></td><td></td><td></td></tr>
		<tr><td>Sort</td><td>ArrayList</td><td>TwoLongs</td><td>80,000,000</td><td class="text-center">70.31 ± 3.939</td></tr>
		<tr><td>Sort</td><td>ArrayList</td><td>FourLongs</td><td>80,000,000</td><td class="text-center">79.673 ± 6.119</td></tr>
		<tr><td>Sort</td><td>ArrayList</td><td>EightLongs</td><td>80,000,000</td><td class="text-center">97.687 ± 4.86</td></tr>
		<tr><td></td><td></td><td></td><td></td><td></td></tr>
		<tr><td>Sort</td><td>UnsafeArrayList</td><td>TwoLongs</td><td>80,000,000</td><td class="text-center">18.69 ± 3.158</td></tr>
		<tr><td>Sort</td><td>UnsafeArrayList</td><td>FourLongs</td><td>80,000,000</td><td class="text-center">24.822 ± 0.79</td></tr>
		<tr><td>Sort</td><td>UnsafeArrayList</td><td>EightLongs</td><td>80,000,000</td><td class="text-center">40.697 ± 0.743</td></tr>
	</tbody>
</table>

### Iterate
Starting with the smallest test object, TwoLongs, to read the first field of all 80 million  elements within an ArrayList took on average 2.266 ± 0.229 seconds. To do the same with the UnsafeArrayList (which doesn’t store objects, and instead copies elements in/out) took on average 1.79 ±0.03 seconds (an 24% improvement).

Remember in the [previous article][1], UnsafeArrayList has two methods for retrieving an element `T get(int index)` and a `T get(T dest, int index)`. The former creates a new object and copies the fields. The latter copies the fields in place of a given destination object, allowing the reuse of a single temp object, and avoiding creations of new objects, thus is labelled "InPlace" in the above results.

It is therefore surprising that the UnsafeArrayList can iterate 24% faster than an ArrayList, when it has the additional overhead of creating an object, and copying fields into it. Compared to an ArrayList which is just reading existing objects.

Some theory is needed to understand what might be happening here. A modern CISC CPU can execute an instruction in a few clock cycles, let's say ~0.5 nanoseconds, however, reading from RAM takes ~10 nanoseconds. While the CPU is waiting for the response from RAM it is effectively blocked. To compensate the CPU deploys a few tricks, two of which could be helping here. Firstly, the CPU tries to predicting and prefetch the next memory request. Secondly, the CPU will execute instructions out of order, thus not waiting for the memory if a later instruction does not depend on the read. 

In the ArrayList case, the array of reference is stored in contiguous memory. However, the actual objects (that the references point to) could be anywhere in RAM. As the program loops through it is making reads from effectively random locations in memory, that can’t be predicted, and thus stalls the CPU.

There is no doubt in the UnsafeArrayList the CPU is prefetching the next elements before it is needed. Additionally the cost of creating these short lived objects is most likely very small because they live and die in eden space and are thus simple to create and garbage collect. I also would not be surprised if the CPU or the JIT compiler was able to do [some kind of vectorising][11] on the input. That is, concurrently operating on multiple entries at the same time.

If we then test the `T get(T dest, int index)` method (labelled IterateInPlace), it can iterate through the array in an impressive 0.442 ±0.023 seconds. That’s 5 times faster than the ArrayList, and 4 times faster than the `T get(int index)`. This is certainly because the objects are not created for each get.

It was not measured here, but it is possible to confirm what the CPU is doing, by using [hardware based performance counters][4]. These are special registers within the CPU that can be configured to measure cache hit/miss rates, prefetches, instructions per cycle, and many other metrics. These can be invaluable to understand what’s truly going on, as in most cases humans are bad at understanding performance bottlenecks through intuition alone. Tools such as [oprofile][5], [perf][6], [dtrace][7] and [systemtap][8] can be used for this.

To do a quick sanity check, in the ArrayList case it takes an average of 28.325 nanoseconds per element. [According to wikipedia][9] it takes between 9.00-18.75 nanoseconds to read from DDR3 memory at 1333 Mhz. Thus this number doesn’t seem unexpected, as the ArrayList has to issue two memory reads, firstly reading sequentially from an array of references, and then reading from the object (which is at an unpredictable address).

With the UnsafeArrayList in-place test, it takes an average of 5.53 nanoseconds per element. As the fields are stored contiguously in memory, the CPU can efficiency pipeline the requests, amortizing the 9-18 ns memory read cost. Here the speed is most likely limited by either the memory’s bandwidth, or the CPU’s clock cycles.  To read 80 million memory addresses in 0.442 seconds, requires 180 Megatransfers per second, and assuming each object is two longs, or 16 bytes requires ~2.68 GiB/s of throughput. Neither of those values approach the upper limit of what DDR3 is capable of, thus I suspect the time is a combination of this and CPU instructions.

### Sorting
The second benchmark measured the speed at which the lists could be read and written to somewhat randomly, and in particular sorted. This should cause a less predictable reads from memory.  To sort 80 million elements in the ArrayList took 70.31 ±3.939 seconds, and only 18.69 ±3.158 seconds for the UnsafeArrayList using the in-place get. The relative times is not as impressive as the previous test, but still the UnsafeArrayList is ~3.7 times as quick.  I’m unsure exactly why the UnsafeArrayList would be faster, but I suspect it is related to the fewer memory indirections, and prefetching effect the copying of fields has.

It’s also worth noting, the increase performance becomes less profound as the size of the stored class increases. For the FourLong the difference between ArrayList and UnsafeArrayList is 3.2x, and for EightLong the difference is 2.4x. This can easily be explained by the increasing cost of copying the fields in and out of the list.

### Other observations
Overlooked is the smaller memory requirements for the UnsafeArrayList. A TwoLong instance is 16 bytes of data, plus 16 bytes of JVM object header. Thus an ArrayList of 40 million instances take 2.4 GiB of RAM (32 bytes x 80M), plus an additional 305MiB for an array of 80 million references (assuming [compressed object pointers][12] takes 4 bytes each). Totalling 2.68 GiB, whereas the UnsafeArray takes 16 bytes per entry, totaling only 1.2GiB (roughly half the size!).

Of course if the array is holding larger classes (such as the EightLong), the per object overhead is smaller, in these cases 6.25GiB vs 4.76GiB, roughly 75% the size.

One last observation of interest is the confidence intervals for the results. A larger error implies more variability in the test runs. For example, if the garbage collector ran during some of the runs, and slowed down the test, it would increase this error. In all the tests using the UnsafeArrayList in-place methods, the confidence interval is smaller, implying more constancy and predictability. This can be important in certain situations, such as real-time systems.

## Conclusion
We benchmarked the [UnsafeArrayList][10], against a normal ArrayList in two artificial workloads. We found that in both the start-to-finish iteration, and in the sorting case, that the UnsafeArrayList was 4-5x faster than its counterpart. This result itself is interesting when designing high performance data structures, however, the use of [sun.misc.Unsafe][13] is considered dangerous, and thus the performance comes with many caveats and risks. In fact, it was recently announced that the [Unsafe class is being deprecated and hidden in java 9][14]. So instead, this was just an insightful journey into how the CPU can optomise particular workloads, and how Java can be pushed to extreme speeds.

Your results may vary, and as always you should benchmark your exact workload instead of a hypothetical one, but this was still an interesting experiment.

[1]: https://blog.bramp.net/post/2015/08/26/unsafe-part-2-using-sun.misc.unsafe-to-create-a-contiguous-array-of-objects/
[2]: https://github.com/bramp/unsafe/tree/master/unsafe-benchmark
[3]: http://openjdk.java.net/projects/code-tools/jmh/
[4]: https://en.wikipedia.org/wiki/Hardware_performance_counter
[5]: http://oprofile.sourceforge.net/
[6]: https://perf.wiki.kernel.org/index.php/Main_Page
[7]: https://en.wikipedia.org/wiki/DTrace
[8]: https://sourceware.org/systemtap/
[9]: https://en.wikipedia.org/wiki/CAS_latency
[10]: https://bramp.github.io/unsafe/index.html?net/bramp/unsafe/UnsafeHelper.html
[11]: https://en.wikipedia.org/wiki/Automatic_vectorization
[12]: https://docs.oracle.com/javase/7/docs/technotes/guides/vm/performance-enhancements-7.html#compressedOop
[13]: http://www.docjar.com/docs/api/sun/misc/Unsafe.html
[14]: http://blog.dripstat.com/removal-of-sun-misc-unsafe-a-disaster-in-the-making/
