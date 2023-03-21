import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../editor/presentation/pages/editor_page.dart';
import '../../../editor/providers/projects_handler_provider.dart';
import '../widgets/desktop_drawer.dart';
import '../widgets/desktop_editor_header.dart';

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
 
  late final GlobalKey desktopEditorKey;
  @override
  void initState() {
    desktopEditorKey = GlobalKey(); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProjectsHandlerProvider>(
        builder: (context, projectsHandler, child) {
          final key = Key("${projectsHandler.currentProject?.id}");

          return Row(
            children: [
              const DesktopDrawer(),
              Expanded(
                child: SizedBox(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DesktopEditorHeader(
                        key: desktopEditorKey,
                      ),
                      if (projectsHandler.currentProject != null)
                        const Expanded(
                          child: EditorPage(
                            showAppBard: false,
                            showBottomMenu: false,
                            // key: _editorPageKey,
                          ),
                        ),
                      if (projectsHandler.currentProject == null)
                        const Expanded(
                          child: Center(
                            child: Text("No project opened"),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
