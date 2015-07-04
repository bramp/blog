---
title: Redirect local traffic to a web cache with iptables
author: bramp
layout: post
date: 2010-01-26
permalink: /2010/01/26/redirect-local-traffic-to-a-web-cache-with-iptables/
categories:
  - Blog
tags:
  - iptables
  - Linux
  - webcache
---
Very occasionally I come across a Linux application that does not respect the http_proxy variable. This stops the application from working while I&#8217;m at university as they forbid traffic on port 80 unless it goes via their webcache. So today I came up with a hack of a solution that involves iptables:

```bash
# IP address and port number of the webcache
WEBCACHE=194.80.32.10:8080

# Flush any previous rules
iptables -t nat --flush

# Delete and recreate the chain
iptables -t nat -X HTTPFORCE
iptables -t nat -N HTTPFORCE

# Don't touch local traffic (localhost and internal network)
iptables -t nat -A HTTPFORCE -o lo -j RETURN
iptables -t nat -A HTTPFORCE --dst 127.0.0.1/8 -j RETURN
iptables -t nat -A HTTPFORCE --dst 10.0.0.0/8 -j RETURN
# Add any other local networks here.

# Now we have two options. Please uncomment out one of them
# 1) Redirect packets on port 80 to the webcache
#    This may not work unless the webcache is generous with its input
#iptables -t nat -A HTTPFORCE -p tcp --dport 80 -j DNAT --to $WEBCACHE

# 2) Redirect packets on port 80 to localhost port 1234
#    On port 1234 you need to run a local web proxy, which forwards 
#    requests to the real webcache
#iptables -t nat -A HTTPFORCE -p tcp --dport 80 -j REDIRECT --to-port 1234

# Capture all outgoing TCP syns
iptables -t nat -A OUTPUT -p tcp --syn -j HTTPFORCE
```

All outgoing TCP packets on port 80 which are not destined for a local network are captured and changed in one of two ways. The first option just manipulates the IP/TCP header, and the second redirects the traffic to a proxy running on localhost. The reason for the two options was that my university&#8217;s webcache seemed unable to deal with HTTP requests without the full URL in the GET line, even though the request contains a valid Host header. I think this is a misconfiguration of their squid proxy, so instead you can redirect to a local proxy which forwards the request on to the webcache.

This all seems a hassle but sometimes it is needed when a application does not respect the http_proxy environment. On a good note all libcurl applications should respect it by default.