# Webview Changes

## 0.0.3-dev

- Added `isLoaded` getter.  The first `Webview` to be inserted in the DOM will
inject the js script, which is an async operation.  Therefore, the `Webview` API
may not be immediately available to the user and `isLoaded` should be polled.
All API calls prior to `isLoaded == true` will throw a `StateError`.

- Support getting the `contentWindow` of a `Webview`.

## 0.0.2

- Added homepage to pubspec to please `pub lish`.

## 0.0.1

- Initial release.
