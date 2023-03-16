import 'package:chialisp_playground/src/styling.dart';
import 'package:chialisp_playground/src/system_overlay_style.dart';
import 'package:flutter/material.dart';

ThemeData appTheme(BuildContext context, Brightness brightness) {
  switch (brightness) {
    case Brightness.dark:
      return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppTheme.nearlyBlack,
          hintColor: ThemeLigthText.lightText,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.secondaryDark,
              disabledForegroundColor:
                  ThemeComponentsDarkColor.disabledColor.withOpacity(0.38),
              textStyle:
                  TextStyle(color: AppTheme.textThemeLigth.labelLarge!.color),
            ),
          ),
          appBarTheme: AppBarTheme(
            color: AppTheme.nearlyBlack,
            elevation: 0,
            systemOverlayStyle: getSystemOverlayStyle(context),
            toolbarTextStyle: const TextStyle(
              color: ThemeDartText.darkText,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 0.8888888888888888,
            ),
          ),
          disabledColor: ThemeComponentsDarkColor.disabledButtonColor,
          unselectedWidgetColor: ThemeComponentsDarkColor.unselectedWidgetColor,
          textTheme: AppTheme.textThemeDark,
          switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return ThemeComponentsDarkColor.toggleableActiveColor;
              }
              return null;
            }),
            trackColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return ThemeComponentsDarkColor.toggleableActiveColor;
              }
              return null;
            }),
          ),
          radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return ThemeComponentsDarkColor.toggleableActiveColor;
              }
              return null;
            }),
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return ThemeComponentsDarkColor.toggleableActiveColor;
              }
              return null;
            }),
          ),
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.primary,
            primaryContainer: AppTheme.primaryVariant,
            secondary: AppTheme.secondaryDark,
            surface: AppTheme.notWhite,
            background: AppTheme.notWhite,
            brightness: Brightness.dark,
          ).copyWith(error: AppTheme.red));
    case Brightness.light:
      return ThemeData.light().copyWith(
          scaffoldBackgroundColor: AppTheme.white,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.secondaryLigth,
              disabledForegroundColor:
                  ThemeComponentsLigthColor.disabledColor.withOpacity(0.38),
            ),
          ),
          disabledColor: ThemeComponentsLigthColor.disabledButtonColor,
          unselectedWidgetColor:
              ThemeComponentsLigthColor.unselectedWidgetColor,
          textTheme: AppTheme.textThemeLigth,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            elevation: 0,
            systemOverlayStyle: getSystemOverlayStyle(context),
            toolbarTextStyle: TextStyle(
              color: ThemeLigthText.darkText,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 0.8888888888888888,
            ),
          ),
          brightness: brightness,
          switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return ThemeComponentsLigthColor.toggleableActiveColor;
              }
              return null;
            }),
            trackColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return ThemeComponentsLigthColor.toggleableActiveColor;
              }
              return null;
            }),
          ),
          radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return ThemeComponentsLigthColor.toggleableActiveColor;
              }
              return null;
            }),
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return null;
              }
              if (states.contains(MaterialState.selected)) {
                return ThemeComponentsLigthColor.toggleableActiveColor;
              }
              return null;
            }),
          ),
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.primary,
            primaryContainer: AppTheme.primaryVariant,
            secondary: AppTheme.secondaryLigth,
            surface: AppTheme.notWhite,
            background: AppTheme.notWhite,
            brightness: Brightness.dark,
          ).copyWith(error: AppTheme.red));
  }
}

VisualDensity getDensity() {
  return VisualDensity.comfortable;
}

const bodyPadding = EdgeInsets.all(15);
