
import 'dart:html';
import 'dart:isolate';
import 'dart:json';

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
  print('webview fired exit');
  // TODO: 
}

handleLoadAbort(event) {
  print('webview fired load abort');
  // TODO: 
}

handleLoadCommit(event) {
  print('webview fired load commit');
  
  resetExitedState();
  
  var detail = JSON.parse(event.detail);
  
  if (!detail['isTopLevel']) return;

  (document.query('#location') as InputElement).value = detail['url'];

  var webview = document.query('x-webview').xtag;
  (document.query('#back') as ButtonElement).disabled = !webview.canGoBack;
  (document.query('#forward') as ButtonElement).disabled = 
      !webview.canGoForward;
}

handleLoadRedirect(event) {
  print('webview fired load redirect');
  // TODO: 
}

handleLoadStart(event) {
  print('webview fired load start');
  // TODO: 
}

handleLoadStop(event) {
  print('webview fired load stop');
  
  // We don't remove the loading class immediately, instead we let the animation
  // finish, so that the spinner doesn't jerkily reset back to the 0 position.
  isLoading = false;
}

navigateTo(url) {
  // TODO:
  //resetExitedState();
  //document.querySelector('webview').src = url;
}

resetExitedState() {
  document.body.classes.remove('exited');
  document.body.classes.remove('crashed');
  document.body.classes.remove('killed');
}
