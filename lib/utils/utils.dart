import 'dart:math';

import 'package:flutter/material.dart';

class Utils {
  static int random(max) {
    return Random().nextInt(max);
  }

  static Color get randomColor =>
      Color.fromRGBO(random(200), random(200), random(200), 1);
}
