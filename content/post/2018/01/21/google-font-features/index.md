---
author: bramp
date: 2018-01-21T16:03:36-08:00
layout: post
categories:
  - Blog
tags:
  - fonts
  - google
  - go
  - yakshaving
title: Google Font Features
slug: google-font-features
---

> **tl;dr Google Fonts doesn't supply fonts with OpenType features (such as old-style figures, or small-caps), but you can build and host the fonts yourself to support everything you need.**

I recently posted a [article which contained lots of numbers](https://blog.bramp.net/post/2018/01/16/measuring-percentile-latency/). While I was proofreading the article, I didn’t quite liked how the numbers looked, sometime the digits were below the baseline, for example:

{{< figure src="oldstyle.png" title="Oldstyle figures" width="760" height="157" >}}

Where I would have expected the top and bottom of each digit to be aligned:

{{< figure src="lining.png" title="Lining figures" width="760" height="152" >}}

This made me flashback to all the typography I learnt when [working with LaTeX](https://github.com/bramp/publication). These two styles of figures are called old-style, and lining (or sometimes lowercase and uppercase numbers). The theory is that old-style numbers flow better when mixed with text. Recall, letters like q, j and p, all drop below the baseline, which makes the text nicer to read:

{{< figure src="quickbrownfox.png" title="Example with characters below the baseline" width="760" height="100" >}}

However, my article had many numbers on the page, sometimes within tables, where old-style just made the numbers look odd. I looked for a way to force the lining style throughout. I quickly found the CSS styling:

```css
body {
           font-variant-numeric: lining-nums; 
  -webkit-font-feature-settings: "lnum" on;
     -moz-font-feature-settings: "lnum" on;
      -ms-font-feature-settings: "lnum" on;
          font-feature-settings: "lnum" on;
}
```

Sadly when I applied this to my site, it did nothing. I wondered if perhaps the font did not support lining figures. A quick search led me to [Stack Overflow](https://stackoverflow.com/questions/28098992/google-fonts-lining-numbers) that implied both the font I was using, [Raleway](https://fonts.google.com/specimen/Raleway), and Google Fonts (which hosted the font) did in fact support lining.

So I went deeper down the rabbit hole to figure out what was going wrong. I wanted to confirm for myself that the font supported lining figures. I searched for a while for a simple CLI that would inspect the [WOFF](https://en.wikipedia.org/wiki/Web_Open_Font_Format)/[TTF](https://en.wikipedia.org/wiki/TrueType) files and tell me what they contained. Sadly, the best I could find was [FontForge](https://fontforge.github.io/), a GUI. That worked, and confirmed the fonts being served by Google did not contain the lining feature, or in fact any feature other than basic ligatures.

Later I found this [GitHub issue](https://github.com/google/fonts/issues/1335) which confirmed all features were stripped from the font. So I sought out a way to rebuild the Google font to keep the lining figures.

Before that, I started to [shave another yak](http://sethgodin.typepad.com/seths_blog/2005/03/dont_shave_that.html), and decided to create a CLI tool that would easily display the font features. I came across a Go library, [SFNT](https://github.com/ConradIrwin/font) that can parse OpenType fonts. Sadly it didn’t implement the parsing of the features. A few hours later, I read the [OpenType spec](http://www.adobe.com/devnet/opentype/afdko/topic_feature_file_syntax.html) and sent them a [pull request](https://github.com/ConradIrwin/font/pull/3) to add this functionality. Now I can easily confirm from the command line what features are supported.

```bash
$ font features raleway-v12-latin-ext_latin-regular.woff
Glyph Substitution Table (GSUB):
	Script "latn" (Latin):
		Default Language:
			Feature "liga" (Standard Ligatures)
```

I decided to play around with [Google Font API](https://developers.google.com/fonts/docs/developer_api), and then eventually the unoffical (but awesome) [google-webfonts-helper](https://google-webfonts-helper.herokuapp.com/fonts/raleway) (a hassle-free way to self-host Google Fonts). However, no combination of options would make the font contain the lining figures.

Since the Google Fonts are open source, I downloaded the [source TTF of the font](https://github.com/google/fonts/tree/master/ofl/raleway), and double-checked it did indeed contain the feature:

```bash
$ font features Raleway-Regular.ttf 
Glyph Substitution Table (GSUB):
  Script "latn" (Latin):
    Default Language:
      Feature "aalt" (Access All Alternates)
      Feature "dlig" (Discretionary Ligatures)
      Feature "liga" (Standard Ligatures)
      Feature "lnum" (Lining Figures)
      Feature "onum" (Oldstyle Figures)
      Feature "salt" (Stylistic Alternates)
      Feature "smcp" (Small Capitals)
      Feature "ss01" (Stylistic Set 1)
      Feature "ss02" (Stylistic Set 2)
```

So my next idea was to take the original Raleway-Regular.ttf and convert it to [WOFF](https://en.wikipedia.org/wiki/Web_Open_Font_Format) and [WOFF2](https://www.w3.org/TR/WOFF2/), and strip out the bits I don’t need. Just how Google Fonts does, to ensure the resulting files are lean and performant.

I couldn’t find the pipeline Google Fonts uses to process the files, so I instead took it upon myself to figure this out. I started by using `pyftsubset` (part of [FontTools](https://github.com/fonttools/fonttools)) to remove unneeded character sets, features, and other parts from the original TTF file.

```bash
$ pip install fonttools
$ pyftsubset Raleway-Regular.ttf --layout-features='*' --unicodes="U+0000-00FF, U+0100-024F, U+0131, U+0152-0153, U+02DA, U+02DC, U+02BB-02BC, U+02C6, U+0259, U+0370-03FF, U+1E00-1EFF, U+2000-206F, U+2070-209F, U+2074, U+20A0-20CF, U+2122, U+2150-218F, U+2200-22FF, U+2C60-2C7F, U+A720-A7FF" --output-file=Raleway-Regular.subset.ttf
```

Now I had a TTF file with all the features, but only the subset of characters I use on my site. Next I needed to convert this this file to all the [recommended font formats](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/webfont-optimization), so my site would look nice in IE, Chrome, Android and iOS. The resulting CSS would look like this:

```css
@font-face {
  font-family: 'Raleway';
  src: url('raleway-regular.subset.eot'); /* IE9 Compat Modes */
  src: local('Raleway'), local('Raleway-Regular'),
       url('raleway-regular.subset.eot?#iefix') format('embedded-opentype'), /* IE6-IE8 */
       url('raleway-regular.subset.woff2') format('woff2'),    /* Super Modern Browsers */
       url('raleway-regular.subset.woff') format('woff'),     /* Pretty Modern Browsers */
       url('raleway-regular.subset.ttf') format('truetype'),    /* Safari, Android, iOS */
       url('raleway-regular.subset.svg#ralewayregular') format('svg');    /* Legacy iOS */
  font-style: normal;
  font-weight: 400;
}
```

I again tried to use `pyftsubset` to save the files in the required formats. This worked well for TTF, WOFF, and WOFF2. But didn’t support [EOT](https://en.wikipedia.org/wiki/Embedded_OpenType) or [SVG](http://caniuse.com/svg-fonts) fonts:

```bash
$ pip install zopfli
$ pip install brotli
$ pyftsubset ... --flavor=woff --with-zopfli --output-file=Raleway-Regular.subset.woff
$ pyftsubset ... --flavor=woff2 --output-file=Raleway-Regular.subset.woff2
```

So instead I searched for a all-in-one solution to converting fonts. I found numerous websites that offered to do it, the one I settled on was [fontsquirrel.com](https://www.fontsquirrel.com/tools/webfont-generator). Here I used the expert feature, to control exactly what was in the font, and to produce compressed versions in all file formats. I originally tried to use the subsetting feature on fontsquirrel, but I couldn’t get it to maintain all the features I needed, so I used `pyftsubset` locally instead. 

After fontsquirrel.com produced the fonts, I checked it contained the features, and compared the resulting file sizes:

```bash
$ ls -ltr

# Google Fonts
-rw-r--r--@ 1 bramp  eng    96K 21 Jan 10:29 raleway-v12-latin-ext_latin-regular.ttf
-rw-r--r--@ 1 bramp  eng    40K 21 Jan 10:29 raleway-v12-latin-ext_latin-regular.woff
-rw-r--r--@ 1 bramp  eng    31K 21 Jan 10:29 raleway-v12-latin-ext_latin-regular.woff2

# My versions
-rw-r--r--@ 1 bramp  eng   140K 21 Jan 18:35 raleway-regular.subset-webfont.ttf
-rw-r--r--@ 1 bramp  eng    61K 21 Jan 18:35 raleway-regular.subset-webfont.woff
-rw-r--r--@ 1 bramp  eng    46K 21 Jan 18:35 raleway-regular.subset-webfont.woff2

$ font features raleway-regular.subset-webfont.woff
Glyph Substitution Table (GSUB):
	Script "latn" (Latin):
		Default Language:
			Feature "aalt" (Access All Alternates)
			Feature "dlig" (Discretionary Ligatures)
			Feature "liga" (Standard Ligatures)
			Feature "lnum" (Lining Figures)
			Feature "onum" (Oldstyle Figures)
			Feature "salt" (Stylistic Alternates)
			Feature "smcp" (Small Capitals)
			Feature "ss01" (Stylistic Set 1)
			Feature "ss02" (Stylistic Set 2)
```

The file size didn't vary too much, and thus it was a simple matter of [uploading the fonts](https://blog.bramp.net/fonts/raleway-regular.subset-webfont.woff2) to my blog, and updating the CSS.

<p class="text-center">
<span class="onum" style="text-decoration: red underline overline; font-size: 3.9em">1234567890</span> &nbsp;vs&nbsp; <span class="lnum" style="text-decoration: red underline overline; font-size: 3.9em">1234567890</span>
</p>