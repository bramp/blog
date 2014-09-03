---
title: Draw UML Sequence Diagrams with Javascript
author: bramp
layout: post
date: 2013-03-24
permalink: /2013/03/23/draw-uml-sequence-with-javascript/
categories:
  - Blog
tags:
  - diagrams
  - Javascript
  - svg
  - uml
---
I&#8217;m happy to announce one of my projects, [js-sequence-diagrams][1]. This uses Javascript to draw UML sequence diagrams in SVG format. Here is an example:

[<img src="http://bramp.net/blog/wp-content/uploads/sample-with-editor.png" alt="js-sequence-diagram example" width="865" height="333" class="aligncenter size-full wp-image-613" />][1]

You can alter the diagram in real time, and I even have a simple jQuery plugin to make this easy to use on your own sites.

<pre>&lt;script src="sequence-diagram-min.js"&gt;&lt;/script&gt;
&lt;div class="diagram"&gt;A-&gt;B: Message&lt;/div&gt;
&lt;script&gt;
$(".diagram").sequenceDiagram({theme: &#39;hand&#39;});
&lt;/script&gt;</pre>

 [1]: http://bramp.github.com/js-sequence-diagrams/