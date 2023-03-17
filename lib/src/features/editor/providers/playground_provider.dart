// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _LAST_PROJECT = "last_project";

class PlaygroundProvider extends ChangeNotifier {
  late final Directory _appDocDir;
  late final Directory playgroundDir;
  List<File>? _projects;
  List<File>? get projects => _projects;
  File? _activeProject;
  File? get activeProject => _activeProject;

  String? _activeProjectCode;
  String? get activeProjectCode => _activeProjectCode;

  List<String> _includeFilesNames = [
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

  late final SharedPreferences _sharedPreferencfes;

  List<String> get includeFilesNames => _includeFilesNames;

  String get playgroundInclude => playgroundDir.absolute.path;

  String? get activeProjectName {
    if (_activeProject == null) {
      return null;
    }
    return _activeProject?.path.split("/").last;
  }

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
    await loadProjects();
    _sharedPreferencfes = await SharedPreferences.getInstance();
    await readLastProject();
  }

  Future<void> loadProjects() async {
    _projects = [];
    final projectsDir = Directory('${_appDocDir.absolute.path}/projects');
    if (!projectsDir.existsSync()) {
      projectsDir.createSync(recursive: true);
    }

    projectsDir.listSync().forEach((element) {
      if (element is File) {
        _projects?.add(element);
        _includeFilesNames.add(element.path.split("/").last);
      }
    });
    _includeFilesNames = _includeFilesNames.toSet().toList();
    notifyListeners();
  }

  Future<bool> includePuzzleFiles(List<String> puzzleFiles) async {
    List<String> notFounds = [];
    for (var puzzleFile in puzzleFiles) {
      final file = File('${_appDocDir.absolute.path}/puzzles/$puzzleFile');

      if (!file.existsSync()) {
        // return Future.error(puzzleFile);
        notFounds.add(puzzleFile);
        continue;
      }
      final playgroundFile = File('${playgroundDir.absolute.path}/$puzzleFile');
      if (playgroundFile.existsSync()) {
        await playgroundFile.delete();
      }
      playgroundFile.writeAsBytesSync(file.readAsBytesSync());
    }

    final projectsDir = Directory('${_appDocDir.absolute.path}/projects');
    for (final puzzleFile in notFounds) {
      final projectFile = File('${projectsDir.absolute.path}/$puzzleFile');
      if (!projectFile.existsSync()) {
        return Future.error(puzzleFile);
      }
      final playgroundFile = File('${playgroundDir.absolute.path}/$puzzleFile');
      if (playgroundFile.existsSync()) {
        await playgroundFile.delete();
      }
      playgroundFile.writeAsBytesSync(projectFile.readAsBytesSync());
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

  Future<void> readLastProject() async {
    final lastProject = _sharedPreferencfes.getString(_LAST_PROJECT);
    if (lastProject != null) {
      final file = File(lastProject);
      if (file.existsSync()) {
        await loadProject(file);
      }
    }
  }

  Future<String> loadProject(File file) async {
    final fileData = await file.readAsString();
    _activeProject = file;
    _activeProjectCode = fileData;
    _sharedPreferencfes.setString(_LAST_PROJECT, file.absolute.path);
    return fileData;
  }

  Future<String> loadProjectWithFilename(String fileName) async {
    final file = File('${_appDocDir.absolute.path}/projects/$fileName');
    return await loadProject(file);
  }

  Future<bool> saveProject(String fileName, String content) async {
    final file = File('${_appDocDir.absolute.path}/projects/$fileName');

    await file.writeAsString(content);
    await loadProjects();
    await loadProject(file);
    return true;
  }

  Future<File> genereSharedActiveProject(
      String code, List outputs, List<String> puzzleFiles) async {
    final file = _activeProject!;
    await file.writeAsString(code);
    await includePuzzleFiles(puzzleFiles);
    List<File> includeFiles = [];
    playgroundDir.listSync().forEach((element) {
      if (element is File) {
        includeFiles.add(element);
      }
    });
    final zipFile = File(
        '${_appDocDir.absolute.path}/projects/${file.path.split("/").last}.zip');
    if (zipFile.existsSync()) {
      await zipFile.delete();
    }
    final archive = ZipFileEncoder();
    archive.create(zipFile.absolute.path);
    for (final file in includeFiles) {
      final fileName = file.path.split("/").last;
      final includeFilename = "include/$fileName";
      await archive.addFile(file, includeFilename);
    }
    await archive.addFile(file);
    final outputStr = outputs.join("\n");
    final output = File('${playgroundDir.absolute.path}/output.txt');
    await output.writeAsString(outputStr);
    await archive.addFile(output);
    archive.close();
    await output.delete();

    return zipFile;
  }
}
