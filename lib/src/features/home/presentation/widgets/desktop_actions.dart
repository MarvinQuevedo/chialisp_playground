import 'package:chialisp_playground/src/features/editor/providers/editor_actions_provider.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class DesktopActionsWidget extends StatelessWidget {
  const DesktopActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditorActionsProvider>(builder: (context, actions, child) {
      final editor = actions.editorActionHelper;
      if (editor != null) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              onPressed: () => editor.undoCode(),
              icon: const Icon(Ionicons.arrow_undo),
              iconSize: 20,
            ),
            IconButton(
              onPressed: () => editor.redoCode(),
              icon: const Icon(Ionicons.arrow_redo),
              iconSize: 20,
            ),
            IconButton(
              onPressed: () => editor.saveFile(),
              icon: const Icon(Ionicons.save),
              iconSize: 20,
            ),
            IconButton(
              onPressed: () => editor.openRunPage(),
              icon: const Icon(Ionicons.play_circle_outline),
              iconSize: 20,
            ),
          ]),
        );
      }
      return Container();
    });
  }
}
