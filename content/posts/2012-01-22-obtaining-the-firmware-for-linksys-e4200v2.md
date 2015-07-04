---
title: Obtaining the firmware for Linksys E4200v2
author: bramp
layout: post
date: 2012-01-22
permalink: /2012/01/22/obtaining-the-firmware-for-linksys-e4200v2/
categories:
  - Blog
tags:
  - firmware
  - linksys
  - Linux
  - router
---
I recently got a Linksys E4200v2 wireless router. It&#8217;s pretty cool, supports IPv6, 2.4Ghz and 5Ghz wifi networks, VPN, etc. The one downside is that the firmware for the router is not available from [Linksys&#8217;s website][1], and the [GPL code][2] has not been made available, yet&#8230; However, the router has been able to pull updates itself from the Internet.

So I wanted to acquire the firmware to see if I could do something fun with the router. I set about to figure out how the router does this. My plan was to set my laptop up between Internet interface on the router, and the cable modem. Since my laptop doesn&#8217;t have two network cards, I plugged into a switch and used [Ethercap][3] to ARP poison to redirect traffic via the laptop.

Then using [Wireshark][4] I could see the traffic coming out of the router. All I needed to do now was to hit the &#8220;check for updates button&#8221;.

Firstly I saw two DNS requests, one for the AAAA (IPv6) record for update.linksys.com, then a A request for update.linksys.com. Clearly the updates are coming from there. Secondly I saw a HTTPS connection form to that domain. That makes this a little more complex, as I am unable to see the encrypted traffic, and thus see what is being transferred.

So, I grabbed a [simple DNS server][5], and set up a simple SSL server following [these instructions][6].

Now with DNS spoofing, and a fake SSL server, I could intercept encrypted traffic from the router, as long as it does not validate the SSL certificate. Luckily it didn&#8217;t check the validity, and thus I was able to capture the request: (BTW Not checking the cert completely defeats the point of using SSL&#8230; bad Linksys!).

```http
POST /cds/update HTTP/1.1
Host: update.linksys.com
Accept: */*
Content-Type: text/xml
Content-Length: 573

&lt;SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"&gt;
  &lt;SOAP-ENV:Header/&gt;
  &lt;SOAP-ENV:Body&gt;
    &lt;ns:GetFirmwareFromDeviceRequest xmlns:ns="http://cisco.com/schemas"&gt;
      &lt;ns:LanguageCode&gt;en&lt;/ns:LanguageCode&gt;
      &lt;ns:CountryCode&gt;us&lt;/ns:CountryCode&gt;
      &lt;ns:MacAddress&gt;12:34:56:78:90:ab&lt;/ns:MacAddress&gt;
      &lt;ns:ModelNo&gt;E4200&lt;/ns:ModelNo&gt;
      &lt;ns:HardwareVersion&gt;2&lt;/ns:HardwareVersion&gt;
      &lt;ns:CurrentFirmwareVersion&gt;2.0.36.126507&lt;/ns:CurrentFirmwareVersion&gt;
    &lt;/ns:GetFirmwareFromDeviceRequest&gt;
  &lt;/SOAP-ENV:Body&gt;
&lt;/SOAP-ENV:Envelope&gt;
```

and the response:

```http
HTTP/1.1 200 OK
Content-Language: en-US
Content-Type: text/xml
SOAPAction: ""

&lt;soapenv:Envelope
 xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
 xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
  &lt;soapenv:Header/&gt;
  &lt;soapenv:Body&gt;
    &lt;ns:GetFirmwareFromDeviceResponse xmlns:ns="http://cisco.com/schemas"&gt;
      &lt;ns:FirmwareList xmlns:ns="http://cisco.com/schemas"&gt;
        &lt;ns:Firmware xmlns:ns="http://cisco.com/schemas"&gt;
          &lt;ns:Version xmlns:ns="http://cisco.com/schemas"&gt;2.0.36.126507&lt;/ns:Version&gt;
          &lt;ns:Revision xmlns:ns="http://cisco.com/schemas"&gt;D&lt;/ns:Revision&gt;
          &lt;ns:ReleaseDate xmlns:ns="http://cisco.com/schemas"&gt;2012-01-06T16:48:08Z&lt;/ns:ReleaseDate&gt;
          &lt;ns:DownloadURI xmlns:ns="http://cisco.com/schemas"&gt;http://download.linksys.com/updates/to0037258865.pdx/FW_E4200_2.0.36.126507.SSA&lt;/ns:DownloadURI&gt;
          &lt;ns:DateFormat xmlns:ns="http://cisco.com/schemas"&gt;yyyy-MM-dd';T';HH:mm:ss';Z';&lt;/ns:DateFormat&gt;
          &lt;ns:Checksum xmlns:ns="http://cisco.com/schemas"&gt;1958710861&lt;/ns:Checksum&gt;
        &lt;/ns:Firmware&gt;
      &lt;/ns:FirmwareList&gt;
    &lt;/ns:GetFirmwareFromDeviceResponse&gt;
  &lt;/soapenv:Body&gt;
&lt;/soapenv:Envelope&gt;
```

(I slightly modified portions of the request and response to hide the identify of my router.).

I might write a script to make fake requests, but until then you can easily create a request with curl:

```bash
curl -d @request.raw https://update.linksys.com/cds/update
```

Then you just extract the DownloadURI and 

```bash
curl http://download.linksys.com/updates/to0037258865.pdx/FW_E4200_2.0.36.126507.SSA
```

Voila I now have the firmware. Now I need to figure out what to do with it.

**Update**: As requested I fetched the more recent version of the file:  
2.0.37.131047 &#8211; http://download.linksys.com/updates/to0040829450.pdx/FW\_E4200\_2.0.37.131047.SSA

 [1]: http://homesupport.cisco.com/en-us/wireless/linksys/E4200
 [2]: http://homesupport.cisco.com/en-us/gplcodecenter
 [3]: http://ettercap.sourceforge.net/
 [4]: http://www.wireshark.org/
 [5]: http://code.activestate.com/recipes/491264-mini-fake-dns-server/
 [6]: http://wirewatcher.wordpress.com/2010/07/20/decrypting-ssl-traffic-with-wireshark-and-ways-to-prevent-it/
