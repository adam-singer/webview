
import 'dart:html';
import 'dart:json';
import 'package:web_ui/watcher.dart' as watcher;

var messages = new List<List<String>>();

main() {
  window.on.message.add((e) {
    //print('${e.data} ${e.source}');
    
    var date = new Date.now();
    messages.addLast([e.data, '${date.hour}:${date.minute}']);
    watcher.dispatch();
  });
}
