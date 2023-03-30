import 'dart:io';

import '../../../editor/providers/projects_handler_provider.dart';
import '../../../editor/utils/save_file_dialog.dart';
import 'hovered_icon_button.dart';
import 'package:ionicons/ionicons.dart';

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
 final  double _width = 200;
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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: SizedBox(
                      height: 35,
                      child: Center(
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "Projects",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            HoveredIconButton(
                              icon: Ionicons.reload,
                              onPressed: _reload,
                            ),
                            HoveredIconButton(
                              icon: Ionicons.add,
                              onPressed: () => _createNewFile(context),
                            ),
                          ],
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
    Provider.of<ProjectsHandlerProvider>(context, listen: false)
        .openProject(file, false);
  }

  void _loadProjectsList({bool forceLoading = false}) {
    Provider.of<ProjectsProvider>(context, listen: false).loadProjects(forceLoading: forceLoading);
  }

  _createNewFile(BuildContext context) {
    showSaveFileDialog(context, "", title: "Create new file").then((result) {
      if (result != null) {
        final proHandler =
            Provider.of<ProjectsHandlerProvider>(context, listen: false);
        proHandler.openProjectWithName(result, false);
      }
    });
  }

  _reload() {
    _loadProjectsList(forceLoading: true);
  }
}
