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
npm install html-minifier -g
brew install parallel
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
 [ ] Check the links haven't changed. Write script to check all URLs on bramp.net still exist
 [x] Test 404
 [x] Center all tables
 [x] Ensure no broken links

TODO (nice to have)
 [ ] Amazon code
 [ ] Tag cloud
 [ ] Change to a full width layout (like http://blog.gopheracademy.com/)
 [ ] Makefile, compress html, etc
 [ ] Add a "edit me link"
 [ ] Test twitter card
 [ ] Investigate facebook card
 [ ] Minify CSS
