import 'package:flutter/material.dart';

class MeSnackbar extends SnackBar {
  const MeSnackbar({
    super.key,
    required super.content,
    Duration duration = const Duration(milliseconds: 2500),
    Color backgroundColor = const Color(0xff04395e),
  }) : super(duration: duration, backgroundColor: backgroundColor,);
}
