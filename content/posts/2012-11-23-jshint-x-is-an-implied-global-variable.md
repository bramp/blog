---
title: JSHint ‘x’ is an implied global variable
author: bramp
layout: post
date: 2012-11-23
permalink: /2012/11/23/jshint-x-is-an-implied-global-variable/
categories:
  - Blog
tags:
  - Javascript
  - jshint
---
I&#8217;ve started using [JSHint][1] to check my javascript. One error I encountered was:

```text
Errors:
     85,5:'grammar' is not defined.
Warning:
     85,1: 'grammar' is an implied global variable.
```

<!--more-->
  
This is saying that I&#8217;m using some variable that I&#8217;ve not declared in my javascript file. In most cases that would be a mistake, but in my case I was expecting it to be in the global scope included from another javascript file.

To make JSHint stop complaining about this, you can simply place the following at the top of your javascript document:

```javascript
/*global grammar */
```

This will tell it that the variable is declared at a global scope. Check out one of [my projects][2] for example.

 [1]: http://www.jshint.com/
 [2]: https://github.com/bramp/js-sequence-diagrams/blob/master/diagram.js
 