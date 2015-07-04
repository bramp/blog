---
title: Google DNS Benchmarked
author: bramp
layout: post
date: 2009-12-04
permalink: /2009/12/04/google-dns-benchmarked/
categories:
  - Blog
tags:
  - dns
  - experiment
  - Google
  - opendns
  - PHP
---
Today [Google announced][1] a public DNS service they are hosting. They claim that their DNS infrastructure is [faster and more secure][2], because their servers do some clever things. I wanted to test their performance claims, so I wrote a [little script][3] to measure a lookup times for different domains across a number of DNS servers.

### Methodology

Firstly I found a [list of the 1 million most popular sites][4]. I then picked a number of DNS servers to test against. I chose [Google][5]&#8216;s, [OpenDNS][6]&#8216;s, my ISP ([Sky/Easynet][7]) and my old ISP&#8217;s ([Plus.net][8]).

I decided I would query an [A record][9] for each of the domains in the list, one at a time, starting with the most popular. I would query each server three times for the same domain name. The ordering was like this:

```php
foreach (domain)
   for (i =0; i<3;i++)
      foreach (server)
         query(server, domain)
```

I recorded the time it took for each query to be answered, and I also recorded the replies. I was curious to see if some servers replied with different answers, or if some returned more information, i.e. additional records.

I [wrote a script][3] in PHP 5.3, and ran it from the command line on my Windows Server 2008 machine. The script used PEAR's Net_DNS to craft and send the DNS questions. I was not using my operating system's resolver, and I was not using any form of client side caching. I ran the experiments from my home ADSL connection and as far as I know my ISP was not interfering with my DNS requests in any way. I live in the North West of the UK.

### Results

After letting this run for a few hours, and querying roughly the top 10,000 domains, I have some preliminary results.

| DNS Server                 | Min (ms) | Max (ms) | Median | Mean (ms) | Standard Dev (ms) |
|----------------------------|:--------:|:--------:|:------:|:---------:|:-----------------:|
| Google A (8.8.8.8)         |   38.50  |   4932   |  42.45 |   122.8   |       181.6       |
| Google B (8.8.4.4)         |   38.65  |   4927   |  41.84 |   94.52   |       154.8       |
| OpenDNS A (208.67.222.222) |   29.77  |   4035   |  31.87 |   74.37   |       115.4       |
| OpenDNS B (208.67.220.220) |   29.76  |   1171   |  31.82 |   35.28   |        32.4       |
| Easynet A (90.207.238.97)  |   33.90  |   2578   |  61.29 |   105.2   |       103.7       |
| Easynet B (90.207.238.99)  |   33.65  |   4253   |  44.96 |   96.11   |       104.8       |
| Plusnet A (212.159.11.150) |   43.78  |   4423   |  52.56 |   100.8   |       156.5       |
| Plusnet B (212.159.13.150) |   38.87  |   4991   |  42.76 |   90.78   |       169.1       |

From this table of results, we can see that Google's median response time is 41-42ms, however, OpenDNS performs much better with a result of ~31ms. Both my current ISP and my old ISP don't perform as well and each achieved a result between 42ms and 61ms. To get a better feel for the data I plotted an empirical CDF of the lookup times for each server.

<div class="figure">
  <a href="/projects/dns/ecdf_overview.pdf"><img src="/projects/dns/ecdf_overview.png" width="700" height="700" /></a><br /><a href="/projects/dns/ecdf_overview.pdf">Click for a larger PDF version</a>
</div>

The first impression I can make from this CDF is that OpenDNS serves far more of the queries faster than anyone else. Secondly the secondary DNS servers all seem to be faster than their primaries. I suspect this is because most hosts query the primary, and rarely query the secondary. I even read that [BIND][10] (a popular DNS server) has/had [a bug in it which favoured the primary DNS][11]. 

The minimum lookup time for each pair of DNS servers seems to be the same, most likely caused by the network latency between me and the servers. Even so, if we normalise all the data by taking the servers' minimum value away from each sample, we still find that OpenDNS performs better than Google, and Google performs slightly better than Plus.net and quite a bit better than my current ISP, Easynet.

Rather worryingly is that the latency to OpenDNS is smaller than the latency to my own ISP's DNS servers. This makes me wonder where the hell my ISP hosts their DNS servers. Also, the ~38ms minimum time with Google indicates that at least some of their DNS servers are hosted in Europe, and possibly the UK.

SInce I ran each lookup three times, I wanted to compare the lookup times for each request. This time I plotted the empirical CDF of each iteration of request. 

<div class="figure">
  <a href="/projects/dns/ecdf_requests.pdf"><img src="/projects/dns/ecdf_requests.png" width="700" height="700" /></a><br /><a href="/projects/dns/ecdf_requests.pdf">Click for a larger PDF version</a>
</div>

This CDF seems to show that the 2nd and 3rd requests always get served quicker than the first. In most cases the 2nd and 3rd request have equal ranking, but the first is always slow. This could easily be attributed to the fact that the caching DNS server does not have the record in its cache, and thus must be fetched. The second time I request the domain name (only moments later), the server already has the query, and most likely has it stored in RAM or L1/L2 CPU cache. 

OpenDNS\_B seems to respond equally quick for the first, second and third request. This could be because I would always query OpenDNS\_A first, then move on to B. If A and B were actually the same machine, it would be like sending 6 requests to the machine instead of 3. Therefore, B's 1st request is actually its second. Even if A and B were different machines, there could be some clever replication, or shared caching going on to cause this behaviour.

Finally, I'm surprised that the 2nd and 3rd requests are slower, especially since I'm requesting the most popular domain names. Surely others would have already requested the domain name, and thus the DNS server has no need to fetch it. Looking through the list of domain names I see that none of them have the www prefix. I personally never type the www and just hope the site works, but perhaps many users do. Maybe I should re-run the experiment with the www prefix.

### Conclusion

For now I would stick to using OpenDNS, as this is clearly the winner. However, the Google DNS service is very new, so perhaps the servers haven't had enough time to fill their caches, and their admins haven't had enough time to tweak them. I will perhaps rerun this experiment in a few weeks and see what happens.

### TODO

I still have some analysis to do, for example, looking at packet loss, the type of records returned, and anything else I can think of.

 [1]: http://googleblog.blogspot.com/2009/12/introducing-google-public-dns.html
 [2]: http://code.google.com/speed/public-dns/docs/performance.html
 [3]: /projects/dns/dns.php.txt
 [4]: http://www.quantcast.com/top-sites-1
 [5]: http://code.google.com/speed/public-dns/
 [6]: http://www.opendns.com/
 [7]: http://broadband.sky.com/
 [8]: http://www.plus.net/
 [9]: http://en.wikipedia.org/wiki/List_of_DNS_record_types
 [10]: https://www.isc.org/software/bind
 [11]: http://homepages.tesco.net/J.deBoynePollard/FGA/dns-database-replication.html
