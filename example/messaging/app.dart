
import 'dart:async';
import 'dart:html';
import 'dart:json' as json;
import 'package:js/js.dart' as js;
import 'package:web_ui/watcher.dart' as watcher;

String contentUrl = '';

main() {
  // xtag is null until the end of the event loop (known dart web ui issue)
  new Timer(0, (t) {
    var webview = document.query('x-webview').xtag;    
    webview.onLoadCommit.listen(onLoadCommit);
        
    // TODO(rms): We would like to build a content url of the form:
    // 'chrome-extension://<extensionID>/<pathToFile>' as described:
    // http://developer.chrome.com/extensions/overview.html
    // But it seems this does not yet work, track this issue:
    // http://code.google.com/p/chromium/issues/detail?id=157626
    // contentUrl = js.scoped(() => 
    //   js.context.chrome.runtime.getURL("out/example/messaging/peer.html"));        
    contentUrl = 'http://127.0.0.1:3030/D:/github/webview/example/messaging/out/example/messaging/embed.html';
    watcher.dispatch();
  });
}

onLoadCommit(event) {  
  var detail = json.parse(event.detail);
  if (!detail['isTopLevel']) return;
  // Once the embedded content has finished loading, we grab the contentWindow
  // off of the webview and use it to initialize the messager
  var contentWindow = document.query('x-webview').xtag.contentWindow;
  document.query('x-messenger').xtag.target = contentWindow;
}
