default: build

setup:
	bower install

build: elm.js

elm.js: src/Main.elm src/JsonDateDecode.elm src/Native/JsonDateDecode.js
	elm make src/Main.elm --yes --output=elm.js
