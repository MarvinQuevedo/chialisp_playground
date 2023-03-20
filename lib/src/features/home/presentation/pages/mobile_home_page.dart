import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
import '../../../editor/presentation/pages/editor_page.dart';
import '../../../editor/providers/projects_handler.dart';

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectsHandler>(
      builder: (context, projectsHandler, child) {
        return EditorPage(
          
          key: Key(
            "${projectsHandler.currentProject?.id}",
          ),
        );
      },
    );
  }
}
