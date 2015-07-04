---
title: RFC 1123 dates in PHP
author: bramp
layout: post
date: 2012-09-03
permalink: /2012/09/03/rfc-1123-dates-in-php/
categories:
  - Blog
tags:
  - date
  - PHP
  - rfc
---
While playing with [REDbot][1] I realised my last-modified headers (being sent by PHP) were not RFC 1123 complaint. A complaint date looks like `Sun, 06 Nov 1994 08:49:37 GMT`. There are two ways to generate such a date in PHP; <!--more-->

1. if you have pecl_http >= 0.1.0, then

    ```php
    http_date($timestamp)
    ```
2. or if you don&#8217;t want to use pecl

    ```php
    gmdate('D, d M Y H:i:s', $timestamp).' GMT'
    ```

3. or if you have PHP >5.2 you can use the DateTime constant  

    ```php
    gmdate(DATE_RFC2822, $timestamp)
    ``` 

an example of it&#8217;s use:
```php
header('Last-Modified: ' . gmdate('D, d M Y H:i:s', $lastModified).' GMT');
```

 [1]: http://redbot.org/
