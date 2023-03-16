import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../editor/models/run_type.dart';
import '../../../editor/presentation/pages/editor_page.dart';
import '../../../editor/providers/playground_provider.dart';
import '../../../editor/utils/default_clsp_project.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlaygroundProvider>(builder: (context, provider, child) {
      return EditorPage(
        orignalCode: provider.activeProjectCode ?? defaultCslpProject,
        runType: RunType.run,
      );
    });
  }
}
