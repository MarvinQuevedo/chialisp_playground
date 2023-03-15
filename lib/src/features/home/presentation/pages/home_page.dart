import 'package:flutter/material.dart';

import '../../../editor/models/run_type.dart';
import '../../../editor/presentation/pages/editor_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const EditorPage(
      orignalCode: """
; ChiaTk ChiaLisp 
; Playground experiments

(mod (number)
    (defun square (number)
        (* number number)
    )

    (square number)
)""",
      runType: RunType.run,
    );
  }
}