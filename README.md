# Webview

A Dart [web component][] for the Chrome App [webview][] element.

Webview uses the MIT license as described in the LICENSE file, and 
[semantic versioning][].

## The `Webview` Element

The `<webview>` tag allows you to embed external content (e.g. a web page) in
your Chrome app.  The `<iframe>` element is disabled in Chrome apps, and this is
its replacement.  Contrary to an `<iframe>`, a `Webview` displays its content
in a separate process.  This provides extra security and its storage is isolated
from the application.  You may obtain the `Webview`'s `contentWindow` and use
this for bidirectional communication via `postMessage`.

### A Dart Web Component, or, `<x-webview>` vs. `<webview>`

The `<webview>` element is the custom element (a web component in its own right)
that is exposed to Chrome apps.  However, it is not (yet) directly accessible
in the [Dart] SDK.  Therefore, the only way to interact with it at present is in
javascript.  That is where `<x-webview>` comes to the rescue!  This package
provides a strongly typed Dart web component wrapper element, `<x-webview>`, to
expose the entire `<webview>` API in [Dart][] to Chrome apps written in Dart.

## Quick Start

Create an instance of `<x-webview>` following the standard practices of any
[web component][]:

	1) Add a component link from your application's html `<head>`:
	`<link rel="components" href="packages/webview/webview.html">`
	
	2) Add an element to your html `<body>`:
	`<x-webview src="{{'http://news.google.com/'}}"></x-webview>`

	3) Query the element from your dart `<script>` and make API calls:
	```dart
	var webview = document.query('x-webview').xtag;
	webview.reload();
	```
	
Explore and run the examples:
	
	-[Browser][] is a direct port of the Chrome App's javascript example.
	-[Messaging][] illustrates bidirectional communication between a Chrome App
	and the embedded content of a `Webview'.

[Browser]: https://github.com/rmsmith/webview/tree/master/example/browser
[Dart]: http://www.dartlang.org/
[Messaging]: https://github.com/rmsmith/webview/tree/master/example/messaging
[semantic versioning]: http://semver.org/
[web component]: http://pub.dartlang.org/packages/web_ui
[webview]: https://developer.chrome.com/trunk/apps/app_external.html
