---
title: Grabbing a Certificate with OpenSSL and importing it into Java
author: bramp
layout: post
date: 2014-08-16
permalink: /2014/08/16/grabbing-a-certificate-with-openssl-and-importing-it-into-java/
categories:
  - Blog
tags:
  - certificate
  - java
  - openssl
---
Occasionally I have to grab a SSL cert from a server, and turn it into something that Java can use. Here are the quick instructions

<pre class="prettyprint"># Store the cert issued by a web server
openssl s_client -showcerts -connect www.google.com:443 &gt; www.google.com.pem

# Convert it from PEM format to DER format
openssl x509 -in www.google.com.pem -inform PEM -out www.google.com.der -outform DER

# Import it into your keystore
sudo /usr/java6/bin/keytool -import -alias www.google.com -file www.google.com.der -keystore /usr/java6/jre/lib/security/cacerts

# The keystore password is by default "changeit"
</pre>