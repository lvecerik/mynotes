import 'package:flutter/material.dart';

const backgroundGradient1 = Color.fromRGBO(255, 147, 15, 1);
const backgroundGradient2 = Color.fromRGBO(255, 249, 91, 1);

const buttonGradient1 = Color.fromARGB(237, 0, 0, 1);
const buttonGradient2 = Color.fromARGB(185, 0, 0, 1);

const emphasisColor = Color.fromRGBO(255, 213, 46, 1);
const appleGrey = Color.fromRGBO(229, 229, 229, 1);
const appleWhite = Color.fromRGBO(249, 249, 249, 1);
const darkYellow = Color.fromRGBO(233, 179, 63, 1);

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
