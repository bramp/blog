---
title: 'Stealth Distributed Hash Table: A robust and flexible super-peered DHT'
author: bramp
layout: publication
date: 2006-12-01
categories:
  - Publications
tags:
  - stealthdht
aliases:
  - /blog/2006/12/01/stealth-distributed-hash-table-a-robust-and-flexible-super-peered-dht/
---
Andrew Brampton, Andrew MacQuire, Idris A. Rai, Nicholas J. P. Race, and Laurent Mathy.

In proceedings of the 2nd Conference on Future Networking Technologies (CoNEXT&#8217;06)

> **Abstract**
> 
> Most Distributed Hash Tables (DHTs) simply consider interconnecting homogeneous nodes on the same overlay. However, realistically nodes on a network are heterogeneous in terms of their capabilities. Because of this, traditional DHTs have been shown to exhibit poor performance in a real-world environment. Additionally, we believe that it is this approach that contributes to a limited exploitation of peer-to-peer technologies. Previous work on super-peers in DHTs was proposed to address these performance issues, however the strategy used is often based on locally clustering peers around individual super-peers. This method of superpeering, however, compromises fundamental features such as load-balancing, resilience and routing efficiency, which traditional DHTs originally promised to offer. We propose a Stealth DHT which addresses the deficiencies of previous super-peer approaches by using the DHT algorithm itself to select the most appropriate super-peer for each message sent by peers. Through simulations and measurements, we show the fitness for purpose of our proposal.

[PDF Download][1] | [LaTeX Source][2] | [Slides][3] | [Slides Source][4]

 [1]: https://github.com/bramp/publication/raw/master/stealth-dht/CoNEXT-2006/conext.pdf
 [2]: https://github.com/bramp/publication/tree/master/stealth-dht/CoNEXT-2006
 [3]: https://github.com/bramp/publication/blob/master/stealth-dht/CoNEXT-2006-slides/slides.ppt
 [4]: https://github.com/bramp/publication/tree/master/stealth-dht/CoNEXT-2006-slides
 