import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ApplicationConstants {
  static const String serverUrl = "https://b2b30b79288b.ngrok.io";

  static final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.purple,
    Colors.teal,
    Colors.lightGreen,
    Colors.tealAccent,
    Colors.deepOrangeAccent,
  ];

  static Color getRandomColor() {
    Random random = new Random();
    return colors[random.nextInt(colors.length)];
  }

  static Map<String, Widget> category2image = {
    'Alimenti': Image.asset('assets/images/category_eat.png'),
    'Utilita': Image.asset('assets/images/category_utility.png'),
    'Bevande': Image.asset('assets/images/category_drink.png'),
    'Casa': Icon(
      Icons.home,
      color: Colors.black,
      size: 40,
    ),
    'Benessere': Image.asset('assets/images/category_healthy.png')
  };
}
