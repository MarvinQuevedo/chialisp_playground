import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../styling.dart';

class ThemeProvider extends ChangeNotifier {
  Brightness _brightness = Brightness.dark;
  Brightness get brightness => _brightness;

  double get projecftListFontSize => 13.0;
  double get topProjectsListFontSize => 12.0;


  set brightness(Brightness value) {
    _brightness = value;
    notifyListeners();
  }

  Color get leftIconsColorDark => AppTheme.leftIconsColorDark;
  Color get leftElementsBackColorDark => AppTheme.leftElementsBackColorDark;
  Color get hoverColor => Colors.white.withOpacity(0.3);
  static ThemeProvider of(BuildContext context) {
    return Provider.of<ThemeProvider>(context);
  }
}
