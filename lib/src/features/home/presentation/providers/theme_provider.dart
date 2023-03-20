import 'package:flutter/material.dart';

import '../../../../styling.dart';

class ThemeProvider extends ChangeNotifier{
  Brightness _brightness = Brightness.dark;
  Brightness get brightness => _brightness;
  set brightness(Brightness value) {
    _brightness = value;
    notifyListeners();
  }
  Color get leftIconsColorDark => AppTheme.leftIconsColorDark;
  Color get leftElementsBackColorDark => AppTheme.leftElementsBackColorDark;
}