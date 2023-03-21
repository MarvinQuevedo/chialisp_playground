import 'package:chialisp_playground/src/features/home/presentation/providers/theme_provider.dart';
import 'package:chialisp_playground/src/features/home/presentation/widgets/top_header_project.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../editor/providers/projects_handler_provider.dart';

class DesktopEditorHeader extends StatelessWidget {
  const DesktopEditorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final proHandler = Provider.of<ProjectsHandlerProvider>(context);
    final openProjects = proHandler.projects.toList();
    final projectsItems = openProjects
        .map<Widget>((e) => TopHeaderProject(
            project: e,
            isActive: proHandler.currentProject == e,
            onTap: (value) => _openProject(context, value),
            onClose: (value) => _closeProject(context, value),
            modified: false))
        .toList();

   
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: ThemeProvider.of(context).leftIconsColorDark,
      ),
      child: Scrollbar( 
        child: SingleChildScrollView(
          primary: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: projectsItems),
        ),
      ),
    );
  }

  _openProject(BuildContext context, ProjectData value) {
    final proHandler =
        Provider.of<ProjectsHandlerProvider>(context, listen: false);
    proHandler.openProject(
      value.file,
      false,
    );
  }

  _closeProject(BuildContext context, ProjectData value) {
    final proHandler = Provider.of<ProjectsHandlerProvider>(
      context,
      listen: false,
    );
    proHandler.closeProject(
      value,
    );
  }
}
