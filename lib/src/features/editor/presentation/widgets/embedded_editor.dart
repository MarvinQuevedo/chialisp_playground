import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

import 'package:highlight/languages/lisp.dart';

import '../../models/run_type.dart';

class EmbeddedEditor extends StatefulWidget {
  final String? orignalCode;
  final RunType runType;
  final double height;
  final double width;
  final CodeController? controller;
  const EmbeddedEditor({
    super.key,
    this.orignalCode = '',
    required this.runType,
    this.controller,
    this.height = 300,
    this.width = double.infinity,
  });

  @override
  State<EmbeddedEditor> createState() => _EmbeddedEditorState();
}

class _EmbeddedEditorState extends State<EmbeddedEditor> {
  late final CodeController _controller;
  @override
  void initState() {
    _controller = widget.controller ??
        CodeController(
          text: widget.orignalCode, // Initial code
          language: lisp,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CodeTheme(
      data: CodeThemeData(styles: monokaiSublimeTheme),
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: CodeField(
          controller: _controller, 
        ),
      ),
    );
  }
}
