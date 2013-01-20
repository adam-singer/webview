
import 'dart:html';
import 'dart:json';

main() {
  window.on.message.add((e) {
    print('${e.data} ${e.source}');
    
    // TODO:
    
  });
}