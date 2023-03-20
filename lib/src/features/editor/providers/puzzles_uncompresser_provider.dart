import 'dart:io';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/dir_splitter.dart';

// ignore: non_constant_identifier_names
final _DS = dirSplitter;

class PuzzleUncompressersProvider {
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
      if (file.name != ("puzzles$_DS")) {
        _includeFilesNames.add(file.name.replaceAll("puzzles/", ""));
      }
    }
    try {
      puzzleFile.deleteSync();
    } catch (e) {
      developer.log(e.toString());
    }
  }
}
