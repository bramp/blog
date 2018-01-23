.PHONY: all clean minified server watch help goredirects chromacss

HUGO := ./hugo.sh
NODE_MODULES := node_modules/.bin
HTML_MINIFIER := $(NODE_MODULES)/html-minifier -c html-minifier.conf
UGLIFYJS := $(NODE_MODULES)/uglifyjs
CLEANCSS := $(NODE_MODULES)/cleancss
PURIFYCSS := $(NODE_MODULES)/purifycss
GOREDIRECTS := goredirects

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
	# Find all HTML and in parallel run the minifier
	find public -type f -iname '*.html' | parallel --no-notice --tag $(HTML_MINIFIER) "{}" -o "{}"
	touch $@

chromacss: themes/bramp/static/css/chroma-monokai.css themes/bramp/static/css/chroma-friendly.css

themes/bramp/static/css/chroma-monokai.css:
	$(HUGO) gen chromastyles --style=monokai > $@

themes/bramp/static/css/chroma-friendly.css:
	$(HUGO) gen chromastyles --style=friendly > $@

public/css/bootstrap-purify.css: themes/bramp/static/css/bootstrap.css public/index.html
	cd public && ../$(PURIFYCSS) -i ../$< $$(find . -type f -iname '*.html') -o ../$@

public/css/all.min.css: public/css/bootstrap-purify.css public/css/bootstrap-social.css public/css/chroma-friendly.css public/css/fonts.css public/css/bramp.css public/css/icons.css
	$(CLEANCSS) -o $@ $^

public/js/all.min.js: public/js/jquery-1.10.2.min.js public/js/bootstrap.min.js
	$(UGLIFYJS) --compress --mangle -o $@ $^

public/%.css public/%.js: public
	@# Empty rule, to force public to be built when js/css is needed.
