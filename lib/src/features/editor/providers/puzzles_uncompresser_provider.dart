import 'dart:io';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:archive/archive_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../utils/dir_splitter.dart';

// ignore: non_constant_identifier_names
final _DS = dirSplitter;

class PuzzleUncompressersProvider extends ChangeNotifier {
  late final Directory _appDocDir;
  Directory get appDocDir => _appDocDir;

  final List<String> _includeFilesNames = [];
  List<String> get puzzlesFilesNames => _includeFilesNames;

  Future<void> init(AssetBundle rootBundle) async {
    final appDocDic = await getApplicationDocumentsDirectory();
    _appDocDir =
        Directory('${appDocDic.absolute.path}$_DS.chialisp_playground');
    if (!_appDocDir.existsSync()) {
      _appDocDir.createSync(recursive: true);
    }
    developer.log(_appDocDir.absolute.path);

    File puzzleFile = File('${_appDocDir.path}${_DS}puzzles.zip');
    await _unArchivePuzzleFile(puzzleFile, rootBundle);
  }

  Future<bool> installCipherLib() async {
    const url =
        "https://github.com/hashgreen/cypher-chialisp/archive/refs/heads/main.zip";
    final cipherLibFile = File('${_appDocDir.path}${_DS}cypher-chialisp.zip');
    final tempFolder = Directory('${_appDocDir.path}${_DS}temp_unzip');
    if (tempFolder.existsSync()) {
      tempFolder.deleteSync(recursive: true);
    }
    if (!tempFolder.existsSync()) {
      tempFolder.createSync(recursive: true);
    }
    if (cipherLibFile.existsSync()) {
      await cipherLibFile.delete();
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      await cipherLibFile.writeAsBytes(response.bodyBytes);
      final inputStream = InputFileStream(cipherLibFile.absolute.path);
      final archive = ZipDecoder().decodeBuffer(inputStream);

      for (var file in archive.files) {
        if (file.isFile) {
          final outputStream =
              OutputFileStream('${tempFolder.absolute.path}/${file.name}');

          file.writeContent(outputStream);
          outputStream.close();
        }
      }
      final cipherLibDir = Directory(
          '${tempFolder.absolute.path}${_DS}cypher-chialisp-main${_DS}cypher');
      final puzzlesDir = Directory('${_appDocDir.absolute.path}${_DS}puzzles');
      final cipherLibFiles = cipherLibDir.listSync();
      for (var file in cipherLibFiles) {
        if (file is File) {
          final fileName = file.path.split(_DS).last;
          final ext = fileName.split(".").last;
          if (ext == "clsp") {
            final newFile = File('${puzzlesDir.absolute.path}$_DS$fileName');
            if (newFile.existsSync()) {
              newFile.deleteSync();
            }
            file.copySync(newFile.absolute.path);

            _includeFilesNames.add(fileName);
          }
        }
      }

      try {
        await cipherLibFile.delete();

        tempFolder.deleteSync(recursive: true);
      } catch (e) {
        developer.log(e.toString());
      }
      notifyListeners();
      return true;
    }else{
      return false;
    }
    
  }

  Future<void> _unArchivePuzzleFile(
      File puzzleFile, AssetBundle rootBundle) async {
    if (await puzzleFile.exists()) {
      await puzzleFile.delete();
    }

    final ByteData data = await rootBundle.load('assets/puzzles.zip');
    await puzzleFile.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    final inputStream = InputFileStream(puzzleFile.absolute.path);
    final archive = ZipDecoder().decodeBuffer(inputStream);

    for (var file in archive.files) {
      if (file.isFile) {
        if (file.name.contains("__MACOSX")) continue;
        final outputStream =
            OutputFileStream('${_appDocDir.absolute.path}/${file.name}');

        file.writeContent(outputStream);
        outputStream.close();
      }
      
    }
    final puzzleDir = Directory('${_appDocDir.absolute.path}${_DS}puzzles');
    for (var file in puzzleDir.listSync()) {
      if (file is File) {
        final fileName = file.path.split(_DS).last;
        final ext = fileName.split(".").last;
        if (ext == "clsp") {
          _includeFilesNames.add(fileName);
        }
      }
    }
   
    try {
      puzzleFile.deleteSync();
    } catch (e) {
      developer.log(e.toString());
    }
  }

  static PuzzleUncompressersProvider of(BuildContext context,
      {bool listen = true}) {
    return Provider.of<PuzzleUncompressersProvider>(context, listen: listen);
  }
}
