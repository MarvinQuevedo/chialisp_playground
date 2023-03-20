import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';

class ProjectData extends Equatable {
  final File file;
  final bool readOnly;
  final String id;

  const ProjectData(this.file, this.readOnly, this.id);

  @override
  List<Object?> get props => [file.path, id];
}

class ProjectsHandlerProvider extends ChangeNotifier {
  Set<ProjectData> _projects = {};
  Set<ProjectData> get projects => _projects;
  ProjectData? _currentProject;
  ProjectData? get currentProject => _currentProject;

  void openProject(File file, bool readOnly) {
    final projectData = ProjectData(file, readOnly, _calculateId(file));
    if (!_projects.contains(projectData)) {
      _projects.add(projectData);
      _currentProject = projectData;
      notifyListeners();
    } else {
      _currentProject = projectData;
    }
  }

  String _calculateId(File file) {
    return file.path;
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
