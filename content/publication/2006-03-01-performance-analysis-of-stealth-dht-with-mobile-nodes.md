---
title: Performance analysis of Stealth DHT with mobile nodes.
author: bramp
layout: post
date: 2006-03-01
categories:
  - Publications
tags:
  - stealthdht
aliases:
  - /2006/03/01/performance-analysis-of-stealth-dht-with-mobile-nodes/
---
Andrew MacQuire, Andrew Brampton, Idris A. Rai, and Laurent Mathy.

In proceedings of the 3rd International Workshop on Mobile Peer-to-Peer Computing (MP2P&#8217;06)

> **Abstract**
> 
> The advances in wireless networking and the consequent emergence of new applications that wireless networks increasingly support inevitably leads to low capability mobile nodes connecting to peer-to-peer networks. However, the characteristics of mobile nodes and limitations of access point coverage often cause mobile nodes to lose connectivity, which can cause many mobile nodes to simultaneously rejoin the network. Continuous departures and joins due to the mobility of nodes leads to mobility churn, which can often degrade the performance of the underlying peer-to-peer network significantly. In this paper, we use simulations to demonstrate that the Stealth Distributed Hash Table (Stealth DHT) algorithm is ideally suited for networks with mobile nodes. By avoiding storing state in unreliable nodes, a Stealth DHT prevents mobile nodes from being used by other nodes to provide services. Consequently, Stealth DHTs eliminate the mobility churn effect and significantly reduce the amount of overhead as compared to a generic DHT. This paper demonstrates this using simulation results that compare the performance of Stealth DHTs to a generic DHT, Pastry.

[PDF Download][1] | [LaTeX Source][2] | [Slides][3] | [Slides Source][4]

 [1]: https://github.com/bramp/publication/raw/master/stealth-dht/MP2P06/Camera%20Ready/MP2P_MacQuire_A.pdf
 [2]: https://github.com/bramp/publication/tree/master/stealth-dht/MP2P06
 [3]: https://github.com/bramp/publication/raw/master/stealth-dht/MP2P06-slides/mp2pslides.pdf
 [4]: https://github.com/bramp/publication/tree/master/stealth-dht/MP2P06-slides
