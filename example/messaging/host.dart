
import 'dart:html';
import 'dart:isolate';
import 'dart:json';

main() {
  // xtag is null until 1 tick later (known dart web ui issue)
  // contentWindow is undefined until 1 tick more (TODO: report Chrome bug)
  // there also seems to be some initial delay beore we can post a message,
  // we should investigate deeper and see if there is some event we can observe.
  new Timer.repeating(1000, (t) => send()); 
}

send() {
  var webview = document.query('x-webview').xtag;
  webview.contentWindow.postMessage('bonjour from the dart!', '*');
}
