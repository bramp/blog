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
go get -v github.com/spf13/hugo

pip install Pygments
pip install bibtex-pygments-lexer

# For minifiying/linting
npm install clean-css
npm install uglify-js
npm install html-minifier
brew install parallel # or sudo apt-get install parallel
```

Build
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

TODO
----
 [ ] Fix disqus (dsq_thread_id). Have to update URLs on disque
 [x] Problem parsing last link in markdown. (e.g [N] doesn't work) Fix at https://github.com/russross/blackfriday/issues/180
 [x] Check the links haven't changed. Write script to check all URLs on bramp.net still exist
 [x] Test 404
 [x] Center all tables
 [x] Ensure no broken links

TODO (nice to have)
 [ ] Amazon code
 [ ] Tag cloud
 [ ] Change to a full width layout (like http://blog.gopheracademy.com/)
 [x] Makefile, compress html, etc
 [ ] Add a "edit me link"
 [x] Test twitter card
 [x] Investigate facebook card
 [x] Minify JS/CSS
 [ ] Report bug in hugo with tags with dots in the name. For example "last.fm" is handled incorrectly.
 [ ] Sitemap.xml does not contain all pages (such as /opensource-project/*)
 [ ] The Summary/Descriptions are wrong on pages using the <!--more--> syntax
