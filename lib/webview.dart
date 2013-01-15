
library webview;

import 'dart:html';
import 'dart:json';
import 'package:js/js.dart' as js;
import 'package:web_ui/web_ui.dart';
import 'package:web_ui/watcher.dart' as watcher;

class Webview extends WebComponent {
 
  static const Map _EVENTS = const { 
    'exit' : const ['processId', 'reason'],
    'loadabort' : const ['url', 'isTopLevel', 'reason'],
    'loadcommit' : const ['url', 'isTopLevel'],
    'loadredirect' : const ['oldUrl', 'newUrl', 'isTopLevel'],
    'loadstart' : const ['url', 'isTopLevel'],
    'loadstop' : const [],
    'sizechanged': const ['oldHeight', 'oldWidth', 'newHeight', 'newWidth']
  };
  
  String _src = '';
  String get src => _src;
         set src(value) {
    _src = value; 
    watcher.dispatch();
  }
         
  bool get canGoBack => _call(() => _webview.canGoBack());
  
  bool get canGoForward => _call(() => _webview.canGoForward());
  
  _Window _contentWindow;
  WindowBase get contentWindow {
    if(_contentWindow == null) {
      _contentWindow = _call(() => new _Window(_webview.contentWindow()));
    }
    return _contentWindow;
  }
  
  bool _isSupported = true;
  bool get isSupported => _isSupported;
  
  int get processId => _call(() => _webview.getProcessId());
  
  js.Callback _onEvent;
  js.Proxy _webview;
  
  void inserted() {    
    // TODO: check first if the document already has the script
    var script = new ScriptElement();
    script.type = "text/javascript";
    script.src = "packages/webview/webview.js";
    document.body.append(script);
    
    script.on.load.add((e) {
      js.scoped(() {
        _onEvent = new js.Callback.many(_dispatch);
        _webview = js.retain(js.context.webview);
        _isSupported = _webview.init(_onEvent);
      });
      watcher.dispatch();
    });   
  }
  
  void removed() {
    js.scoped(() {
      _onEvent.dispose();
      js.release(_webview);
      if(_contentWindow != null) _contentWindow._dispose();
    });
  }

  void back() => _call(() => _webview.back());  
  
  void forward() => _call(() => _webview.forward());
  
  void reload() => _call(() => _webview.reload());  
  
  void stop() => _call(() => _webview.stop());  
  
  void terminate() => _call(() => _webview.terminate());
  
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
  
  _call(f()) {
    if(!isSupported) throw new UnsupportedError('Webview is not supported.');
    if(_webview == null) throw new StateError('Webview is not initialized.');
    return js.scoped(f);
  }
}

class _Window implements WindowBase {
  
  bool get closed => js.scoped(() => _proxy.closed);  
  
  HistoryBase get history { throw new UnimplementedError(); }
  
  LocationBase get location { throw new UnimplementedError(); }
  
  WindowBase get opener { throw new UnimplementedError(); }
  
  WindowBase get parent { throw new UnimplementedError(); }
  
  WindowBase get top { throw new UnimplementedError(); }
  
  js.Proxy _proxy;
  
  _Window(js.Proxy proxy) {_proxy = js.retain(proxy); }
  
  void _dispose() => js.release(_proxy);
  
  void close() => js.scoped(() => _proxy.close()); 

  void postMessage(message, String targetOrigin, [List messagePorts]) {
    throw new UnimplementedError();
  }
}
