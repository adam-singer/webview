
library webview;

import 'dart:html';
import 'dart:json';
import 'package:js/js.dart' as js;
import 'package:web_ui/web_ui.dart';

class Webview extends WebComponent {
 
  const Map _EVENTS = const { 
    'exit' : const ['processId', 'reason'],
    'loadabort' : const ['url', 'isTopLevel', 'reason'],
    'loadcommit' : const ['url', 'isTopLevel'],
    'loadredirect' : const ['oldUrl', 'newUrl', 'isTopLevel'],
    'loadstart' : const ['url', 'isTopLevel'],
    'loadstop' : const [],
    'sizechanged': const ['oldHeight', 'oldWidth', 'newHeight', 'newWidth']
  };
  
  // TODO: src should be a 2-way binding
  String get src => 'http://www.google.com';
  
  bool get canGoBack => js.scoped(() => js.context.webview.canGoBack());
  
  bool get canGoForward => js.scoped(() => js.context.webview.canGoForward());
  
  bool _isSupported = false;
  bool get isSupported => _isSupported;
  
  int get processId => js.scoped(() => js.context.webview.getProcessId());
  
  js.Callback _onEvent;
  
  void inserted() {
    js.scoped(() {
      _onEvent = new js.Callback.many(_dispatch);
      _isSupported = js.context.webview.init(_onEvent);
    });
  }
  
  void removed() => js.scoped(() => _onEvent.dispose());

  void back() => js.scoped(() => js.context.webview.back());
  
  void forward() => js.scoped(() => js.context.webview.forward());

  void reload() => js.scoped(() => js.context.webview.reload());
  
  void stop() => js.scoped(() => js.context.webview.stop());
  
  void terminate() => js.scoped(() => js.context.webview.terminate());
  
  bool _dispatch(e) {
    // TODO(rms): explore better ways to do this
    var detail = new Map();
    var props = _EVENTS[e.type];
    for(var p in props) {      
      switch(p) {
        case 'isTopLevel' : detail['isTopLevel'] = e.isTopLevel; break;  
        case 'oldHeight' : detail['oldHeight'] = e.oldHeight; break;
        case 'oldUrl' : detail['oldUrl'] = e.oldUrl; break;
        case 'oldWidth' : detail['oldWidth'] = e.oldWidth; break;
        case 'newHeight' : detail['newHeight'] = e.newHeight; break;
        case 'newUrl' : detail['newUrl'] = e.newUrl; break;
        case 'newWidth' : detail['newWidth'] = e.newWidth; break;
        case 'processId' : detail['processId'] = e.processId; break;
        case 'reason' : detail['reason'] = e.reason; break;
        case 'url': detail['url'] = e.url; break;
      }
    }      
    on[e.type].dispatch(
      new CustomEvent(e.type, e.bubbles, e.cancelable, JSON.stringify(detail))); 
  }
}
