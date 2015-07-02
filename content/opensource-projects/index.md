---
title: Open Source Projects
author: bramp
layout: page
date: 2013-02-16
weight: 1
---
I&#8217;ve always been a big fan of open source, and always try and contribute where I can. In addition over the years I have created multiple small projects that I give back to the community. Here are the ones I have on GitHub:

<table width="100%" class="opensource">
  <tr>
    <td width="33%" valign="top">
      <p>
        <b><a href="https://github.com/bramp/libcec-daemon">libcec-daemon</a> &#8211; c++ libcec uinput</b><br /> A Linux daemon for connecting libcec to uinput. That is, using your TV to control your PC over HDMI!
      </p>
      
      <p>
        <b><a href="https://github.com/bramp/threadnetperf">threadnetperf</a> &#8211; c epoll</b><br /> A highly customisable high performance multi-threaded network benchmarking tool. This tool was able to max out 20Gbit/s of bandwidth using commodity multi-core hardware. This supported <a href="http://bramp.net/blog/tag/multicore/">research</a> that existing <a href="http://www.netperf.org/">benchmarking tools</a> were unable to.</i>
      </p>
      
      <p>
        <b><a href="https://github.com/bramp/js-sequence-diagrams">js-sequence-diagrams</a> &#8211; javascript</b><br /> Draws simple SVG sequence diagrams from textual representation of the diagram.
      </p>
      
      <p>
        <b><a href="https://github.com/bramp/hessian.js">hessian.js</a> &#8211; node.js javascript</b><br /> Node.js support for the <a href="http://hessian.caucho.com/">Hessian</a> binary web service protocol written in pure javascript. This was implemented to interface with a legacy Java service. Hessian.js is available from <a href="https://npmjs.org/package/hessian">npm</a>.
      </p>
      
      <p>
        <b><a href="https://github.com/bramp/handy-tools">handy-tools</a> &#8211; python</b><br /> A collection of helpful cli tools written in python. Create histograms from raw data, create heatmaps of performance, or monitor applications with ease.
      </p>
    </td>
    
    <td width="33%" valign="top">
      <p>
        <b><a href="https://github.com/bramp/protoc-gen-php">protoc-gen-php</a> &#8211; c++ protobuf php</b><br /> A PHP Protocol Buffer Generator Plugin for protoc.
      </p>
      
      <p>
        <b><a href="https://github.com/bramp/nodewii">nodewii</a> &#8211; c++ node.js wii</b><br /> Bindings for node.js to speak to a Wiimote. This includes a socket.io demo, of the Wiimote controlling a webpage in realtime. Read the <a href="http://bramp.net/blog/2011/10/my-experiences-with-developing-multi-threaded-nodejs-extensions/" title="My experiences with developing multi-threaded nodejs addon">blog article</a>, or view my <a href="http://bramp.net/blog/2012/11/nodewii-talk-at-node-dc/" title="Nodewii talk at Node DC">NodeDC lightening talk</a>
      </p>
      
      <p>
        <b><a href="https://github.com/bramp/jambox">jambox</a> &#8211; c</b><br /> A Linux implementation of the protocol used to communicate with the <a href="https://jawbone.com/speakers/jambox/overview">Jambox by Jawbone</a>. This was reverse engineered from the Bluetooth protocol the official Windows application used.
      </p>
      
      <p>
        <b><a href="https://github.com/bramp/libmintchip">libmintchip</a> &#8211; c</b><br /> Unofficial C library for interfacing with <a href="http://mintchipchallenge.com/">MintChips</a> &#8211; Unfinished, and mostly an exercise in reverse engineering a protocol.
      </p>
      
      <p>
        <b><a href="https://github.com/bramp/Connected-component-labelling">Connected-component-labelling</a> &#8211; javascript</b><br /> Simple JavaScript library that does connected-component labelling (aka blob extraction). It uses the Algorithm described in the paper &#8220;A linear-time component labelling algorithm using contour tracing technique&#8221;. This is useful for Computer Vision problems, such as identifying objects in a photo. Originally written to support a JavaScript sudoku solver (that solves directly from a photo of a puzzle).
      </p>
    </td>
    
    <td width="33%" valign="top">
      <p>
        <b><a href="https://github.com/bramp/p2psim">p2psim</a> &#8211; java</b><br /> A peer-to-peer distributed hash table (DHT) simulator. This was created to support some of my <a href="http://bramp.net/blog/tag/stealthdht/">distributed systems research</a> simulating 1000 node networks.
      </p>
      
      <p>
        <b><a href="https://github.com/bramp/ByteTorrent">ByteTorrent</a> &#8211; c++</b><br /> A pure C++ implementation of the BitTorrent protocol. This was a project I wrote 11 years ago, and was used by atleast one complete BitTorrent client.
      </p>
      
      <p>
        <b><a href="https://github.com/bramp/php5-spotify">php5-spotify</a> &#8211; php c</b><br /> This is a simple PHP extension that wraps some of the functionality of the C library <a href="https://developer.spotify.com/technologies/libspotify/">libspotify</a>.
      </p>
      
      <p>
        <b><a href="https://github.com/bramp/ndsfs">ndsfs</a> &#8211; c fuse</b><br /> A FUSE application to mount Nintendo DS roms,
      </p>
      
      <p>
        <b><a href="https://github.com/bramp/us-census-tools">us-census-tools</a> &#8211; php</b><br /> A collection of scripts I&#8217;ve written to handle US Census data. For example, importing the American Community Survey (ACS) data into various databases, or converting the Census TIGER/Line® Shapefiles so they can easily be displayed on maps.
      </p>
      
      <p>
        <b><a href="https://github.com/bramp/jPsyScript">jPsyScript</a> &#8211; java objective-C</b><br /> A java implementation of <a href="http://www.psych.lancs.ac.uk/people/simon-slavin">PsyScript</a> a simple programming languge for psychologists to run experiments. The original version was written in Objective-C, and I reimplementation in Java so it was portable, and could be run from within a webpage.
      </p>
    </td>
  </tr>
</table>

As well as creating projects, I have made contributions to at least the following projects:

[Linux Kernel][1], [FreeBSD][2], [PHP][3], [Python][4], [Redis][5], [libzip][6], [Click][7], [Chromium][8], [archivemount][9], [NanoHTTPd][10] and more I just don&#8217;t remember.

 [1]: http://www.kernel.org/
 [2]: http://www.freebsd.org/
 [3]: http://php.net/
 [4]: http://www.python.org/
 [5]: http://redis.io/
 [6]: http://www.nih.at/libzip/
 [7]: http://www.read.cs.ucla.edu/click/click
 [8]: http://www.chromium.org/
 [9]: https://github.com/bramp/archivemount
 [10]: https://github.com/bramp/NanoHTTPd
 