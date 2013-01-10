
var webview = (function () {   
  var x = {}, _wv;
  x.init = function(onEvent) {
    if(chrome.app.window) {
      _wv = document.querySelector('webview');
      _wv.addEventListener('exit', onEvent);
      _wv.addEventListener('loadabort', onEvent);
      _wv.addEventListener('loadcommit', onEvent);
      _wv.addEventListener('loadredirect', onEvent);
      _wv.addEventListener('loadstart', onEvent);
      _wv.addEventListener('loadstop', onEvent);      
      return true;
    }
    return false;
  };  
  x.back = function() { _wv.back(); };  
  x.canGoBack = function() { return _wv.canGoBack(); };
  x.canGoForward = function() { return _wv.canGoForward(); };
  x.getProcessId = function() { return _wv.getProcessId(); };
  x.forward = function() { _wv.forward(); };
  x.reload = function() { _wv.reload(); };
  x.stop = function() { _wv.stop(); };
  x.terminate = function() { _wv.terminate(); };
  return x;
}());
