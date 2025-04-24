// YarnInventory.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
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
    saveYarns(); // Save to storage whenever a yarn is added
  }

  // Removes a yarn from the inventory by its name
  void removeYarn(String name) {
    final yarnLength = _yarns.length;
    _yarns.removeWhere((yarn) => yarn.name == name);
    if (_yarns.length == yarnLength) {
      throw ArgumentError('$name is not in inventory.');
    }
    saveYarns(); // Save to storage after removing a yarn
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
    saveYarns(); // Save to storage after sorting
  }

  // Sort yarns by quantity (ascending)
  void sortYarnsByQuantity() {
    _yarns.sort((a, b) => a.quantity.compareTo(b.quantity));
    saveYarns(); // Save to storage after sorting
  }

  // Sort yarns by fiber alphabetically
  void sortYarnsByFiber() {
    _yarns.sort((a, b) => a.fiber.compareTo(b.fiber));
    saveYarns(); // Save to storage after sorting
  }

  // Sort yarns by brand alphabetically
  void sortYarnsByBrand() {
    _yarns.sort((a, b) => a.brand.compareTo(b.brand));
    saveYarns(); // Save to storage after sorting
  }

  // Save yarns to shared preferences
  Future<void> saveYarns() async {
    final prefs = await SharedPreferences.getInstance();
    final yarnsJson = jsonEncode(_yarns.map((yarn) => yarn.toJson()).toList());
    await prefs.setString('yarns', yarnsJson);
  }

  // Load yarns from shared preferences
  Future<void> loadYarns() async {
    final prefs = await SharedPreferences.getInstance();
    final String? yarnsJson = prefs.getString('yarns');

    if (yarnsJson != null) {
      final List<dynamic> yarnList = jsonDecode(yarnsJson);
      _yarns.clear(); // Clear the current list before loading new data
      _yarns.addAll(yarnList.map((yarn) => Yarn.fromJson(yarn)).toList());
    }
  }
}
