---
title: MD5 Digest Authorisation in SIP with PHP
author: bramp
layout: post
date: 2011-09-23
permalink: /2011/09/23/md5-digest-authorisation-in-sip-with-php/
categories:
  - Blog
tags:
  - md5
  - PHP
  - sip
---
Today I needed to work out the MD5 Digest hash for SIP authorisation. A quick search on Google revealed [instructions][1] on how to generate the hash, and then I made this simple PHP script.

<pre class="prettyprint">&lt;?php
$username = '1234';
$realm    = 'asterisk';
$password = 'PASSWORD';
$uri      = 'sip:1.2.3.4';
$nonce    = 'abcdef01';

$str1 = md5("$username:$realm:$password");
$str2 = md5("REGISTER:$uri");

echo md5("$str1:$nonce:$str2");
?&gt;
</pre>

All of those variables can be pulled out of a packet capture of a [SIP REGISTER][2], and the results can be useful for validating the password a device is sending, is what it is actually sending.

 [1]: http://alexkr.com/memos/66/digest-authorization-in-sip-with-md5/
 [2]: http://tools.ietf.org/html/rfc3261#section-10.2