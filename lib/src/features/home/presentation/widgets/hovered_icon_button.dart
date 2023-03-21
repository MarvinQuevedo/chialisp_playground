// ignore_for_file: implementation_imports

import 'package:chialisp_playground/src/features/home/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/events.dart';

class HoveredIconButton extends StatefulWidget {
  final IconData icon;
  final Function() onPressed;
  final bool enabled;
  final Color color;
  final Color? hoverColor;
  final double size;
  const HoveredIconButton(
      {super.key,
      required this.icon,
      required this.onPressed,
      this.enabled = true,
      this.color = Colors.white,
      this.size = 24,
      this.hoverColor});

  @override
  State<HoveredIconButton> createState() => _HoveredIconButtonState();
}

class _HoveredIconButtonState extends State<HoveredIconButton> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
          onTap: widget.enabled ? widget.onPressed : null,
          child: IconButton(
            iconSize:widget.size,
            icon: Icon(
              widget.icon,
              color: _hovering
                  ? (ThemeProvider.of(context).hoverColor)
                  : widget.color,
            ),
            onPressed: widget.enabled ? widget.onPressed : null,
          )),
    );
  }

  void _onEnter(PointerEnterEvent event) {
    setState(() {
      _hovering = true;
    });
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      _hovering = false;
    });
  }
}
