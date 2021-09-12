---
title: "Compress and Backup"
author: bramp
date: 2021-09-12T13:45:51-07:00
layout: post
categories:
  - Blog
tags:
  - gcs
  - backup
---

In my [last article](https://blog.bramp.net/post/2021/09/12/recovering-a-raid-5-intel-storage-matrix-on-linux-without-the-hardware/) I discussed recovering a old RAID-5 disk array. Here I'm going to quickly list what I did to back up what I recovered.

```shell
# Create a zstd compressed tar file
$ tar -c -v -I"zstd -19 -T0" -f raid5-my-projects.tar.zstd My\ Projects

# Create a text based index for the tar
$ tar -t -f raid5-my-projects.tar.zstd > raid5-my-projects.index

# Backup to Google Cloud
$ gsutil cp raid5* gs://backup.bramp.net/
```

Maybe I should be using a proper backup solution, but this was quick and easy. I used [Zstandard](http://facebook.github.io/zstd/) to compress the tar file since it gives [impressive compression results](https://linuxreviews.org/Comparison_of_Compression_Algorithms), speed, and is modern. 

I uploaded the results to a [Archive bucket](https://cloud.google.com/storage/docs/storage-classes) on Google's Cloud Storage.