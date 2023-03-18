import 'dart:io';
 

final  dirSplitter = Platform.isWindows ? '\\' : '/';

String fileName(String path) {
  final splitted = path.split(dirSplitter);
  return splitted.last;
}