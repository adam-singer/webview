
import 'dart:async';
import 'dart:html';
import 'dart:json' as json;

main() {
  // xtag is null until the end of the event loop
  new Timer(0, (t) => onLoad());  
}

var isLoading = false;

onLoad() {
  
  var webview = document.query('x-webview').xtag;
  
  document.query('#back').onClick.listen((e) => webview.back());  
  document.query('#forward').onClick.listen((e) => webview.forward());
  
  document.query('#home').onClick.listen((e) => 
      navigateTo('http://www.google.com/'));
  
  document.query('#reload').onClick.listen((e) {
    if (isLoading) {
      webview.stop();
    } else {
      webview.reload();
    }
  });
  
  document.query('#reload').$dom_addEventListener(
    'webkitAnimationIteration',
    (e) {
      if (!isLoading) {
        document.body.classes.remove('loading');
      }
  });
  
  document.query('#terminate').onClick.listen((e) => webview.terminate());
    
  document.query('#location-form').onSubmit.listen((e) {
    e.preventDefault();
    navigateTo((document.query('#location') as InputElement).value);
  });
  
  webview.onExit.listen(handleExit);
  webview.onLoadAbort.listen(handleLoadAbort);
  webview.onLoadCommit.listen(handleLoadCommit);
  webview.onLoadRedirect.listen(handleLoadRedirect);
  webview.onLoadStart.listen(handleLoadStart);
  webview.onLoadStop.listen(handleLoadStop);
}

handleExit(event) {
  var detail = json.parse(event.detail);
  document.body.classes.add('exited');
  if (detail['reason'] == 'abnormal') {
    document.body.classes.add('crashed');
  } else if (detail['reason'] == 'killed') {
    document.body.classes.add('killed');
  }
}

handleLoadAbort(event) { }

handleLoadCommit(event) {
  var detail = json.parse(event.detail);

  resetExitedState();
  
  if (!detail['isTopLevel']) return;

  (document.query('#location') as InputElement).value = detail['url'];

  var webview = document.query('x-webview').xtag;
  (document.query('#back') as ButtonElement).disabled = !webview.canGoBack;
  (document.query('#forward') as ButtonElement).disabled = 
      !webview.canGoForward;
}

handleLoadRedirect(event) {
  var detail = json.parse(event.detail);

  resetExitedState();
  
  if (!detail['isTopLevel']) return;

  (document.query('#location') as InputElement).value = detail['newUrl'];
}

handleLoadStart(event) {
  var detail = json.parse(event.detail);
  document.body.classes.add('loading');
  isLoading = true;  
  resetExitedState();
  
  if (!detail['isTopLevel']) return;

  (document.query('#location') as InputElement).value = detail['url'];
}

handleLoadStop(event) {  
  // We don't remove the loading class immediately, instead we let the animation
  // finish, so that the spinner doesn't jerkily reset back to the 0 position.
  isLoading = false;
}

navigateTo(url) {
  resetExitedState();
  document.query('x-webview').xtag.src = url;
}

resetExitedState() {
  document.body.classes.remove('exited');
  document.body.classes.remove('crashed');
  document.body.classes.remove('killed');
}
