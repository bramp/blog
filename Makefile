.PHONY: all clean minify serve

HUGO := ./hugo.sh
HTML_MINIFIER := html-minifier -c html-minifier.conf

# All input files
FILES=$(shell find content layouts static themes -type f)

all: public minify

public: $(FILES)
	$(HUGO)
	# Post process some files (to make the HTML more bootstrap friendly)
	grep -IR --null -l -- "<table" public/ | xargs -0 sed -i '' 's/<table/<table class="table"/g'
	grep -IR --null -l -- "<th" public/ | xargs -0 sed -i '' 's/<th align="/<th class="text-/g'
	grep -IR --null -l -- "<td" public/ | xargs -0 sed -i '' 's/<td align="/<td class="text-/g'
	touch $@

minify: .minified

.minified: public html-minifier.conf
	#find public -type f -iname '*.html' -print -exec \
	#	$(HTML_MINIFIER) "{}" -o "{}" \;
	find public -type f -iname '*.html' | parallel --tag $(HTML_MINIFIER) "{}" -o "{}"
	touch .minified

watch: clean
	$(HUGO) server -w

server: public
	cd public && python -m SimpleHTTPServer 1313

clean:
	-rm -rf public
	-rm .minified
