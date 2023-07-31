import 'dart:io';

import 'package:chialisp_playground/src/features/home/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../editor/utils/dir_splitter.dart';
import '../dialogs/question_dialog.dart';

typedef GetRenderBox = RenderBox Function();

class ProjectItem extends StatelessWidget {
  final File file;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  final GetRenderBox getRenderBox;
  const ProjectItem({
    super.key,
    required this.file,
    required this.onTap,
    required this.getRenderBox,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final itemName = fileName(file.path);

    return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onSecondaryTapDown: (value) => _showProjecOptions(value, context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/chialisp_dark.svg',
                  width: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  itemName,
                  style: TextStyle(
                      fontSize: ThemeProvider.of(context).projecftListFontSize),
                ),
              ],
            ),
          ),
        ));
  }

  void _showProjecOptions(TapDownDetails details, BuildContext context) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    final tapPosition = getRenderBox().globalToLocal(details.globalPosition);

    final position = RelativeRect.fromRect(
      Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 30, 30),
      Rect.fromLTWH(
        0,
        0,
        overlay!.paintBounds.size.width,
        overlay.paintBounds.size.height,
      ),
    );

    final _ = await showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: "delete",
          child: const Text("Delete"),
          onTap: () {
            _deleteProject(context, position);
          },
        ),
        PopupMenuItem(
          value: "rename",
          child: const Text("Rename"),
          onTap: () {
            print("rename");
          },
        ),
      ],
    );
  }

  void _deleteProject(BuildContext context, RelativeRect position) {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      showQuestionDialog(
        context,
        "Do you want to delete this project?",
        position: position,
      ).then((value) {
        if (value) {
          onDelete();
        }
      });
    });
  }
}
