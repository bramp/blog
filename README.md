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
This project uses a locked Hugo version defined in `.hugo-version`.

```bash
# To run locally, ensure you have the correct Hugo version.
# You can use the wrapper script:
./hugo.sh version

# For minifiying/linting (handled automatically in CI)
npm install
```

New Article
-----------
```bash
# Create a new post
./hugo.sh new post/$(date +%Y-%m-%d)-the-title.md

# Preview locally
make watch

# Once done, commit and push to master. 
# GitHub Actions will automatically build and deploy the site.
git add content/post/...
git commit -m "Add new post"
git push origin master
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
# Ensure the images are at a resonable size (720px wide by whatever height)
convert orig.png -resize 720x resize.png

# Consider retina displays
convert orig.png -resize 1440x resize@2x.png
```

Optimise Images
---------------
```bash
find content static -name '*.png' | parallel --no-notice --tag zopflipng -y "{}" "{}"
find content static -name '*.gif' | parallel --no-notice --tag gifsicle -O -o "{}" "{}"
```


Deployment
----------
Deployment is handled automatically by **GitHub Actions** whenever changes are pushed to the `master` branch. 

The workflow:
1. Installs the Hugo version specified in `.hugo-version`.
2. Clones external Go repositories listed in `repos.txt` for `goredirects`.
3. Builds and minifies the site.
4. Deploys to GitHub Pages.

You can monitor the status in the **Actions** tab of the GitHub repository.


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

TODO (Modernization)
--------------------
- [ ] Use **Hugo Image Processing** to automate WebP conversion and responsive resizing (`srcset`).
- [ ] Migrate CSS/JS minification and fingerprinting to **Hugo Pipes** to remove Node.js and custom `md5ln.sh` dependencies.
- [ ] Explore **Hugo Modules** for managing `goredirects` and other external build components.
- [ ] Consolidate the parallel image optimization scripts into a single GitHub Action or Hugo build hook.
- [ ] Add a **Build Validation Step** to the CI pipeline to ensure no critical files (redirects, legacy assets) are missing from the `public/` directory before deployment.

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