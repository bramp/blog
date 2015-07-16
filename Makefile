.PHONY: all clean minified server watch

HUGO := ./hugo.sh
HTML_MINIFIER := html-minifier -c html-minifier.conf

# All input files
FILES=$(shell find content layouts static themes -type f)

# Below are PHONY targets
all: public minified

clean:
	-rm -rf public
	-rm .minified

minified: .minified

server: public
	cd public && python -m SimpleHTTPServer 1313

watch: clean
	$(HUGO) server -w

# Below are files
public: $(FILES) config.yaml
	$(HUGO)
	# Post process some files (to make the HTML more bootstrap friendly)
	grep -IR --include=*.html --null -l -- "<table" public/ | xargs -0 sed -i '' 's/<table/<table class="table"/g'
	grep -IR --include=*.html --null -l -- "<th" public/ | xargs -0 sed -i '' 's/<th align="/<th class="text-/g'
	grep -IR --include=*.html --null -l -- "<td" public/ | xargs -0 sed -i '' 's/<td align="/<td class="text-/g'
	touch $@

.minified: public html-minifier.conf
	find public -type f -iname '*.html' | parallel --tag $(HTML_MINIFIER) "{}" -o "{}"
	touch .minified
