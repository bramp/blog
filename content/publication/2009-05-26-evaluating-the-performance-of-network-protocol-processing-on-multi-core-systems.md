---
title: Evaluating the Performance of Network Protocol Processing on Multi-core Systems
author: bramp
layout: publication
date: 2009-05-26
categories:
  - Publications
tags:
  - multicore
  - network
aliases:
  - /blog/2009/05/26/evaluating-the-performance-of-network-protocol-processing-on-multi-core-systems/
---
Matthew Faulkner and Andrew Brampton and Stephen Pink

In proceedings of the International Conference on Advanced Information Networking and Applications (AINA)

**This paper won the IEEE Best Paper award**

> **Abstract**
> 
> Improvements at the physical network layer have enabled technologies such as 10 Gigabit Ethernet. Single core end-systems are unable to fully utilise these networks, due to limited clock cycles. Using a Multi-core architecture is one method which increases the number of available cycles, and thus allow networks to be fully utilised. However, using these systems creates a new set of challenges for network protocol processing, for example, deciding how best to utilise many cores for high network performance. This paper examines different ways the cores of a multi-core system can be utilised, and, by experimentation, we show that in an eight core system deciding which cores to use is important. In one test, there was a 40% discrepancy in CPU utilisation depending on which cores were used. This discrepancy results from the resources each core shares, an example being the multi-hierarchy CPU caches, and to which bus the processors are connected.

[PDF Download][1]

 [1]: https://github.com/bramp/publication/raw/master/multi-core-networking/AINA-09/aina-09.pdf
 