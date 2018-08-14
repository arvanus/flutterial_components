import 'dart:ui';

import 'package:flutter/material.dart';

const materialColorsNames = const <String>[
  "red",
  "pink",
  "purple",
  "deepPurple",
  "indigo",
  "blue",
  "lightBlue",
  "cyan",
  "teal",
  "green",
  "lightGreen",
  "lime",
  "yellow",
  "amber",
  "orange",
  "deepOrange",
  "brown",
  "blueGrey",
  "White",
  "Black",
  "Grey"
];

class NamedColor {
  final Color color;
  final String name;

  NamedColor(this.color, this.name);
}

List<NamedColor> colors_names() {
  final colors = Colors.primaries.map((c) => c).toList();
  //colors.addAll([Colors.white, Colors.black, Colors.grey, ]);

  return colors.fold([], (cumul, current) {
    cumul.add(new NamedColor(current, materialColorsNames[cumul.length]));
    return cumul;
  });
}

bool isDark(Color c) => (c.red + c.green + c.blue) / 3 >= 146;