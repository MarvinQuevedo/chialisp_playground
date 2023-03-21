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
    return MouseRegion(
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
        child: Container(
          decoration: BoxDecoration(
            color: !widget.isActive
                ? (_hovered
                    ? Colors.black.withOpacity(0.2)
                    : Colors.green.withOpacity(0.06))
                : Colors.black38,
            border:
                Border(right: BorderSide(color: Colors.black.withOpacity(0.2), width: 1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          height: 40,
          child: Row(children: [
            icon(context),
            const SizedBox(width: 5),
            Text(
              widget.project.fileName,
              style: TextStyle(
                fontSize: ThemeProvider.of(context). topProjectsListFontSize,
                color: !widget.isActive
                    ? Colors.white.withOpacity(0.8)
                    : Colors.white,
              ),
            ),
            HoveredIconButton(
              onPressed: () {
                widget.onClose(widget.project);
              },
              size: 15,
              icon: Icons.close,
              hoverColor: ThemeProvider.of(context).hoverColor,
            ),
          ]),
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
}
