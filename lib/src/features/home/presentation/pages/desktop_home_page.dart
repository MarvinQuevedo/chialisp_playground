import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
import '../../../editor/presentation/pages/editor_page.dart';
import '../../../editor/providers/projects_handler.dart';

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectsHandler>(
      builder: (context, projectsHandler, child) {
        return EditorPage( 
          showAppBard: false,
          showBottomMenu: false,
          key: Key(
            "${projectsHandler.currentProject?.id}",

          ),
        );
      },
    );
  }
}