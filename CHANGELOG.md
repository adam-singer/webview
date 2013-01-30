# Webview Changes

## 0.1.1

- Webview custom events are now exposed as `Stream<CustomEvent>` `on*` instance
member getters.  To listen to one of these events, e.g. the `onExit` event, you 
will want to do the following:
`webview.onExit.listen((e) { /* do something */} );`
- Updated to SDK 0.3.2_r17657.

## 0.1.0

- More documentation and published an [article][].

## 0.0.4

- README and dartdoc additions and improvements.
- Updated to SDK 0.3.1_r17328.

## 0.0.3

- Added [messaging][] example to demonstrate bidirectional communication between
a Chrome App and the content of a `Webview` using `postMessage`.
- Support getting the `contentWindow` of a `Webview`.  The `contentWindow` is
of type `WindowBase` and you may use `postMessage` to communicate with the
`Webview`.
- Made `supported` getter `static` and renamed it from `isSupported` to align
with the similar changes being made in `dart:html` library.
- Added `available` getter.  The first `Webview` to be inserted in the DOM will
inject the js script, which is an async operation.  Therefore, the `Webview` API
may not be immediately available to the user and `available` should be polled.
All API calls prior to `available == true` will throw a `StateError`.  To avoid
polling for `available` and ensure the `Webview` is immediately available upon
insertion in the DOM, you may include the `webview.js` script directly in your
entry point html:
`<script type="text/javascript" src="packages/webview/webview.js"></script>`

## 0.0.2

- Added homepage to pubspec to please `pub lish`.

## 0.0.1

- Initial release.

[article]: http://rmsmith.github.com/2013/01/25/webview.html
[messaging]: https://github.com/rmsmith/webview/tree/master/example/messaging
