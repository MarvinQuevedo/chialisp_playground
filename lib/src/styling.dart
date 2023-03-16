import 'package:flutter/material.dart';
 

class ThemeDartText {
  ThemeDartText._internal();
  static const Color darkText = const Color(0xffffffff);
  static const Color darkerText = const Color(0xFFBAC7CE);
  static const Color lightText = const Color(0x80e5f0f4);
  static const Color captionText = const Color(0xFFDDDDDD);
}

class ThemeLigthText {
  ThemeLigthText._internal();
  static final Color darkText = Color(0xff23262f);
  static const Color darkerText = Color(0xFF17262A);
  static final Color lightText = Color(0xff969aa0);
}

class ThemeComponentsDarkColor {
  ThemeComponentsDarkColor._internal();
  static final Color disabledColor = AppTheme.deactivatedText;
  static final Color disabledButtonColor = Color(0xFF727070);
  static final Color unselectedWidgetColor = AppTheme.nearlyWhite;
  static final Color toggleableActiveColor = AppTheme.secondaryLigth;
}

class ThemeComponentsLigthColor {
  ThemeComponentsLigthColor._internal();
  static final Color disabledColor = Color(0xFFB4B4B4);
  static final Color disabledButtonColor = Color(0xFF727070);
  static final Color unselectedWidgetColor = Color(0x4d06ffb2);

  static final Color toggleableActiveColor = AppTheme.secondaryLigth;
}

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF75D811);
  static const Color red = Color(0xFFEB5050);
  static const Color primaryVariant = Color(0xFF75D811);
  static const Color secondaryLigth = Color(0xFF75D811);
  static const Color secondaryDark = Color(0xFF75D811);

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF101018);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color deactivatedText = Color(0xFF080606);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);

  static final TextTheme textThemeDark = TextTheme(
    headline4: display1Ligth.copyWith(
      color: ThemeDartText.darkerText,
    ),
    button: button.copyWith(color: ThemeLigthText.darkerText),
    headline5: headline.copyWith(color: ThemeDartText.darkerText),
    headline6: title.copyWith(color: ThemeDartText.darkerText),
    subtitle2: subtitle.copyWith(color: ThemeDartText.darkText),
    bodyText1: body2.copyWith(color: ThemeDartText.darkText),
    bodyText2: body1.copyWith(color: ThemeDartText.darkText),
    caption: caption.copyWith(color: ThemeDartText.captionText),
  );

  static TextTheme textThemeLigth =
      TextTheme(
    button: button.copyWith(color: ThemeLigthText.darkerText),
    headline4: display1Ligth,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText1: body2,
    bodyText2: body1,
    caption: caption,
  );

  static const _family = "Roboto";

  static final TextStyle display1Ligth = TextStyle(
    // h4 -> display1

    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: ThemeLigthText.darkerText,
  );

  static final TextStyle headline =TextStyle(
    // h5 -> headline

    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: ThemeLigthText.darkerText,
  );

  static final TextStyle title = TextStyle(
    // h6 -> title

    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: ThemeLigthText.darkerText,
  );

  static final TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle

    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: ThemeLigthText.darkText,
  );

  static final TextStyle body2 = TextStyle(
    // body1 -> body2

    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: ThemeLigthText.darkText,
  );

  static final TextStyle body1 =TextStyle(
    // body2 -> body1

    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: ThemeLigthText.darkText,
  );

  static final TextStyle caption = TextStyle(
    // Caption -> caption

    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: ThemeLigthText.lightText,
  );
  static final TextStyle button = TextStyle(
    // Caption -> caption

    fontWeight: FontWeight.w400,
    fontSize: 20,
    letterSpacing: 0.2,
    color: ThemeLigthText.lightText,
  );
}
