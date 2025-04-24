import 'package:flutter/material.dart'; // For the Color class
import 'package:flutter_test/flutter_test.dart';
import 'package:yarn_inventory_manager/model/yarn.dart';
import 'package:yarn_inventory_manager/model/yarn_inventory.dart';

void main() {
  test('Add a valid yarn with swatch color to inventory', () {
    final inventory = YarnInventory();
    final yarn = Yarn(
      name: 'Cozy Wool',
      brand: 'WoolCo',
      color: 'Red',
      swatchColor: Colors.red,
      fiber: 'Wool',
      quantity: 5,
    );

    inventory.addYarn(yarn);
    expect(inventory.totalYarns, 1);
    expect(inventory.getAllYarns().first.swatchColor, Colors.red);
  });

  test('Throw error when adding invalid yarn with swatch color', () {
    final inventory = YarnInventory();
    final yarn = Yarn(
      name: '',
      brand: '',
      color: '',
      swatchColor: Colors.transparent, // Default Color
      fiber: '',
      quantity: 0,
    );

    expect(() => inventory.addYarn(yarn), throwsArgumentError);
  });

  test('Remove a yarn from inventory by name', () {
    final inventory = YarnInventory();
    final yarn = Yarn(
      name: 'Soft Cotton',
      brand: 'CottonCo',
      color: 'White',
      swatchColor: Colors.white,
      fiber: 'Cotton',
      quantity: 3,
    );

    inventory.addYarn(yarn);
    inventory.removeYarn('Soft Cotton');
    expect(inventory.totalYarns, 0);
  });

  test('Throw error when trying to remove yarn not in inventory', () {
    final inventory = YarnInventory();

    expect(() => inventory.removeYarn('NotHere'), throwsArgumentError);
  });

  test('Throw error when getting all yarns from empty inventory', () {
    final inventory = YarnInventory();

    expect(() => inventory.getAllYarns(), throwsStateError);
  });

  test('Sort yarns by name', () {
    final inventory = YarnInventory();
    inventory.addYarn(
      Yarn(
        name: 'Zebra',
        brand: 'ZCo',
        color: 'Black',
        swatchColor: Colors.black,
        fiber: 'Wool',
        quantity: 5,
      ),
    );
    inventory.addYarn(
      Yarn(
        name: 'Alpaca',
        brand: 'ACo',
        color: 'Brown',
        swatchColor: Colors.brown,
        fiber: 'Alpaca',
        quantity: 3,
      ),
    );
    inventory.sortYarnsByName();

    expect(inventory.getAllYarns().first.name, 'Alpaca');
  });

  test('Sorts yarns by fiber', () {
    final inventory = YarnInventory();
    inventory.addYarn(
      Yarn(
        name: 'Super Soft Yarn',
        brand: 'YarnCo',
        fiber: 'Wool',
        color: 'Blue',
        swatchColor: Colors.blue,
        quantity: 5,
      ),
    );
    inventory.addYarn(
      Yarn(
        name: 'Cozy Yarn',
        brand: 'CozyCo',
        fiber: 'Acrylic',
        color: 'Red',
        swatchColor: Colors.red,
        quantity: 10,
      ),
    );
    inventory.addYarn(
      Yarn(
        name: 'Fuzzy Yarn',
        brand: 'FuzzyCo',
        fiber: 'Cashmere',
        color: 'Green',
        swatchColor: Colors.green,
        quantity: 3,
      ),
    );

    inventory.sortYarnsByFiber();

    final sortedYarns = inventory.getAllYarns();
    expect(sortedYarns[0].fiber, 'Acrylic');
    expect(sortedYarns[1].fiber, 'Cashmere');
    expect(sortedYarns[2].fiber, 'Wool');
  });
}
