import 'dart:js';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

void modeChange() {
  AdaptiveTheme.of(context as BuildContext).setTheme(
      light: ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: Colors.black,
  ));
  AdaptiveTheme.of(context as BuildContext).setTheme(
    light: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.yellow,
    ),
  );
}
          
          
          // ignore: dead_code
         
