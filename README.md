bramp.net blog
==============

This is a redesign of my wordpress blog, to a Hugo based static site.

New Features
 * Static site, no more Wordpress + PHP + MySQL maintance
 * Using Hugo (written in Go)
 * Hosted on GitHub's CDN. This gives speed and SSL
 * Simplier / Cleaner / Modern HTML design

Dependencies
```
go get -v github.com/spf13/hugo

pip install Pygments
pip install bibtex-pygments-lexer
```

Build
```
./deploy.sh
```

TODO
----
 * Fix disqus (dsq_thread_id)
 * Amazon code
 * Update internal links to be <<ref>> instead of http://bramp.net/...
 * Problem parsing last link in markdown. (e.g [N] doesn't work) Fix at https://github.com/russross/blackfriday/issues
 * Check the links haven't changed.
 * Change to a full width layout (like http://blog.gopheracademy.com/)
 * Test 404
 * The markdown has lots of entities in it, e.g &#8217; &gt; etc
 * Rewrite the ndsfs article to place the code on github
 * Tag cloud
 * Check Google DNS article formatting
 * Remove wp-image-627 and other wp specific classes
 * Center all tables
 * Performance modelling of peer-to-peer routing pdf is broken
 * Makefile, compress html, etc
 * List tags and look for mispelling dups
 * Add a "edit me link"
 * Support figures {{< figure src="/media/spf13.jpg" title="Steve Francia" >}}
