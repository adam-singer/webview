# Webview Changes

## 0.0.3-dev

- Added `available` getter.  The first `Webview` to be inserted in the DOM will
inject the js script, which is an async operation.  Therefore, the `Webview` API
may not be immediately available to the user and `available` should be polled.
All API calls prior to `available == true` will throw a `StateError`.  To avoid
polling for `available` and ensure the `Webview` is immediately available upon
insertion in the DOM, you may include the `webview.js` script directly in your
entry point html:

  `<script type="text/javascript" src="packages/webview/webview.js"></script>`

- Support getting the `contentWindow` of a `Webview`.

## 0.0.2

- Added homepage to pubspec to please `pub lish`.

## 0.0.1

- Initial release.
