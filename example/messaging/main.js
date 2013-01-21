/**
 * Listens for the app launching then creates the window
 *
 * @see http://developer.chrome.com/trunk/apps/app.runtime.html
 * @see http://developer.chrome.com/trunk/apps/app.window.html
 */
chrome.app.runtime.onLaunched.addListener(function() {
	
  // Notice that we launch the dwc (web ui compiler) generated html
  
  chrome.app.window.create('out/example/messaging/app.html', {
    'width': 1024,
    'height': 768
  });
});
