
import 'dart:html';
import 'dart:isolate';
import 'dart:json';

main() {
  // xtag is null until the end of the event loop
  new Timer(0, (t) => onLoad());  
}

onLoad() {
  print('onLoad');

  var webview = document.query('x-webview').xtag;
  
  // TODO:
  
}
