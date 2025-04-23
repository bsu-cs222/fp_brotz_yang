import 'package:flutter_test/flutter_test.dart';
import 'package:yarn_inventory_manager/model/yarn.dart';
import 'package:yarn_inventory_manager/model/yarn_inventory.dart';

void main() {
  test('Add a valid yarn to inventory', () {
    final inventory = YarnInventory();
    final yarn = Yarn(
      name: 'Cozy Wool',
      brand: 'WoolCo',
      color: 'Red',
      fiber: 'Wool',
      quantity: 5,
    );

    inventory.addYarn(yarn);
    expect(inventory.totalYarns, 1);
  });

  test('Throw error when adding invalid yarn', () {
    final inventory = YarnInventory();
    final yarn = Yarn(name: '', brand: '', color: '', fiber: '', quantity: 0);

    expect(() => inventory.addYarn(yarn), throwsArgumentError);
  });

  test('Remove a yarn from inventory by name', () {
    final inventory = YarnInventory();
    final yarn = Yarn(
      name: 'Soft Cotton',
      brand: 'CottonCo',
      color: 'White',
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
        fiber: 'Wool',
        quantity: 5,
      ),
    );
    inventory.addYarn(
      Yarn(
        name: 'Alpaca',
        brand: 'ACo',
        color: 'Brown',
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
        quantity: 5,
      ),
    );
    inventory.addYarn(
      Yarn(
        name: 'Cozy Yarn',
        brand: 'CozyCo',
        fiber: 'Acrylic',
        color: 'Red',
        quantity: 10,
      ),
    );
    inventory.addYarn(
      Yarn(
        name: 'Fuzzy Yarn',
        brand: 'FuzzyCo',
        fiber: 'Cashmere',
        color: 'Green',
        quantity: 3,
      ),
    );

    inventory.sortYarnsByFiber();

    final sortedYarns = inventory.getAllYarns();
    expect(sortedYarns[0].fiber, 'Acrylic');
    expect(sortedYarns[1].fiber, 'Cashmere');
    expect(sortedYarns[2].fiber, 'Wool');
  });

  test('Sorts yarns by quantity', () {
    final inventory = YarnInventory();
    inventory.addYarn(
      Yarn(
        name: 'Super Soft Yarn',
        brand: 'YarnCo',
        fiber: 'Wool',
        color: 'Blue',
        quantity: 5,
      ),
    );
    inventory.addYarn(
      Yarn(
        name: 'Cozy Yarn',
        brand: 'CozyCo',
        fiber: 'Acrylic',
        color: 'Red',
        quantity: 10,
      ),
    );
    inventory.addYarn(
      Yarn(
        name: 'Fuzzy Yarn',
        brand: 'FuzzyCo',
        fiber: 'Cashmere',
        color: 'Green',
        quantity: 3,
      ),
    );

    inventory.sortYarnsByQuantity();

    final sortedYarns = inventory.getAllYarns();
    expect(sortedYarns[0].quantity, 3);
    expect(sortedYarns[1].quantity, 5);
    expect(sortedYarns[2].quantity, 10);
  });

  test('Sorts yarns by brand', () {
    final inventory = YarnInventory();
    inventory.addYarn(
      Yarn(
        name: 'Super Soft Yarn',
        brand: 'YarnCo',
        fiber: 'Wool',
        color: 'Blue',
        quantity: 5,
      ),
    );
    inventory.addYarn(
      Yarn(
        name: 'Cozy Yarn',
        brand: 'CozyCo',
        fiber: 'Acrylic',
        color: 'Red',
        quantity: 10,
      ),
    );
    inventory.addYarn(
      Yarn(
        name: 'Fuzzy Yarn',
        brand: 'FuzzyCo',
        fiber: 'Cashmere',
        color: 'Green',
        quantity: 3,
      ),
    );

    inventory.sortYarnsByBrand();

    final sortedYarns = inventory.getAllYarns();
    expect(sortedYarns[0].brand, 'CozyCo');
    expect(sortedYarns[1].brand, 'FuzzyCo');
    expect(sortedYarns[2].brand, 'YarnCo');
  });
}
