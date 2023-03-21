// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import '../utils/dir_splitter.dart' as dirSplitter;

const _LAST_PROJECT = "last_project";

class ProjectData extends Equatable {
  final File file;
  final bool readOnly;
  final String id;
  String unSavedData;

  ProjectData(this.file, this.readOnly, this.id, {this.unSavedData = ''});

  @override
  List<Object?> get props => [file.path, id];

  String get fileName => dirSplitter.fileName(file.path);
}

class ProjectsHandlerProvider extends ChangeNotifier {
  late final SharedPreferences _sharedPreferencfes;
  late final Directory _appDocDir;
  Set<ProjectData> _projects = {};
  Set<ProjectData> get projects => _projects;
  ProjectData? _currentProject;
  ProjectData? get currentProject => _currentProject;

  Future<void> init(
      {required AssetBundle rootBundle, required Directory appDocDir}) async {
    _appDocDir = appDocDir;

    _sharedPreferencfes = await SharedPreferences.getInstance();
    await readLastProject();
  }

  void openProject(File file, bool readOnly) {
    final projectData = ProjectData(file, readOnly, _calculateId(file));
    if (!_projects.contains(projectData)) {
      _projects.add(projectData);
      _currentProject = projectData;
      _sharedPreferencfes.setString(_LAST_PROJECT, file.absolute.path);
      notifyListeners();
    } else {
      _currentProject = projectData;
      notifyListeners();
    }
  }

  String _calculateId(File file) {
    return file.path;
  }

  Future<void> readLastProject() async {
    final lastProject = _sharedPreferencfes.getString(_LAST_PROJECT);
    if (lastProject != null) {
      final file = File(lastProject);
      if (file.existsSync()) {
        openProject(file, false);
      }
    }
  }

  void closeProject(ProjectData projectData) {
    _projects.remove(projectData);
    if (_currentProject == projectData) {
      if (_projects.isNotEmpty) {
        _currentProject = _projects.first;
      } else {
        _currentProject = null;
      }
    }
    notifyListeners();
  }

  void closeAllProjects() {
    _projects = {};
    notifyListeners();
  }
}
