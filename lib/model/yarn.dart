import 'package:flutter/material.dart';

class Yarn {
  String name;
  String brand;
  String fiber;
  String color;
  int quantity;
  Color swatchColor;

  Yarn({
    required this.name,
    required this.brand,
    required this.fiber,
    required this.color,
    required this.quantity,
    required this.swatchColor,
  });

  // From JSON constructor
  factory Yarn.fromJson(Map<String, dynamic> json) {
    return Yarn(
      name: json['name'],
      brand: json['brand'],
      fiber: json['fiber'],
      color: json['color'],
      quantity: json['quantity'],
      swatchColor: Color(json['swatchColor']),
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'fiber': fiber,
      'color': color,
      'quantity': quantity,
      'swatchColor': swatchColor.value,
    };
  }
}
