.PHONY: all clean minified server watch help goredirects chromacss

HUGO := ./hugo.sh
NODE_MODULES := node_modules/.bin
HTML_MINIFIER := $(NODE_MODULES)/html-minifier -c html-minifier.conf
UGLIFYJS := $(NODE_MODULES)/uglifyjs
CLEANCSS := $(NODE_MODULES)/cleancss
PURIFYCSS := $(NODE_MODULES)/purifycss
GOREDIRECTS := goredirects
MD5LN := ./md5ln.sh

# All input files
FILES=$(shell find content static themes -type f)

# Below are PHONY targets
all: public minified

help:
	@echo "Builds bramp.net's blog"
	@echo ""
	@echo "Usage: make <command>"
	@echo "  all     Builds the blog and minifies it"
	@echo "  clean   Cleans all build files"
	@echo "  server  Runs a webserver on port 1313 to test the final minified result"
	@echo "  watch   Runs hugo in watch mode, waiting for changes"
	@echo ""
	@echo "New article:"
	@echo "  hugo new post/$(shell date +%Y-%m-%d)-the-title.md"
	@echo "  $$EDITOR content/post/$(shell date +%Y-%m-%d)-the-title.md"
	@echo "  make watch"
	@echo "  open "

clean:
	-rm -rf public
	-rm themes/bramp/static/css/chroma-monokai.css themes/bramp/static/css/chroma-friendly.css
	-rm .minified
	-rm -rf $(TMPDIR)/hugo_cache

minified: .minified

server: public minified
	cd public && python -m SimpleHTTPServer 1313

watch: chromacss
	$(HUGO) server -w -D -F -v --bind="0.0.0.0"

# Below are file based targets
public: $(FILES) config.yaml goredirects chromacss
	$(HUGO)

	# Post process some files (to make the HTML more bootstrap friendly)
	# Add a table class to all tables (with don't already have a clas= field)
	# TODO Replace these grep/sed with something better
	grep -IR --include=*.html --null -l -- "<table" public | xargs -0 sed -i.bak '/<table class/!s/<table/<table class="table"/g'

	# Replace "align=..."" with class="test-..."
	grep -IR --include=*.html --null -l -- "<th" public | xargs -0 sed -i.bak 's/<th align="/<th class="text-/g'
	grep -IR --include=*.html --null -l -- "<td" public | xargs -0 sed -i.bak 's/<td align="/<td class="text-/g'

	# Cleanup after the sed backups
	find public -type f -iname '*.bak' -delete

	# Ensure the public folder has it's mtime updated.
	touch $@

goredirects:
	$(GOREDIRECTS) bramp.net public

.minified: public html-minifier.conf public/css/all.min.css public/js/all.min.js
	# HACK: After public/css/all.min.css public/js/all.min.js is calculated, we have to
	# make public again. That's because public needs the CSS to work out its hash, where
	# the css needs public to find which classes are unused.
	make public

	# Find all HTML and in parallel run the minifier
	$(HTML_MINIFIER) --input-dir public --file-ext html --output-dir public
	touch $@

chromacss: themes/bramp/static/css/chroma-monokai.css themes/bramp/static/css/chroma-friendly.css

themes/bramp/static/css/chroma-monokai.css:
	$(HUGO) gen chromastyles --style=monokai > $@

themes/bramp/static/css/chroma-friendly.css:
	$(HUGO) gen chromastyles --style=friendly > $@

themes/bramp/static/js/svgxuse.min.js: themes/bramp/static/js/svgxuse.js
	$(UGLIFYJS) --compress --mangle -o $@ $^

public/css/bootstrap-purify.css: themes/bramp/static/css/bootstrap.css public/index.html
	cd public && ../$(PURIFYCSS) -i ../$< $$(find . -type f -iname '*.html') -o ../$@

public/css/all.min.css: public/css/bootstrap-purify.css public/css/bootstrap-social.css public/css/chroma-friendly.css public/css/fonts.css public/css/bramp.css public/css/icons.css
	$(CLEANCSS) -o $@ $^
	$(MD5LN) $@

public/js/all.min.js: public/js/jquery-1.10.2.min.js public/js/bootstrap.min.js public/js/svgxuse.min.js
	$(UGLIFYJS) --compress --mangle -o $@ $^
	$(MD5LN) $@

public/%.css public/%.js: public
	@# Empty rule, to force public to be built when js/css is needed.
