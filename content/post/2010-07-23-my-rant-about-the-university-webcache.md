---
title: My rant about the university webcache
author: bramp
layout: post
date: 2010-07-23
categories:
  - Blog
tags:
  - lancaster
  - rant
  - webcache
aliases:
  - /blog/2010/07/23/my-rant-about-the-university-webcache/
---
I wrote this a while ago and posted it on the [Get rid of the university webcache!][1] Facebook group. I&#8217;ve just been reminded of it and thought I&#8217;ll post it here:

#### Get rid of the university webcache!

As many of you know, to access any website on the Internet from campus you must configure your browser to use the webcache. This is both inconvenient and frustrating. I am a researcher in the computer science department and I have had enough of this annoyance. It regularly gets in the way of my work and I spend countless hours trying to work around it.

Over the years I have asked members of ISS why they still have a webcache when many other University do not, and especially most computing departments do not. I have compiled a list of the common reasons, and what I think of them.

#### Reasons for the webcache

#### 1. The webcache reduces bandwidth usage by caching popular items

Typically webcaches were deployed to save money by reducing the number of files fetched from the Internet. Each file a user views would be stored in the cache. If another user came along to view the same file the cache would serve the file from its local file system instead of going onto the Internet. This would reduce the bandwidth usage, as well as make the user's web browsing experience faster.

The problem with this however, is that in the last 5 years the Internet has changed drastically. Most websites can no longer be cached. For example, pages on Facebook (the #2 most popular site according to Alexa.com), can not be cached. Each user see pages customised for them depending on which friends they have. Additionally, the pages on Facebook never stay the same for long which is terrible for caching. The third most popular website, YouTube (again according to Alexa.com), is not cached by our webcache either. YouTube serves large videos which the webcache will not understand how to cache.

Sure, there is still content which is cacheable. For example, static images on websites such as logos will not change offer and therefore be cached. However having a look at this URL: http://wwwcache.lancs.ac.uk/cachestatus shows how effective the caches actually are. There is a metric called Hit Rate, which is the percentage of requests (and bandwidth) that have been served locally instead of going to the Internet. Higher numbers are better, but looking at the hit rate now, it shows an average of 15% requests and 3% bandwidth. Overall 3% of bandwidth doesn't seem very useful. In the past when the webcache was first deployed it was easy to get >60%.

#### 2. The cache allows ISS to monitor what people are doing, as well as block websites

The webcache is most likely configured to log every site people visit, allowing ISS to look though your history. I'm sure this is very useful for dealing with the many copyright notices the university receives after student's download something inappropriate. In the past ISS have also used the webcache to blocked sites, for example, the infamous LUSerNet site. The only argument I can give to these benefits is that there are other ways to achieving logging and blocking which are just as simple, and I would be surprised if ISS weren't using some of these techniques already.

#### 3. The webcache keeps us safe from viruses.

I was told that every file downloaded will be scanned for viruses, this attempts to keep your computer clean. I'm unsure if the webcache is actually able to scan for viruses that quickly, but if it is I'm unsure of its usefulness. Most desktop PCs (if not all) have some kind of virus scanner installed. Additionally the big viruses that have hit the news in recent years, such as Slammer, or Conficker would not have been stopped by the webcache as they do not spread over HTTP.

As well as the advantages of the webcache there are many reasons against having webcaches.

#### Reasons against the webcache

#### 1. Reduced redundancy

From what I understand the university has multiple Internet connections, and the network is set up in such a way that if all the cables running between the two ends of campus were cut, both halves would still have Internet connection. This sounds like a great thing in ensuring the network is always working. However, I've been told that the webcaches are in a single central location, completely negating the benefits of the network's resilience. Because, if the link to the single location is cut the whole campus loses web access.

#### 2. Inconvenient to configure software

This is what annoys me the most, is that I have to ensure all the software I use can use a web proxy, and that all of it is configured to do so. As more and more applications start to use the Internet, it is not just web browsers that need to be configured. Things like, instant messengers, online music applications, software updaters, and many more all need the Internet. Every few months I have to spend my time hacking a solution to make it work behind the webcache.  
There is also the added inconvenience that if you take a Laptop between home and university, you have to flip the cache settings on and off. This has caused many headaches for people that have forgotten to do so.

#### Alternatives

Now most Universities have scrapped their webcaches because they just weren't useful anymore. However, if Lancaster wishes to keep theirs they could implement it in a different way. A transparent proxy is one such solution which would greatly improve the user's experience. Basically every time you try and visit a website the transparent proxy handles your request without the user even knowing. This means you don't have to change any settings in your web browser! Transparent proxies have been used by large ISPs to handle 1000s of clients, so I don't see why ISS couldn&#8217;t do this.

 [1]: http://www.facebook.com/group.php?gid=253120796980
 
