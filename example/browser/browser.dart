
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
  
  document.query('#back').on.click.add((e) => webview.back());  
  document.query('#forward').on.click.add((e) => webview.forward());
  
  document.query('#home').on.click.add((e) => 
      navigateTo('http://www.google.com/'));
  
  document.query('#reload').on.click.add((e) {
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
  
  document.query('#terminate').on.click.add((e) => webview.terminate());
    
  document.query('#location-form').on.submit.add((e) {
    e.preventDefault();
    navigateTo((document.query('#location') as InputElement).value);
  });
  
  webview.on['exit'].add(handleExit);
  webview.on['loadabort'].add(handleLoadAbort);
  webview.on['loadcommit'].add(handleLoadCommit);
  webview.on['loadredirect'].add(handleLoadRedirect);
  webview.on['loadstart'].add(handleLoadStart);
  webview.on['loadstop'].add(handleLoadStop);
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
