import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
import '../../../editor/presentation/pages/editor_page.dart';
import '../../../editor/providers/projects_handler_provider.dart';

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectsHandlerProvider>(
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
