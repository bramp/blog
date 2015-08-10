---
title: Introducing Hilbert. A Go library to map values onto a Hilbert curve.
slug: introducing-hilbert
description: A Hilbert curve is a space-filling (snakey) curve through a 2D space. This can be very useful for mapping a 1D value, into a 2D space. I recently created a library for Go that can map to and from a curve. The project is hosted on Github, and can be used like so.
images:
- hilbert.png
author: bramp
categories:
- Blog
date: 2015-08-07T20:53:41-07:00
layout: post
tags:
- hilbert
- golang
- opensource
---

A [Hilbert curve][1] is a space-filling (snakey) curve through a 2D space:

{{< figure src="hilbert.png" title="Image of 8 by 8 Hilbert curve" >}}

This can be very useful for mapping a 1D value, into a 2D space. For example, it is commonly used to [map IP addresses into a 2D space][2].

I recently created a library for [Go][4] that can map to and from a curve. The project is [hosted on Github][3], and can be used like so:

```go
import "github.com/google/hilbert"

// Create a Hilbert curve for mapping to and from a 16 by 16 space.
s, err := hilbert.New(16)

// Now map one dimension numbers in the range [0, N*N-1], to an x,y
// coordinate on the curve where both x and y are in the range [0, N-1].
x, y, err := s.Map(t)

// Also map back from (x,y) to t.
t, err := s.MapInverse(x, y)
```

The project contains some demos, such as this cool animations:

{{< figure src="hilbert_animation.gif" title="Hilbert curve animation" >}}

[1]: https://en.wikipedia.org/wiki/Hilbert_curve
[2]: https://xkcd.com/195/
[3]: http://github.com/google/hilbert
[4]: https://golang.org/
