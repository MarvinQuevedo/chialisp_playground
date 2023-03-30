import 'dart:ui';

import 'package:chialisp_playground/src/features/editor/providers/editor_actions_provider.dart';
import 'package:chialisp_playground/src/features/editor/providers/projects_handler_provider.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class DesktopActionsWidget extends StatelessWidget {
  const DesktopActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final projectHandler = ProjectsHandlerProvider.of(context);
    return Consumer<EditorActionsProvider>(builder: (context, actions, child) {
      final editor = actions.editorActionHelper;
      if (editor != null) {
        return SizedBox(
          height: 42,
          width: 160,
          child: Stack(
            children: [
              Container(
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
                    onPressed: () => editor.openRunPage(isDesktop: true),
                    icon: const Icon(Ionicons.play_circle_outline),
                    iconSize: 20,
                  ),
                ]),
              ),
              if (projectHandler.currentProject == null)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.45),
                  ),
                ),
             
            ],
          ),
        );
      }
      return Container();
    });
  }
}
