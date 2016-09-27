default: build

setup:
	bower install

build: elm.js

elm.js: src/Main.elm src/JsonDateDecode.elm src/Native/JsonDateDecode.js
	elm make src/Main.elm --yes --output=elm.js

dist: elm.js index.html
	-@mkdir dist
	vulcanize index.html -o dist/index.html
	cp elm.js dist
#	copy over dependencies that vulcanize misses
	rsync -R bower_components/moment/min/moment.min.js dist
	rsync -R bower_components/moment/min/moment-with-locales.min.js dist
	rsync -R bower_components/web-animations-js/web-animations-next-lite.min.js dist
	rsync -R bower_components/webcomponentsjs/webcomponents-lite.min.js dist
	rsync -R bower_components/web-animations-js/web-animations-next-lite.min.js.map dist
