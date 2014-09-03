---
title: MRI scan of my brain
author: bramp
layout: post
date: 2012-05-16
permalink: /2012/05/15/mri-scan-of-my-brain/
categories:
  - Blog
tags:
  - brain
  - HTML5
  - mri
  - video
---
I had a [MRI][1] today, and afterwards I was given a CD of my scan. The data on the CD was stored in [DICOM][2] format, and after some searching I was able to find some open source software to view the data. I especially liked [Aeskulap][3] which allowed interactive viewing of the data in multiple dimensions.

I wanted to put my scans online, so I found another set of tools, [medcon][4], that allowed me to convert the DICOM images into png/gif format, and then I used [ffmpeg][5] to create the following videos:

<video width="256" height="256" controls="controls" style="float:left; padding: 10px"><source src="//bramp.net/blog/wp-content/uploads/001.mp4" type="video/mp4" /><source src="//bramp.net/blog/wp-content/uploads/001.webm" type="video/webm" />Your browser does not support the video tag.</video>

<video width="256" height="256" controls="controls" style="float:left; padding: 10px"><source src="//bramp.net/blog/wp-content/uploads/003.mp4" type="video/mp4" /><source src="//bramp.net/blog/wp-content/uploads/003.webm" type="video/webm" />Your browser does not support the video tag.</video>

<video width="288" height="288" controls="controls" style="float:left; padding: 10px"><source src="//bramp.net/blog/wp-content/uploads/004.mp4" type="video/mp4" /><source src="//bramp.net/blog/wp-content/uploads/004.webm" type="video/webm" />Your browser does not support the video tag.</video>

<video width="288" height="288" controls="controls" style="float:left; padding: 10px"><source src="//bramp.net/blog/wp-content/uploads/000.mp4" type="video/mp4" /><source src="//bramp.net/blog/wp-content/uploads/000.webm" type="video/webm" />Your browser does not support the video tag.</video>

<video width="256" height="256" controls="controls" style="float:left; padding: 10px"><source src="//bramp.net/blog/wp-content/uploads/008.mp4" type="video/mp4" /><source src="//bramp.net/blog/wp-content/uploads/008.webm" type="video/webm" />Your browser does not support the video tag.</video>

<div style="clear: both">
</div>

I don&#8217;t know the exact layout, but on the CD I seemed to have 12 different scans, each with a series of images. The name of the files were all 8 digits numbers, with the first three being the scan number (0 to 11), and the following five digits being (0 to whatever). For example:

<pre>DICOM/185723/00000000: DICOM medical imaging data
DICOM/185723/00000001: DICOM medical imaging data
DICOM/185723/00000002: DICOM medical imaging data
...
DICOM/185723/00100000: DICOM medical imaging data
DICOM/185723/00100001: DICOM medical imaging data
DICOM/185723/00100002: DICOM medical imaging data
...
</pre>

To create videos the first thing I did was to convert the images from DICOM to PNG

<pre>sudo apt-get install medcon
mkdir png
for i in DICOM/185723/*; do medcon -f $i -c png -o png/`basename $i`.png ; done;
</pre>

Now to batch the images I started by creating animated gifs.

<pre>sudo apt-get install imagemagick

# Create animated gifs
for i in `seq -w 000 011`; do convert -delay 20 -loop 0 png/$i*.png $i.gif; done;
</pre>

However, those gifs were huge, up to 20mb. So next I created a set of videos (that were a order of magnitude smaller than the gifs):

<pre>sudo apt-get install ffmpeg

# Create MP4
for i in `seq -w 000 011`; do avconv -r 5 -i png/$i%05d.png -r 24 $i.mp4; done;

# Create webm
for i in `seq -w 000 011`; do avconv -r 5 -i png/$i%05d.png -r 24 $i.webm; done;

# Create ogg video
for i in `seq -w 000 011`; do avconv -r 5 -i png/$i%05d.png -r 24 $i.ogg; done;
</pre>

easy!

 [1]: http://en.wikipedia.org/wiki/Magnetic_resonance_imaging
 [2]: http://en.wikipedia.org/wiki/DICOM
 [3]: http://aeskulap.nongnu.org/
 [4]: http://xmedcon.sourceforge.net/
 [5]: http://ffmpeg.org/