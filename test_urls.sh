#!/bin/bash
# I break my CDN config far too often. Now I have a test!
# by Andrew Brampton

assert () {
	URL=$1
	EXPECTED=$2
	ACTUAL=$(curl -I $URL 2> /dev/null | tr '\r' '\n' | grep -i "Location:" | cut -d' ' -f 2)

	if [ "$ACTUAL" == "$EXPECTED" ]; then
		echo "'$URL' [good]"
	else
		echo "'$URL' expected '$EXPECTED' got '$ACTUAL'"
		exit
	fi
}

assert http://bramp.net/ https://blog.bramp.net/
assert http://www.bramp.net/ https://blog.bramp.net/
assert http://blog.bramp.net/ https://blog.bramp.net/
assert https://bramp.net/ https://blog.bramp.net/
assert https://www.bramp.net/ https://blog.bramp.net/
assert https://blog.bramp.net/
