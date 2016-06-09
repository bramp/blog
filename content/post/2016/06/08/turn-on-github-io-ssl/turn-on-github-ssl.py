#!/usr/bin/env python
# Prints a list of all owned repositories with pages.
# by Andrew Brampton 2016 https://bramp.net
#
import requests

headers = {'Authorization': 'token XXXXX'} # Replace XXXX with a token from https://github.com/settings/tokens
params = {'type': 'owner', 'page': 1}

while True:
	r = requests.get('https://api.github.com/user/repos', params=params, headers=headers)
	repos = r.json()
	if not repos:
		break

	for repo in repos:
		if repo['has_pages']:
			print "%32s %s/settings" %(repo['name'], repo['html_url'])

	params['page'] += 1
