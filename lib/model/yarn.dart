import 'package:flutter/material.dart';

class Yarn {
  String name = "";
  String brand = "";
  String fiber = "";
  String color = "";
  int quantity = 0;
  Color swatchColor;

  Yarn({
    this.name = "",
    this.brand = "",
    this.fiber = "",
    this.color = "",
    this.quantity = 0,
    this.swatchColor = Colors.blue,
  });
}
