
library messager;

import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'package:web_ui/watcher.dart' as watcher;

class Messager extends WebComponent {
  
  bool get enabled => target != null;
  String message = '';
  
  WindowBase _target;
  WindowBase get target  => _target;
             set target(value) {
               _target = value;
               watcher.dispatch();
             }
  
  onSubmit(event) { 
    event.preventDefault();
    target.postMessage(message, '*');
    message = '';
  }  
}
