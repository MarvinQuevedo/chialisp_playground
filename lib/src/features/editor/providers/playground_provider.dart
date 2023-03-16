import 'dart:io';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class PlaygroundProvider extends ChangeNotifier {
  late final Directory _appDocDir;
  late final Directory playgroundDir;
  final List<String> _includeFilesNames = [
    "include",
    "defconstant",
    "defun",
    "defun-inline",
    "AGG_SIG_UNSAFE",
    "AGG_SIG_ME",
    "CREATE_COIN",
    "RESERVE_FEE",
    "CREATE_COIN_ANNOUNCEMENT",
    "ASSERT_COIN_ANNOUNCEMENT",
    "CREATE_PUZZLE_ANNOUNCEMENT",
    "ASSERT_PUZZLE_ANNOUNCEMENT",
    "ASSERT_MY_COIN_ID",
    "ASSERT_MY_PARENT_ID",
    "ASSERT_MY_PUZZLEHASH",
    "ASSERT_MY_AMOUNT",
    "ASSERT_SECONDS_RELATIVE",
    "ASSERT_SECONDS_ABSOLUTE",
    "ASSERT_HEIGHT_RELATIVE",
    "ASSERT_HEIGHT_ABSOLUTE",
    "REMARK"
  ];

  List<String> get includeFilesNames => _includeFilesNames;

  String get playgroundInclude => playgroundDir.absolute.path;

  Future<void> init(AssetBundle rootBundle) async {
    _appDocDir = await getApplicationDocumentsDirectory();
    developer.log(_appDocDir.absolute.path);
    playgroundDir = Directory('${_appDocDir.path}/playground');
    if (playgroundDir.existsSync()) {
      await playgroundDir.delete(recursive: true);
    }
    playgroundDir.createSync(recursive: true);
    File puzzleFile = File('${_appDocDir.path}/puzzles.zip');
    await _unArchivePuzzleFile(puzzleFile, rootBundle);
  }

  Future<bool> includePuzzleFiles(List<String> puzzleFiles) async {
    for (var puzzleFile in puzzleFiles) {
      final file = File('${_appDocDir.absolute.path}/puzzles/$puzzleFile');
      final playgroundFile = File('${playgroundDir.absolute.path}/$puzzleFile');
      if (!file.existsSync()) {
        return Future.error(puzzleFile);
      }
      if (playgroundFile.existsSync()) {
        await playgroundFile.delete();
      }
      playgroundFile.writeAsBytesSync(file.readAsBytesSync());
    }
    return true;
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
      if (file.name != ("puzzles/")) {
        _includeFilesNames.add(file.name.replaceAll("puzzles/", ""));
      }
    }
    puzzleFile.deleteSync();
  }
}
