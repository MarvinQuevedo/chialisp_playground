// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'dart:developer' as developer;
import 'package:archive/archive_io.dart';
import 'package:chialisp_playground/src/features/editor/providers/projects_handler_provider.dart';
import 'package:chialisp_playground/src/features/editor/utils/default_clsp_project.dart';
import 'package:chialisp_playground/src/features/editor/utils/dir_splitter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

import '../data/temp_repository.dart';

// ignore: non_constant_identifier_names
final _DS = dirSplitter;

class PlaygroundProvider extends ChangeNotifier {
  late final Directory _appDocDir;
  late final Directory playgroundDir;
  final CodeController _controller;

  PlaygroundProvider(this._controller);

 

  File? _activeProject;
  File? get activeProject => _activeProject;
 

  final _saved = ValueNotifier(false);
  bool get saved => _saved.value;
  ValueNotifier get savedNotifier => _saved;

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
  List<String> get includeFilesNames => _includeFilesNames;

  String get playgroundInclude => playgroundDir.absolute.path;

  String? get activeProjectName {
    if (_activeProject == null) {
      return null;
    }
    return _activeProject?.path.split(_DS).last;
  }

  void updateProjectsFilesNames(List<String> projectsFilesNames) {
    _includeFilesNames.addAll(projectsFilesNames);
    _includeFilesNames = _includeFilesNames.toSet().toList();
    _controller.autocompleter.setCustomWords(_includeFilesNames);
    notifyListeners();
  }

  Future<void> init({
    required AssetBundle rootBundle,
    required List<String> puzzlesFilesNames,
    required List<String> projectsFilesNames,
    required Directory appDocDir,
    required File? file,
  }) async {
    _appDocDir = appDocDir;

    playgroundDir = Directory('${_appDocDir.path}${_DS}playground');
    if (playgroundDir.existsSync()) {
      await playgroundDir.delete(recursive: true);
    }
    playgroundDir.createSync(recursive: true);

    _includeFilesNames.addAll(puzzlesFilesNames);
    _includeFilesNames.addAll(projectsFilesNames);
    _includeFilesNames = _includeFilesNames.toSet().toList();

    await loadProject(file);
  }

  Future<bool> includePuzzleFiles(List<String> puzzleFiles) async {
    List<String> notFounds = [];
    for (var puzzleFile in puzzleFiles) {
      final file =
          File('${_appDocDir.absolute.path}${_DS}puzzles$_DS$puzzleFile');

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

    final projectsDir = Directory('${_appDocDir.absolute.path}${_DS}projects');
    for (final puzzleFile in notFounds) {
      final projectFile = File('${projectsDir.absolute.path}$_DS$puzzleFile');
      if (!projectFile.existsSync()) {
        return Future.error(puzzleFile);
      }
      final playgroundFile =
          File('${playgroundDir.absolute.path}$_DS$puzzleFile');
      if (playgroundFile.existsSync()) {
        await playgroundFile.delete();
      }
      playgroundFile.writeAsBytesSync(projectFile.readAsBytesSync());
    }

    return true;
  }

  Future<String> loadProject(File? file) async {
    if (file == null) {
      _activeProject = null;
      _activeProjectCode = null;
      _controller.text = defaultClspProject;
      return defaultClspProject;
    }
    _activeProject = file;
    final tempData = TempRepository.instance.get(activeProjectName ?? "...");
    if (tempData != null) {
      _controller.text = tempData;
      _activeProjectCode = tempData;
      developer.log("loadProject: $tempData", name: "PlaygroundProvider");
      _saved.value = false;
      return tempData;
    }

    final fileData = await file.readAsString();

    _activeProjectCode = fileData;

    _controller.text = fileData;
    _saved.value = true;
    return fileData;
  }

  Future<String> loadProjectWithFilename(String fileName) async {
    final file = File('${_appDocDir.absolute.path}${_DS}projects$_DS$fileName');
    return await loadProject(file);
  }

  Future<bool> saveProject(String fileName, String content) async {
    final file = File('${_appDocDir.absolute.path}${_DS}projects$_DS$fileName');

    await file.writeAsString(content);

    await loadProject(file);
    _saved.value = false;
    TempRepository.instance.remove(activeProject?.absolute.path??"....");
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
        '${_appDocDir.absolute.path}${_DS}projects$_DS${file.path.split(_DS).last}.zip');
    if (zipFile.existsSync()) {
      await zipFile.delete();
    }
    final archive = ZipFileEncoder();
    archive.create(zipFile.absolute.path);
    for (final file in includeFiles) {
      final fileName = file.path.split(_DS).last;
      final includeFilename = "include$_DS$fileName";
      await archive.addFile(file, includeFilename);
    }
    await archive.addFile(file);
    final outputStr = outputs.join("\n");
    final output = File('${playgroundDir.absolute.path}${_DS}output.txt');
    await output.writeAsString(outputStr);
    await archive.addFile(output);
    archive.close();
    await output.delete();

    return zipFile;
  }

  Directory get tempDir {
    final tempFolder = Directory('${_appDocDir.absolute.path}${_DS}temp');
    if (!tempFolder.existsSync()) {
      tempFolder.createSync(recursive: true);
    }
    return tempFolder;
  }

  void updatePuzzlesNames(List<String> puzzlesFilesNames) {
    updateProjectsFilesNames(puzzlesFilesNames);
  }

  void removeTempFile(ProjectData? activeProject) {
     TempRepository.instance.remove(activeProject?.id??"");
  }
}
