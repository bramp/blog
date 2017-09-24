---
title: MRI scan of my brain
slug: mri-scan-of-my-brain
author: bramp
layout: post
date: 2012-05-15
categories:
  - Blog
tags:
  - brain
  - HTML5
  - mri
  - video
aliases:
  - /blog/2012/05/15/mri-scan-of-my-brain/
---

I had a [MRI][1] today, and afterwards I was given a CD of my scan. The data on the CD was stored in [DICOM][2] format, and after some searching I was able to find some open source software to view the data. I especially liked [Aeskulap][3] which allowed interactive viewing of the data in multiple dimensions.

I wanted to put my scans online, so I found another set of tools, [medcon][4], that allowed me to convert the DICOM images into png/gif format, and then I used [ffmpeg][5] to create the following videos:

<div class="row">
  <div class="col-md-6 text-center">
  	<video width="288" height="288" controls="controls"><source src="004.mp4" type="video/mp4" /><source src="004.webm" type="video/webm" />Your browser does not support the video tag.</video>
  </div>
  <div class="col-md-6 text-center">
  	<video width="288" height="288" controls="controls"><source src="000.mp4" type="video/mp4" /><source src="000.webm" type="video/webm" />Your browser does not support the video tag.</video>
  </div>
</div>
<div class="row">
  <div class="col-md-6 text-center">
  	<video width="256" height="256" controls="controls"><source src="001.mp4" type="video/mp4" /><source src="001.webm" type="video/webm" />Your browser does not support the video tag.</video>
  </div>
  <div class="col-md-6 text-center">
 	 <video width="256" height="256" controls="controls"><source src="003.mp4" type="video/mp4" /><source src="003.webm" type="video/webm" />Your browser does not support the video tag.</video>
  </div>
</div>

<div class="row">
  <div class="col-md-12 text-center">
  	<video width="256" height="256" controls="controls"><source src="008.mp4" type="video/mp4" /><source src="008.webm" type="video/webm" />Your browser does not support the video tag.</video>
  </div>
</div>

I don&#8217;t know the exact layout, but on the CD I seemed to have 12 different scans, each with a series of images. The name of the files were all 8 digits numbers, with the first three being the scan number (0 to 11), and the following five digits being (0 to whatever). For example:

```text
DICOM/185723/00000000: DICOM medical imaging data
DICOM/185723/00000001: DICOM medical imaging data
DICOM/185723/00000002: DICOM medical imaging data
...
DICOM/185723/00100000: DICOM medical imaging data
DICOM/185723/00100001: DICOM medical imaging data
DICOM/185723/00100002: DICOM medical imaging data
...
```

To create videos the first thing I did was to convert the images from DICOM to PNG

```bash
sudo apt-get install medcon
mkdir png
for i in DICOM/185723/*; do medcon -f $i -c png -o png/`basename $i`.png ; done;
```

Now to batch the images I started by creating animated gifs.

```bash
sudo apt-get install imagemagick

# Create animated gifs
for i in `seq -w 000 011`; do convert -delay 20 -loop 0 png/$i*.png $i.gif; done;
```

However, those gifs were huge, up to 20mb. So next I created a set of videos (that were a order of magnitude smaller than the gifs):

```bash
sudo apt-get install ffmpeg

# Create MP4
for i in `seq -w 000 011`; do avconv -r 5 -i png/$i%05d.png -r 24 $i.mp4; done;

# Create webm
for i in `seq -w 000 011`; do avconv -r 5 -i png/$i%05d.png -r 24 $i.webm; done;

# Create ogg video
for i in `seq -w 000 011`; do avconv -r 5 -i png/$i%05d.png -r 24 $i.ogg; done;
```

easy!

 [1]: http://en.wikipedia.org/wiki/Magnetic_resonance_imaging
 [2]: http://en.wikipedia.org/wiki/DICOM
 [3]: http://aeskulap.nongnu.org/
 [4]: http://xmedcon.sourceforge.net/
 [5]: http://ffmpeg.org/
 
