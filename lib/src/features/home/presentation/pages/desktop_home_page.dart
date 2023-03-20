import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../editor/presentation/pages/editor_page.dart';
import '../../../editor/providers/projects_handler_provider.dart';
import '../widgets/desktop_drawer.dart';

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  late final GlobalKey<EditorPageState> _editorPageKey;
  @override
  void initState() {
    _editorPageKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProjectsHandlerProvider>(
        builder: (context, projectsHandler, child) {
          return Row(
            children: [
              const DesktopDrawer(),
              Expanded(
                child: SizedBox(
                  key: Key(
                    "${projectsHandler.currentProject?.id}",
                  ),
                  child: EditorPage(
                      showAppBard: false,
                      showBottomMenu: false,
                      key: _editorPageKey),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
