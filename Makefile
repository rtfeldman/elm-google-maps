default: build

setup:
	bower install

build: elm.js

elm.js: src/Main.elm src/JsonDateDecode.elm src/Native/JsonDateDecode.js
	elm make src/Main.elm --yes --output=elm.js

DISTDIR = pages

dist:
	-@mkdir $(DISTDIR)
	vulcanize index.html -o $(DISTDIR)/index.html
	cp elm.js $(DISTDIR)
#	copy over dependencies that vulcanize misses
	rsync -R bower_components/moment/min/moment.min.js $(DISTDIR)
	rsync -R bower_components/moment/min/moment-with-locales.min.js $(DISTDIR)
	rsync -R bower_components/web-animations-js/web-animations-next-lite.min.js $(DISTDIR)
	rsync -R bower_components/webcomponentsjs/webcomponents-lite.min.js $(DISTDIR)
	rsync -R bower_components/web-animations-js/web-animations-next-lite.min.js.map $(DISTDIR)

before-dist:
	git clone -b gh-pages git@github.com:fredcy/elm-polymer-calendar.git $(DISTDIR)
	cd $(DISTDIR) && git rm -rf .

after-dist:
	cd $(DISTDIR) && git add . && git commit -m 'rebuild pages' && git push
