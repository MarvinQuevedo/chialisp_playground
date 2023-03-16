import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 

getSystemOverlayStyle(
  BuildContext context, {
  Color? topColor,
}) {
  const brightness = Brightness.dark;
  return SystemUiOverlayStyle(
      statusBarColor: topColor ??
          (brightness == Brightness.dark
              ? Color(0xFF333333)
              : Theme.of(context).scaffoldBackgroundColor),
      // systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      statusBarBrightness: brightness,
      statusBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark);
}
