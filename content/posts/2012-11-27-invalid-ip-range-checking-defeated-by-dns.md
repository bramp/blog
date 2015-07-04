---
title: Invalid IP range checking defeated by DNS
author: bramp
layout: post
date: 2012-11-27
permalink: /2012/11/27/invalid-ip-range-checking-defeated-by-dns/
categories:
  - Blog
tags:
  - Camo
  - hack
  - http
  - nodejs
---
I&#8217;ve seen a particular kind of vulnerability in a few different applications but I&#8217;m not sure of an appropriate name for it. So I thought I&#8217;d write about it, and informally call it the &#8220;DNS defeated IP address check&#8221;. Basically, if you have an application that can be used as a proxy, or can be instructed to make web request, you don&#8217;t want it fetching files from internal services. <!--more-->

For example, there is a simple proxy called [Camo][1], which is used to fetch third party images when you need to display them on a SSL secure site. (Read more about Camo on the [GitHub blog][2]).

This kind of application can be incorrectly setup such that the application has access to internal servers and resources that wouldn&#8217;t normally be exposed to the Internet. This make the proxy application a good way a hacker could gain information about a private network. However Camo tries to address this issue by forbidding URLs that contain private IP addresses. It does a check like so:

```coffeescript
RESTRICTED_IPS = /^((10\.)|(127\.)|(169\.254)|(192\.168)|(172\.((1[6-9])|(2[0-9])|(3[0-1]))))/

if (url.host.match(RESTRICTED_IPS))
  return four_oh_four(resp, "Hitting excluded hostnames")
```

This code (written for [Node.js][3] in [CoffeeScript][4]) is taking a [url object][5] and checking the hostname doesn&#8217;t match a restricted address. This works great against URLs such as <http://127.0.0.1/>, or <http://10.0.0.1/>, however this check can easily be defeated. If you create a domain name, such as localhost.bramp.net, which resolves to 127.0.0.1, and ask the proxy to fetch <http://localhost.bramp.net/>, then it won&#8217;t be caught by that check. Now the proxy will continue to try and fetch a resource from 127.0.0.1.

The solution to this problem is to do that IP address check **after** the DNS name has been resolved. This can also be problematic if you use a standard library for making web requests, as they will do the DNS lookup for you, and don&#8217;t give you the fine grain control you need. For example, I&#8217;ve seen this be a problem for a Java application using the [Apache HTTP Client][6].

One might naively assume they could do a DNS check, and then hand the processing to a HTTP library to make the actual request. The issue here is that the DNS record the HTTP library uses might not be the same as the one you checked against with the DNS check. For example, many domains have multiple A records, and some DNS servers can be configured to round robin DNS records. If you can&#8217;t be sure the HTTP library will do another DNS requests, then you&#8217;d be vulnerable.

Luckily, in Camo&#8217;s case the fix was relatively easy (see my [pull request][7]).

```coffeescript
# We do DNS lookup ourselves
Dns.lookup url.host, (err, address, family) ->
  if address.match(RESTRICTED_IPS)
    return four_oh_four(resp, "Hitting excluded hostnames")

  # We connect to the IP address, not hostname
  src = Http.createClient url.port || 80, address

  # We add a host header, so the request will work
  headers = 
    "Host' : url.host

  # Boom, we make the request
  srcReq = src.request 'GET', query_path, headers
```

The above code was simplified a little from the real code, but basically we do the DNS lookup, check the returned address is good, and then make a HTTP request to that IP address with a `Host:` header to ensure the request will work.

Really though, the correct solution to this is to configure a suitably paranoid firewall to stop requests from the proxy machine to anything internal. However, as with all security, the more [layers of protection][8] you have the better, and you should never depend on just one.

 [1]: https://github.com/atmos/camo
 [2]: https://github.com/blog/743-sidejack-prevention-phase-3-ssl-proxied-assets
 [3]: http://nodejs.org/
 [4]: http://coffeescript.org/
 [5]: http://nodejs.org/api/url.html
 [6]: http://hc.apache.org/httpclient-3.x/
 [7]: https://github.com/atmos/camo/pull/19
 [8]: http://en.wikipedia.org/wiki/Swiss_cheese_model
 