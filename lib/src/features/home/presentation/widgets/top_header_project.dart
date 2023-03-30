import 'package:chialisp_playground/src/features/editor/providers/projects_handler_provider.dart';
import 'package:chialisp_playground/src/features/home/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'hovered_icon_button.dart';

class TopHeaderProject extends StatefulWidget {
  final ProjectData project;
  final bool isActive;
  final Function(ProjectData) onTap;
  final Function(ProjectData) onClose;
  final bool modified;
  const TopHeaderProject({
    super.key,
    required this.project,
    required this.isActive,
    required this.onTap,
    required this.onClose,
    required this.modified,
  });

  @override
  State<TopHeaderProject> createState() => _TopHeaderProjectState();
}

class _TopHeaderProjectState extends State<TopHeaderProject> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    Color backColor = !widget.isActive
        ? (_hovered
            ? Colors.black.withOpacity(0.2)
            : Colors.green.withOpacity(0.06))
        : Colors.black38;
    Color foregroundColor =
        !widget.isActive ? Colors.white.withOpacity(0.8) : Colors.white;
    final isSaved = ProjectsHandlerProvider.of(context).isSaved(widget.project);
    if (!isSaved) {
      foregroundColor = Colors.orange;
    }
    return SizedBox(
      width: 180,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: () {
            widget.onTap(widget.project);
          },
          onHover: (value) {
            setState(() {
              _hovered = value;
            });
          },
          child: GestureDetector(
            onSecondaryTap: () {
              _showMenu(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: backColor,
                border: Border(
                    right: BorderSide(
                        color: Colors.black.withOpacity(0.2), width: 1)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              height: 40,
              child: Row(children: [
                icon(context),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    widget.project.fileName,
                    style: TextStyle(
                      fontSize:
                          ThemeProvider.of(context).topProjectsListFontSize,
                      color: foregroundColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                HoveredIconButton(
                  onPressed: () {
                    widget.onClose(widget.project);
                  },
                  size: 15,
                  icon: Icons.close,
                  color: foregroundColor,
                  hoverColor: ThemeProvider.of(context).hoverColor,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget icon(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/chialisp_dark.svg',
      width: 20,
    );
  }

  void _showMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    const padding = EdgeInsets.symmetric(horizontal: 15, vertical: 2.5);
    const height = 30.0;
    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 0,
          padding: padding,
          height: height,
          child: const Text(
            'Close',
            style: TextStyle(fontSize: 14),
          ),
          onTap: () => widget.onClose(widget.project),
        ),
        PopupMenuItem(
          value: 1,
          padding: padding,
          height: height,
          child: const Text(
            'Close all',
            style: TextStyle(fontSize: 14),
          ),
          onTap: () => ProjectsHandlerProvider.of(context, listen: false)
              .closeAllProjects(),
        ),
        PopupMenuItem(
          value: 2,
          padding: padding,
          height: height,
          child: const Text(
            'Close all but this',
            style: TextStyle(fontSize: 14),
          ),
          onTap: () => ProjectsHandlerProvider.of(context, listen: false)
              .closeAllProjects(keepProject: widget.project),
        ),
        PopupMenuItem(
          value: 2,
          padding: padding,
          height: height,
          child: const Text(
            'Close all right',
            style: TextStyle(fontSize: 14),
          ),
          onTap: () => ProjectsHandlerProvider.of(context, listen: false)
              .closeAllRighProjects(widget.project),
        ),
      ],
    );
  }
}
