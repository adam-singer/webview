
import 'dart:html';
import 'dart:isolate';
import 'dart:json';

main() {
  // xtag is null until 1 tick later (known dart web ui issue)
  // contentWindow is undefined until 1 tick more (TODO: report Chrome bug)
  new Timer(0, (t) => new Timer(0, (t) => ready()));  
}

ready() {
  var webview = document.query('x-webview').xtag;
  print('${webview.contentWindow}');
}