
function isWebviewSupported() {
  if(chrome.app.window) return true;
  return false;
}

function Webview(e, url, onEvent) {  
  this.e = e;  
  this.e.addEventListener('exit', onEvent);
  this.e.addEventListener('loadabort', onEvent);
  this.e.addEventListener('loadcommit', onEvent);
  this.e.addEventListener('loadredirect', onEvent);
  this.e.addEventListener('loadstart', onEvent);
  this.e.addEventListener('loadstop', onEvent); 
  this.e.src = url;
}

Webview.prototype.back = function() { this.e.back(); }
Webview.prototype.canGoBack = function() { return this.e.canGoBack(); }
Webview.prototype.canGoForward = function() { return this.e.canGoForward(); }
Webview.prototype.contentWindow = function() { return this.e.contentWindow; }
Webview.prototype.forward = function() { this.e.forward(); }
Webview.prototype.getProcessId = function() { return this.e.getProcessId(); }
Webview.prototype.getSrc = function() { return this.e.src; }
Webview.prototype.reload = function() { this.e.reload(); }
Webview.prototype.setSrc = function(url) { this.e.src = url; }
Webview.prototype.stop = function() { this.e.stop(); }
Webview.prototype.terminate = function() { this.e.terminate(); }
