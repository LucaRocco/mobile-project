import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ApplicationConstants {
  static const String serverUrl = "https://14a60eb0e069.ngrok.io";

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
    'alimenti': Image.asset('assets/images/category_eat.png'),
    'utilita': Image.asset('assets/images/category_utility.png'),
    'bevande': Image.asset('assets/images/category_drink.png'),
    'casa': Icon(
      Icons.home,
      color: Colors.black,
      size: 40,
    ),
    'benessere': Image.asset('assets/images/category_healthy.png')
  };

  static Map<String, Color> category2color = {
    'alimenti': Colors.red,
    'utilita': Colors.blue,
    'bevande': Colors.yellow,
    'casa': Colors.tealAccent,
    'benessere': Colors.purple
  };
}
