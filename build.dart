
import 'dart:io';
import 'package:web_ui/component_build.dart';

main() => build(new Options().arguments, ['example/browser/browser.html',
                                          'example/messaging/app.html',
                                          'example/messaging/embed.html'], 
                                          baseDir : '.');
