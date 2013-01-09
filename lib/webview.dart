
library webview;

import 'dart:html';
import 'dart:json';
import 'package:js/js.dart' as js;
import 'package:web_ui/web_ui.dart';

class Webview extends WebComponent {
 
  // TODO: src should be a 2-way binding
  String get src => 'http://www.google.com';
  
  bool get canGoBack => js.scoped(() => js.context.webview.canGoBack());
  
  bool get canGoForward => js.scoped(() => js.context.webview.canGoForward());
  
  bool _isSupported = false;
  bool get isSupported => _isSupported;
  
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
    // TODO: the set of events is known (we have the code) so we should just
    // inspect e.type and assume the known details
    
    // TODO(rms): try to improve this hack.    
    var detail = new Map();    
    _tryPut(detail, 'isTopLevel', () => e.isTopLevel);
    _tryPut(detail, 'url', () => e.url);
    
    // TODO(rms): open an issue report regarding the need for 'this' below.
    this.on[e.type].dispatch(
      new CustomEvent(e.type, e.bubbles, e.cancelable, JSON.stringify(detail))); 
  }
  
  bool _tryPut(Map map, String key, Function getValue) {
    try {
      map[key] = getValue();
    } on NoSuchMethodError catch(e) { }
  }  
}
