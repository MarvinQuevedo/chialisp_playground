import 'dart:io';

import 'package:chialisp_playground/src/features/editor/providers/projects_handler_provider.dart';

import '../../../editor/providers/projects_provider.dart';
import 'project_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class DesktopProjectsList extends StatefulWidget {
  const DesktopProjectsList({super.key});

  @override
  State<DesktopProjectsList> createState() => _DesktopProjectsListState();
}

class _DesktopProjectsListState extends State<DesktopProjectsList> {
  double _width = 200;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadProjectsList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themePro = Provider.of<ThemeProvider>(context);
    return ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 200,
        ),
        child: Container(
          width: _width,
          decoration: BoxDecoration(color: themePro.leftElementsBackColorDark),
          child: Consumer<ProjectsProvider>(
            builder: (context, projectsPro, child) {
              final projectsFiles = projectsPro.projects;
              if (projectsFiles == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10 ),
                    child: SizedBox(
                      height: 35,
                      child: Center(
                        child: Text(
                          "Projects",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  ListView.builder(
                    itemCount: projectsPro.projects!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final file = projectsFiles[index];

                      return ProjectItem(
                        file: file,
                        onTap: () => _openProject(context, file),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ));
  }

  _openProject(BuildContext context, File file) {
    Provider.of<ProjectsHandlerProvider>(context, listen: false).openProject(file, false);
  }

  void _loadProjectsList() {
    Provider.of<ProjectsProvider>(context, listen: false).loadProjects();
  }
}
