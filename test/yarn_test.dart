import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yarn_inventory_manager/model/yarn.dart';

void main() {
  test('Yarn object is created with correct values', () {
    final yarn = Yarn(
      name: 'Super Soft Yarn',
      brand: 'YarnCo',
      fiber: 'Wool',
      color: 'Blue',
      swatchColor: Colors.blue,
      quantity: 5,
    );

    expect(yarn.name, 'Super Soft Yarn');
    expect(yarn.brand, 'YarnCo');
    expect(yarn.fiber, 'Wool');
    expect(yarn.color, 'Blue');
    expect(yarn.quantity, 5);
  });
}
