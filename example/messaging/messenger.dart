
library messenger;

import 'dart:html';
import 'dart:json' as json;
import 'package:web_ui/web_ui.dart';
import 'package:web_ui/watcher.dart' as watcher;

class Messenger extends WebComponent {
  
  bool get hasTarget => target != null;
  String message = '';
  String name = '';
  
  List received = new List();
  
  WindowBase _target;
  WindowBase get target  => _target;
             set target(value) {
               _target = value;
               watcher.dispatch();
             }
  
  void inserted() {
    window.onMessage.listen((e) {             
      // If we don't yet have a target, grab the source of this message.
      if(!hasTarget) target = e.source;
      
      var data = json.parse(e.data);
      var date = new Date.now();
      
      received.addLast([data['sender'], data['message'], 
                        '${date.hour}:${date.minute}']);
      watcher.dispatch();
    });
  }
  
  send(event) { 
    event.preventDefault();
    var data = new Map();
    data['sender'] = name;
    data['message'] = message;    
    target.postMessage(json.stringify(data), '*');
    message = '';
  }
}
