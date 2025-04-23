// Manages all yarns
// Allows adding, removing, accessing, and sorting yarns
// Includes error handling for improper input of yarn details

import 'package:yarn_inventory_manager/model/yarn.dart';

class YarnInventory {
  final List<Yarn> _yarns = [];

  // Adds a new yarn to the inventory
  void addYarn(Yarn yarn) {
    if (yarn.name.isEmpty ||
        yarn.brand.isEmpty ||
        yarn.color.isEmpty ||
        yarn.fiber.isEmpty ||
        yarn.quantity <= 0) {
      throw ArgumentError(
        'Yarn must have a valid name, brand, color, fiber, and quantity greater than zero.',
      );
    }
    _yarns.add(yarn);
  }

  // Removes a yarn from the inventory by its name
  void removeYarn(String name) {
    final yarnLength = _yarns.length;
    _yarns.removeWhere((yarn) => yarn.name == name);
    if (_yarns.length == yarnLength) {
      throw ArgumentError('$name is not in inventory.');
    }
  }

  // Returns a list of all yarns
  List<Yarn> getAllYarns() {
    if (_yarns.isEmpty) {
      throw StateError('No yarn in inventory.');
    }
    return _yarns;
  }

  // Returns total number of yarns in inventory
  int get totalYarns => _yarns.length;

  // Sort yarns by name
  void sortYarnsByName() {
    _yarns.sort((a, b) => a.name.compareTo(b.name));
  }

  // Sort yarns by quantity (ascending)
  void sortYarnsByQuantity() {
    _yarns.sort((a, b) => a.quantity.compareTo(b.quantity));
  }

  // Sort yarns by fiber alphabetically
  void sortYarnsByFiber() {
    _yarns.sort((a, b) => a.fiber.compareTo(b.fiber));
  }

  // Sort yarns by brand alphabetically
  void sortYarnsByBrand() {
    _yarns.sort((a, b) => a.brand.compareTo(b.brand));
  }
}
