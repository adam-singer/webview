
import 'dart:html';
import 'dart:isolate';
import 'dart:json';

main() {
  window.on.message.add((e) {
    print('${e.data} ${e.source} ah');
    
  });
}