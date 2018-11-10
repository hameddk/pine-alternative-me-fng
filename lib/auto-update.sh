#!/bin/sh

set -e

npm install --no-save https://github.com/m59peacemaker/data-alternative-me-fng

npm run build

if [ "$TRAVIS" = "true" ]; then
	git config user.email "travis@travis-ci.org"
	git config user.name "Travis CI"
fi

# if script was updated
if [ -n "`git status dist -s`" ]; then
	echo 'publishing to TradingView...'
	./lib/publish-build.mjs

	if [ "$CI" = "true" ]; then
		echo 'committing build to git...'
		git checkout master
		git add dist
		git commit -m "FnG build `date --iso-8601=minutes` [ci skip]"
		git remote remove origin
		git remote add origin "https://${GITHUB_TOKEN}@github.com/m59peacemaker/pine-alternative-me-fng.git" > /dev/null 2>&1
		git push --quiet origin master
	fi
else
	echo 'indicator is already up-to-date'
fi