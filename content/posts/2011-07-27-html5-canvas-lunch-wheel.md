---
title: 'HTML5 Canvas: Lunch Wheel'
author: bramp
layout: post
date: 2011-07-27
permalink: /2011/07/27/html5-canvas-lunch-wheel/
categories:
  - Blog
tags:
  - Canvas
  - HTML5
  - Javascript
  - Lunch
---
In the on going battle to make my lunch time more optimised I decided to learn some Javascript, and how to use the HTML5 [Canvas][1] element. Turns out it&#8217;s not that hard, and I have now created 

[  
![][2]  
The Lunch Wheel][3]. It helps me find lunch close to my office in the [Courthouse area of Arlington, VA][4].

While making this I found that information on the Canvas element seemed to be lacking. For example, not many sites talked about ways to optimise or profile the javascript. Also I was disappointed to see that not all browsers supported the Canvas completely. Here is a quick list of the problems:

1) Firefox 3.5 (linux) doubled the size of the fonts when I was setting the font in &#8220;pt&#8221;. When I switched to &#8220;em&#8221; things seemed to work consistently across browsers. 30fps

2) Android 2.2 (Droid 2) works well but slowly. It also didn&#8217;t support the [Audio][5] tag. 6fps

3) Android 3.0 (Xoom Tablet) seemed to have some issues rendering half of the wheel. It looked like a bug with the hardware acceleration. I made some minor tweaks to the rendering and things started to work. 15fps

4) iPhone 3 didn&#8217;t render any of the text, but played the sound and spun the wheel. 3fps

5) iPhone 4 rendered fine but as slowly as the Android 2.2 device. 5fps

6) Chrome (linux) worked great, and was the platform I was developing on. 30fps (max)

I was also using the [clip()][6] method to ensure the text didn&#8217;t go outside of the wheel, but this heavily impacted performance. So instead I just chopped the text manually and performance doubled.

I realise HTML5 is new, but I&#8217;m really hoping all browsers will start to support it consistently and across the board. I&#8217;d hate to start writing large blocks of code to cope with all the browser quirks.

Also, thanks to [jQuery][7], [TinySort][8] and [ExplorerCanvas][9] (which I still haven&#8217;t made work).

**Update:** Soon to come, the ability to find your own lunch places, as well as integration with [foursquare][10] so you can see how popular the venues are with your friends.

 [1]: http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html
 [2]: http://bramp.net/javascript/lunchwheel.png "Click to win"
 [3]: http://bramp.net/javascript/lunchwheel.html
 [4]: http://maps.google.com/maps?q=Courthouse,+Arlington,+VA&hl=en&sll=37.0625,-95.677068&sspn=59.206892,135.263672&z=15
 [5]: https://developer.mozilla.org/En/HTML/Element/audio
 [6]: http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html#dom-context-2d-clip
 [7]: http://jquery.com/
 [8]: http://tinysort.sjeiti.com/
 [9]: http://excanvas.sourceforge.net/
 [10]: https://foursquare.com/