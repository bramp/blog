---
title: Fullscreen Hack for Flash 10.1
author: bramp
layout: post
date: 2010-05-24
permalink: /2010/05/24/full-screen-hack-for-flash/
dsq_thread_id:
  - 1614114707
categories:
  - Blog
tags:
  - asm
  - flash
  - hacks
---
After watching a few hours of [4oD][1] today I got annoyed that i couldn&#8217;t do something on one monitor while my other monitor plays full screen flash. The reason, flash will instantly lose full screen if another application gains focus (e.g the web browser on my other monitor.)

After a bit of googling I found these links [[1]][2] [[2]][3]. However, both of these sites only support flash 9 and flash 10.0, whereas I&#8217;m currently on 10.1.53.38. Additionally the second link mentioned no one has been able to hack this into 10.1, so I instantly recongised a challenge.

About 4 hours later I figure it out:

<pre>On win32 open
C:\Windows\System32\Macromed\Flash\NPSWF32.dll

On win64 open
C:\Windows\SysWOW64\Macromed\Flash\NPSWF32.dll

or if using Google Chrome (as Chrome now comes with the Flash plugin) open
C:\Users\Andrew\AppData\Local\Google\Chrome\Application\6.0.408.1\gcswf32.dll

or if using Google Chrome on Windows XP:
C:\Documents and Settings\Andrew\Local Settings\Application Data\Google\Chrome\Application\6.0.408.1
</pre>

On version 10.1.53.38  
Jump to offset **0&#215;180227** and change bytes **74 2A** to **90 90**, and voila.

On version 10.1.53.55  
Jump to offset **0&#215;180410** and change bytes **74 39** to **90 90**, and voila.

On version 10.1.53.64 (Chrome version &#8211; gcswf32.dll)  
Jump to offset **0&#215;180753** and change bytes **74 39** to **90 90**, and voila.

On version 10.1.53.64 (Normal version &#8211; NPSWF32.dll &#8211; thanks Medlir)  
Jump to offset **0x180A15** and change bytes **74 39** to **90 90**, and voila.

Thanks to all the commenter who worked this out before me <img src="http://bramp.net/blog/wp-includes/images/smilies/icon_smile.gif" alt=":)" class="wp-smiley" />  
On version 10.1.82.76 (Chrome version &#8211; gcswf32.dll)  
Jump to offset **0x180FAF** and change bytes **74 39** to **90 90**, and voila.

On version 10.1.82.76 (Normal version &#8211; NPSWF32.dll)  
Jump to offset **0x180AAF** and change bytes **74 39** to **90 90**, and voila.

**Note this method is unsupported, and will most likely break when Flash gets updated again. It is always a good idea to backup any file first, and make sure you are on the same version as me.**

For the curious this changes some code that looks like this:

<pre>if (msg == WM_KILLFOCUS)
  jump to kill_focus
if (msg == WM_PAINT)
  jump to paint
</pre>

to

<pre>if (msg == WM_KILLFOCUS)
  nop nop
if (msg == WM_PAINT)
  jump to paint
</pre>

and for some context the version 10.1.53.64 surrounding code looked like this:

<pre><b>74</b> 39 83 E8 07 <b>74</b> 11 83 E8 05 <b>75</b> 13 8B
</pre>

The 74s and 75 should be the same between versions, but all the other bytes might change.

 [1]: http://www.channel4.com/programmes/4od
 [2]: http://my.opera.com/d.i.z./blog/2009/04/22/watch-fullscreen-flash-while-working-on-another-screen
 [3]: http://jmaxxz.com/index.php?option=com_content&view=article&id=89:flashhacker&catid=16:downloads&Itemid=32