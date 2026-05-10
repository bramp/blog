.PHONY: all clean deploy minified validate test-ci upgrade help server watch goredirects chromacss

HUGO := ./hugo.sh
NODE_MODULES := node_modules/.bin
HTML_MINIFIER := $(NODE_MODULES)/html-minifier -c html-minifier.conf
GOREDIRECTS := goredirects
EXTERNAL_REPOS_DIR := external

# All input files
FILES=$(shell find content themes -type f)

all: public minified

test:
	./test_urls.sh
	npm test

validate:
	npm test

test-ci: all test

upgrade:
	npm upgrade

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
	-rm themes/bramp/assets/css/chroma-monokai.css themes/bramp/assets/css/chroma-friendly.css
	-rm .minified
	-rm -rf $(TMPDIR)/hugo_cache

deploy:
	./deploy.sh

minified: .minified

server: public minified
	cd public && python3 -m http.server 1313

watch: chromacss
	$(HUGO) server -w -D -F -v --bind="0.0.0.0"

# Below are file based targets
public: $(FILES) config.yaml chromacss
	$(HUGO)

	# Ensure the public folder has it's mtime updated.
	touch $@

goredirects: public $(EXTERNAL_REPOS_DIR)
	@# For each repo in repos.txt, clone it if it doesn't exist
	@if [ -f repos.txt ]; then \
		while read -r url dir; do \
			if [ -z "$$dir" ]; then dir=$$(basename $$url .git); fi; \
			if [ ! -d $(EXTERNAL_REPOS_DIR)/$$dir ]; then \
				git clone --depth 1 --no-tags --single-branch $$url $(EXTERNAL_REPOS_DIR)/$$dir; \
			fi; \
		done < repos.txt; \
	fi
	$(GOREDIRECTS) bramp.net $(EXTERNAL_REPOS_DIR) public

$(EXTERNAL_REPOS_DIR):
	mkdir -p $@

.minified: public goredirects html-minifier.conf
	# Find all HTML and in parallel run the minifier
	$(HTML_MINIFIER) --input-dir public --file-ext html --output-dir public
	touch $@

chromacss: themes/bramp/assets/css/chroma-monokai.css themes/bramp/assets/css/chroma-friendly.css

themes/bramp/assets/css/chroma-monokai.css:
	$(HUGO) gen chromastyles --style=monokai > $@

themes/bramp/assets/css/chroma-friendly.css:
	$(HUGO) gen chromastyles --style=friendly > $@

public/%.css public/%.js: public
	@# Empty rule, to force public to be built when js/css is needed.

