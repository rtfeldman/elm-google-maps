# elm-polymer-calendar

This demonstrates how to incorporate a Polymer web component into an Elm application.
In particular, it uses a `polymer-paper-date-picker` component from https://github.com/bendavis78/paper-date-picker to present a calendar and update the Elm model based on the user's choices of calendar date.

## Toolchain setup

```
npm install -g elm
npm install -g bower
npm install -g vulcanize
```

## Installation

```shell
git clone git@github.com:fredcy/elm-polymer-calendar.git
cd elm-polymer-calendar
bower install
make
```

## Serving
```
cd elm-polymer-calendar
python3 -m http.server
```

Browse http://localhost:8000/

## Discussion

The calendar component generates a JS `date-changed` event each time the user selects a date.
The `onValueChanged` function in Main.elm sets up an Elm Html event attribute that ultimately creates a `DateChanged` message.
The Elm Json.Decode functions do not provide a way to decode the JS `Date` value in that event,
so the message carries the value as a Json.Decode.Value which is later converted to an Elm `Date` value via custom native code in `JsonDateDecode.toDate`.

Running `make dist` will generate a "dist" directory with the minimal static web content needed to deploy the application.

## Credit

This started as a direct copy of a gist by Peter Damoc (@pdamoc) and relates to
[a discussion on the elm-discuss list](https://groups.google.com/forum/#!topic/elm-discuss/8Q2xwRh6UYc)

