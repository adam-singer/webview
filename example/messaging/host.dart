
import 'dart:html';
import 'dart:isolate';
import 'dart:json';
import 'package:js/js.dart' as js;
import 'package:web_ui/watcher.dart' as watcher;

bool enabled = false;
String message = '';
String contentUrl = '';

main() {
  // xtag is null until the end of the event loop (known dart web ui issue)
  new Timer(0, (t) {
    var webview = document.query('x-webview').xtag;
    webview.on['loadcommit'].add(onLoadCommit);
        
    // TODO(rms): We would like to build a content url of the form:
    // 'chrome-extension://<extensionID>/<pathToFile>' as described:
    // http://developer.chrome.com/extensions/overview.html
    // But it seems this does not yet work, track this issue:
    // http://code.google.com/p/chromium/issues/detail?id=157626
    // contentUrl = js.scoped(() => 
    //   js.context.chrome.runtime.getURL("out/example/messaging/peer.html"));        
    contentUrl = 'http://127.0.0.1:3030/D:/github/webview/example/messaging/out/example/messaging/peer.html';
    watcher.dispatch();
  });
}

onLoadCommit(event) {  
  var detail = JSON.parse(event.detail);
  if (!detail['isTopLevel']) return;
  // Once the embedded content has finished loading, we enable message sending.
  enabled = true;
  // We need to manually dispatch watchers because this event listener is not
  // bound through html template.  
  // TODO(rms): investigate binding to custom events in web ui html templates.
  watcher.dispatch();
}

onSubmit(event) { 
  event.preventDefault();
  var webview = document.query('x-webview').xtag;
  webview.contentWindow.postMessage(message, '*');
  message = '';
}
