---
title: Power Consumption
author: bramp
layout: post
date: 2009-10-26
categories:
  - Blog
tags:
  - experiment
  - measurements
  - power
  - watt
aliases:
  - /2009/10/26/power-consumption/
---
I have mentioned many times that I would like to know how much current something is drawing, so today Nic brought me a mains power meter. It is a very simple meter which plugs between the mains and the device and can measure volts, amps, watts, frequency, and a few other metrics. I decided to run around my house measuring everything I could. 

### Methodology 

A couple notes about my methodology, firstly, I was very lazy in my measurement taking. I repeated some of the measurements, but not all. However, when I did repeat the measurements they always seem to have the same value, so this discouraged me from repeating.

To test a device I would plug the meter between it and the mains electricity and give it a some time to settle. Once settled I would take the reading. Sometimes the reading would flicker between two values, in these cases I took the higher of the two. Finally, I noticed that after I turned the devices off the meter would always read 8W. Either the meter was unable to read less than 8W, or zero was not calibrated correctly on the meter.

All these measurements were taken in my house in the UK, which according to my meter has mains electricity at 248V and at a AC frequency of 59.9Hz

### Results

| Device (status)              | Power Usage (watts) |
|------------------------------|:-------------------:|
| xTune Speakers (standby)     |         24W         |
| xTune Speakers (on no music) |         25W         |
| xTune Speakers (on vol30)    |         25W         |
| xTune Speakers (on vol60)    |         50W         |
|------------------------------|---------------------|
| TFT Monitor 15″ (standby)    |         11W         |
| TFT Monitor 15″ (on)         |         27W         |
|------------------------------|---------------------|
| TFT Monitor 17″ (standby)    |          9W         |
| TFT Monitor 17″ (on)         |         38W         |
|------------------------------|---------------------|
| Nic’s laptop (web browsing)  |         35W         |
| Nic’s laptop (playing game)  |         59W         |
|------------------------------|---------------------|
| xbox 360 (standby)           |         10W         |
| xbox 360 (dashboard)         |         150W        |
| xbox 360 (game)              |         158W        |
|------------------------------|---------------------|
| Sky+ Box (standby)           |         20W         |
| Sky+ Box (on)                |         29W         |
|------------------------------|---------------------|
| Wii (standby – red light)    |          9W         |
| Wii (on)                     |         24W         |
|------------------------------|---------------------|
| TV (standby)                 |          9W         |
| TV (on)                      |         95W         |
|------------------------------|---------------------|
| Kettle                       |        2300W        |
|------------------------------|---------------------|
| My PC (off)                  |         10W         |
| My PC (booting during POST)  |         230W        |
| My PC (booting)              |         130W        |
| My PC (idle – Windows)       |         128W        |
| My PC (game)                 |         154W        |
| My PC (1 core prime #)       |         142W        |
| My PC (2 core prime #)       |         152W        |
| My PC (3 core prime #)       |         160W        |
| My PC (4 core prime #)       |         163W        |
| My PC (sleep)                |         13W         |
| My PC (idle – Linux)         |         150W        |
|------------------------------|---------------------|

Some observations I made about these results:

  * My speakers use the same amount of power playing music as when they aren&#8217;t. I assume this is because the amps in them are always trying to amplify the signal.
  * My Sky+ box is pretty poor at conserving power. I found this interesting because Sky made a big deal about the Sky box automatically turning off at night. It even advertises this fact in big letters on the side of the packaging.
  * My PC which has a 800W power supply, with a quad core Intel, 4GB of RAM, and 6 harddrives, obviously doesn&#8217;t need 800W of power. The peak value, which I found during POST, was only 230W, with it idling (in Windows) at 128W.
  * Linux uses more power than Windows! This is using the latest Debian testing (2.6.30-8), and Windows Server 2008. Clearly, Linux has less energy efficient drivers, or is not powering something down that Windows is.