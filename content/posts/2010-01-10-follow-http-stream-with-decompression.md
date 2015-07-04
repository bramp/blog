---
title: Follow HTTP Stream (with decompression)
author: bramp
layout: post
date: 2010-01-10
permalink: /2010/01/10/follow-http-stream-with-decompression/
dsq_thread_id:
  - 1614115435
categories:
  - Blog
tags:
  - dpkt
  - gzip
  - http
  - pcap
  - python
---
I was using [Wireshark][1] to capture an exchange of HTTP packets, however, some of the HTTP responses were using &#8220;content-encoding: gzip&#8221;, which meant I couldn&#8217;t view them decompressed in the &#8220;Follow TCP Stream&#8221;. Wireshark does decompress them in Packet Details view, but it is hard to follow the full stream like this.

The solution was to write some [Python][2] which made use of the [dpkt library][3]. My code naively reassembles the TCP flow and then assumes traffic on port 80 is HTTP. Therefore there is much room for improvement, but here is the code anyway.

```python
#!/usr/bin/env python
# Turns a pcap file with http gzip compressed data into plain text, making it
# easier to follow.

import dpkt

def tcp_flags(flags):
	ret = ''
	if flags & dpkt.tcp.TH_FIN:
		ret = ret + 'F'
	if flags & dpkt.tcp.TH_SYN:
		ret = ret + 'S'
	if flags & dpkt.tcp.TH_RST:
		ret = ret + 'R'
	if flags & dpkt.tcp.TH_PUSH:
		ret = ret + 'P'
	if flags & dpkt.tcp.TH_ACK:
		ret = ret + 'A'
	if flags & dpkt.tcp.TH_URG:
		ret = ret + 'U'
	if flags & dpkt.tcp.TH_ECE:
		ret = ret + 'E'
	if flags & dpkt.tcp.TH_CWR:
		ret = ret + 'C'

	return ret

def parse_http_stream(stream):
	while len(stream) &gt; 0:
		if stream[:4] == 'HTTP':
			http = dpkt.http.Response(stream)
			print http.status
		else:
			http = dpkt.http.Request(stream)
			print http.method, http.uri
		stream = stream[len(http):]

def parse_pcap_file(filename):
	# Open the pcap file
	f = open('market.pcap', 'rb')
	pcap = dpkt.pcap.Reader(f)
	
	# I need to reassmble the TCP flows before decoding the HTTP
	conn = dict() # Connections with current buffer
	for ts, buf in pcap:
		eth = dpkt.ethernet.Ethernet(buf)
		if eth.type != dpkt.ethernet.ETH_TYPE_IP:
			continue
	
		ip = eth.data
		if ip.p != dpkt.ip.IP_PROTO_TCP:
			continue
	
		tcp = ip.data
	
		tupl = (ip.src, ip.dst, tcp.sport, tcp.dport)
		#print tupl, tcp_flags(tcp.flags)
	
		# Ensure these are in order! TODO change to a defaultdict
		if tupl in conn:
			conn[ tupl ] = conn[ tupl ] + tcp.data
		else:
			conn[ tupl ] = tcp.data
	
		# TODO Check if it is a FIN, if so end the connection
	
		# Try and parse what we have
		try:
			stream = conn[ tupl ]
			if stream[:4] == 'HTTP':
				http = dpkt.http.Response(stream)
				#print http.status
			else:
				http = dpkt.http.Request(stream)
				#print http.method, http.uri
	
			print http
			print

			# If we reached this part an exception hasn't been thrown
			stream = stream[len(http):]
			if len(stream) == 0:
				del conn[ tupl ]
			else:
				conn[ tupl ] = stream
		except dpkt.UnpackError:
			pass

	f.close()

if __name__ == '__main__':
	import sys
	if len(sys.argv) &lt;= 1:
		print "%s &lt;pcap filename&gt;" % sys.argv[0]
		sys.exit(2)

	parse_pcap_file(sys.argv[1])
```

**Please note**, I had to make a couple of changes to the dpkt library, which I have submitted [back for review][4]. Those changes can be found in the following patches [1][5] [2][6] [3][7]. I will update this code if/when the patches get accepted.

 [1]: http://www.wireshark.org/
 [2]: http://www.python.org/
 [3]: http://code.google.com/p/dpkt/
 [4]: http://groups.google.com/group/dpkt/browse_thread/thread/5315199f9749b91a
 [5]: /patches/dpkt-pcap-snaplen.patch
 [6]: /patches/dpkt-http-len.patch
 [7]: /patches/dpkt-http-gz.patch
 