// ignore_for_file: must_be_immutable, constant_identifier_names, non_constant_identifier_names

import 'dart:io';
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import '../data/temp_repository.dart';
// ignore: library_prefixes
import '../utils/dir_splitter.dart' as dirSplitter;

const _LAST_PROJECT = "last_project";
final _DS = dirSplitter.dirSplitter;

class ProjectData extends Equatable {
  final File file;
  final bool readOnly;
  final String id;
  final bool saved;

  const ProjectData(this.file, this.readOnly, this.id, {this.saved = false});

  @override
  List<Object?> get props => [file.path, id];

  String get fileName => dirSplitter.fileName(file.path);

  ProjectData copyWith({bool? saved}) {
    return ProjectData(file, readOnly, id, saved: saved ?? this.saved);
  }
}

class ProjectsHandlerProvider extends ChangeNotifier {
  late final SharedPreferences _sharedPreferencfes;
  late final Directory _appDocDir;
  Map<int, ProjectData> _projects = {};
  Set<ProjectData> get projects => _projects.values.toSet();
  ProjectData? _currentProject;
  ProjectData? get currentProject => _currentProject;

  Future<void> init(
      {required AssetBundle rootBundle, required Directory appDocDir}) async {
    _appDocDir = appDocDir;

    _sharedPreferencfes = await SharedPreferences.getInstance();
    await readLastProject();
    await TempRepository.instance.loadTempFile();
  }

  void openProject(File file, bool readOnly) {
    final projectData = ProjectData(file, readOnly, _calculateId(file));
    if (!projects.contains(projectData)) {
      _projects[projects.length] = projectData;
      _currentProject = projectData;
      _sharedPreferencfes.setString(_LAST_PROJECT, file.absolute.path);
      notifyListeners();
    } else {
      _currentProject = projectData;
      notifyListeners();
    }
  }

  void openProjectWithName(String fileName, bool readOnly) {
    final file = File('${_appDocDir.absolute.path}${_DS}projects$_DS$fileName');
    return openProject(file, readOnly);
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

  int? getProjectIndex(ProjectData projectData) {
    for (final key in _projects.keys) {
      if (_projects[key] == projectData) {
        return key;
      }
    }
    return null;
  }

  void closeProject(ProjectData projectData) {
    final proIndex = getProjectIndex(projectData);
    _projects.remove(proIndex);
    if (_currentProject == projectData) {
      if (_projects.isNotEmpty) {
        _currentProject = _projects.values.last;
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

  Future<bool> saveProject(String fileName, String content) async {
    final file = File('${_appDocDir.absolute.path}${_DS}projects$_DS$fileName');
    await file.writeAsString(content);

    return true;
  }

  void onChangeText(
      {required ProjectData projectData,
      required String value,
      bool? saved}) async {
    TempRepository.instance.set(projectData.id, value);
    if (saved != null && saved == true) {
      TempRepository.instance.remove(projectData.id);
    }
    updateValue(projectData.copyWith(saved: saved ?? true));
    developer.log("onChangeText: ${value.length}");
  }

  void updateValue(ProjectData value) {
    final proIndex = getProjectIndex(value);
    if (proIndex != null) {
      _projects[proIndex] = value;
      notifyListeners();
    }
  }

  static ProjectsHandlerProvider of(BuildContext context,
      {bool listen = false}) {
    return Provider.of<ProjectsHandlerProvider>(context, listen: listen);
  }

  bool isSaved(ProjectData project) {
    final proIndex = getProjectIndex(project);
    if (proIndex != null) {
      return TempRepository.instance.get(project.id) == null;
    }
    return false;
  }

  void deleteTempFile(ProjectData value) {
    TempRepository.instance.remove(value.id);
      notifyListeners();
  }
}
