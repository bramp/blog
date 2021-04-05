bramp.net blog
==============

This is a redesign of my wordpress blog, to a Hugo based static site.

New Features
 * Static site, no more Wordpress + PHP + MySQL maintance
 * Using Hugo (written in Go)
 * Hosted on GitHub's CDN. This gives speed and SSL
 * Simplier / Cleaner / Modern HTML design

Dependencies
------------
```bash
# Install hugo (Mac)
brew install hugo@v0.82

# Install hugo (Linux)
sudo apt-get install hugo

# Install hugo (Other)
go get github.com/kardianos/govendor
govendor get github.com/spf13/hugo@v0.82

# For minifiying/linting
npm install clean-css-cli@4.1.10 uglify-js@3.2.1 html-minifier@3.5.7 purify-css@1.2.5
brew install parallel # or sudo apt-get install parallel
brew install zopfli
```

New Article
-----------
```bash
# `make help` shows the example:
hugo new post/2017-07-15-the-title.md
nano content/post/2017-07-15-the-title.md
make watch

# Once done commit your changes
git add content/post/2017-07-15-the-title.md
git commit
```

Tables
------

The Bootstrap CSS requires that all tables have a `class="table"` added to them. It's a inconvience, but we have a Hugo shortcode to try and fix this for us. Please use the syntax:

```markdown
{{<table "table">}}

| Your | Table |
|------|-------|
| Goes | Here  |

{{</table>}}
```

or any of the [other styles](https://bootstrapdocs.com/v3.2.0/docs/css/#tables), such as `{{<table "table table-striped table-hover table-condensed table-bordered">}}

Resize Images
---------------
```bash
# Ensure the images are at a resonable size
convert orig.png -resize 200x resize.png

# Consider retina displays
convert orig.png -resize 400x resize@2x.png
```

Optimise Images
---------------
```bash
find content static -name '*.png' | parallel --no-notice --tag zopflipng -y "{}" "{}"
find content static -name '*.gif' | parallel --no-notice --tag gifsicle -O -o "{}" "{}"
```


Deploy
-----
```bash
./deploy.sh
```


Checks
------
```bash
linkchecker http://localhost:1313/ > log.internal
linkchecker --check-extern http://localhost:1313/ > log.external
```

Font Awesome
------------
Font Awesome contains some awesome icons, but sadly is huge! So I used icomoon to make a svg sprite of the icons I want, and use slightly different options to display them on the screen.
Info: https://usolved.net/blog/post/switch-from-icon-fonts-to-svg-icons

TODO
----
- [ ] Fix disqus (dsq_thread_id). Have to update URLs on disque
- [x] Problem parsing last link in markdown. (e.g [N] doesn't work) Fix at https://github.com/russross/blackfriday/issues/180
- [x] Check the links haven't changed. Write script to check all URLs on bramp.net still exist
- [x] Test 404
- [x] Center all tables
- [x] Ensure no broken links

TODO (nice to have)
- [ ] Amazon code
- [ ] Tag cloud
- [ ] Change to a full width layout (like http://blog.gopheracademy.com/)
- [x] Makefile, compress html, etc
- [ ] Add a "edit me link"
- [x] Test twitter card
- [x] Investigate facebook card
- [x] Minify JS/CSS
- [ ] Report bug in hugo with tags with dots in the name. For example "last.fm" is handled incorrectly.
- [ ] Sitemap.xml does not contain all pages (such as /opensource-project/*)
- [ ] The Summary/Descriptions are wrong on pages using the <!--more--> syntax
- [ ] Hugo v0.58.0 Adds support for image manulation, plus extracting metadata. (e.g {{ ($myimg | fingerprint ).Width }}	or {{ $image.Resize "600x jpg #b31280" }}
- [ ] Hugo v0.62.1 Demonstrates truly portable Markdown links and images, whether browsed on GitHub or deployed as a Hugo site.
- [ ] Hugo v0.68.0 Native minifier, perhaps use it?
- [ ] Use PageSpeed Insights to improve load performance
- [ ] Disque causes the page to load slowly. Is there a way to improve that?
- [ ] Set up better caching with CloudFlare. Github pages by default only cache for 10 minutes! https://webmasters.stackexchange.com/questions/30609/leverage-browser-caching-on-github-pages
- [ ] Replace addthis with sharethis (it seems to have rebranded itself)
- [ ] Update to the latest disque code: https://bramp.disqus.com/admin/settings/universalcode/ 