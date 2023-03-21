import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../utils/dir_splitter.dart';

// ignore: non_constant_identifier_names
final _DS = dirSplitter;

class ProjectsProvider extends ChangeNotifier {
  List<File>? _projects;
  List<File>? get projects => _projects;
  Directory? _appDocDir;

  List<String> get projectsFilesNames =>
      _projects?.map((e) => fileName(e.path)).toList() ?? [];

  set appDocDir(Directory? value) {
    _appDocDir = value;
    loadProjects();
  }

  Future<void> loadProjects({bool forceLoading = false}) async {
    _projects = forceLoading ? null : [];
    if (forceLoading) {
      notifyListeners();
      // Only for refresh the UI and the user can see the loading
      await Future.delayed(const Duration(milliseconds: 150));
      _projects = [];
    }

    final projectsDir = Directory('${_appDocDir!.absolute.path}${_DS}projects');
    if (!projectsDir.existsSync()) {
      projectsDir.createSync(recursive: true);
    }

    projectsDir.listSync().forEach((element) {
      if (element is File) {
        final fileName = element.path.split(_DS).last;
        final ext = fileName.split(".").last;
        if (ext == "zip") {
          element.delete();
          return;
        }
        _projects?.add(element);
      }
    });
    notifyListeners();
  }
}
