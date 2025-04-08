import 'package:flutter_test/flutter_test.dart';
import 'package:yarn_inventory_manager/model/yarn.dart';

void main() {
  test('Sort by name', () {
    // create some yarn
    List<Yarn> yarnList = [
      Yarn(
        name: 'Cotton',
        brand: 'Brand A',
        fiber: 'Cotton',
        color: 'Red',
        quantity: 10,
      ),
      Yarn(
        name: 'Wool',
        brand: 'Brand B',
        fiber: 'Wool',
        color: 'Blue',
        quantity: 5,
      ),
      Yarn(
        name: 'Silk',
        brand: 'Brand C',
        fiber: 'Silk',
        color: 'Green',
        quantity: 8,
      ),
    ];

    // sort yarn list by name
    yarnList.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    // verify yarn list is sorted alphabetically by name
    expect(yarnList[0].name, 'Cotton');
    expect(yarnList[1].name, 'Silk');
    expect(yarnList[2].name, 'Wool');
  });

  test('Sort by quantity', () {
    // create some yarn with different quantities
    List<Yarn> yarnList = [
      Yarn(
        name: 'Cotton',
        brand: 'Brand A',
        fiber: 'Cotton',
        color: 'Red',
        quantity: 10,
      ),
      Yarn(
        name: 'Wool',
        brand: 'Brand B',
        fiber: 'Wool',
        color: 'Blue',
        quantity: 5,
      ),
      Yarn(
        name: 'Silk',
        brand: 'Brand C',
        fiber: 'Silk',
        color: 'Green',
        quantity: 8,
      ),
    ];

    // sort yarn list by quantity (ascending)
    yarnList.sort((a, b) => a.quantity.compareTo(b.quantity));

    // verify yarn list is sorted by quantity
    expect(yarnList[0].quantity, 5);
    expect(yarnList[1].quantity, 8);
    expect(yarnList[2].quantity, 10);
  });
}
