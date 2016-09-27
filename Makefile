build: elm.js

elm.js: Main.elm JsonDateDecode.elm Native/JsonDateDecode.js
	elm make Main.elm --output=elm.js
