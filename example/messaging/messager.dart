
library messager;

import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'package:web_ui/watcher.dart' as watcher;

class Messager extends WebComponent {
  
  bool get hasTarget => target != null;
  String message = '';
  
  List received = new List();
  
  WindowBase _target;
  WindowBase get target  => _target;
             set target(value) {
               _target = value;
               watcher.dispatch();
             }
  
  void inserted() {
    window.on.message.add((e) {       
      
      // If we don't yet have a target, grab the source of this message.
      if(!hasTarget) target = e.source;
      
      var date = new Date.now();
      
      // TODO: parse e.data as json and extract 'sender', 'message'
      
      received.addLast([e.source, e.data, '${date.hour}:${date.minute}']);
      watcher.dispatch();
    });
  }
  
  onSubmit(event) { 
    event.preventDefault();
    target.postMessage(message, '*');
    message = '';
  }
}
