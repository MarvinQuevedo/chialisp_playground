 
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

monokaiSublimeThemeWithFont(String family){
  final values = monokaiSublimeTheme.values;
  final keys = monokaiSublimeTheme.keys;
  final newTheme = Map<String, TextStyle>.fromIterables(keys, values);
  newTheme.forEach((key, value) {
    newTheme[key] = value.copyWith(fontFamily: family);
  });
  return newTheme;
}