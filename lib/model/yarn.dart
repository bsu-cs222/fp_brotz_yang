// represents a single skein in the user's inventory

class Yarn {
  final String _name;
  final String _color;
  final int _weight;
  final String _fiber;
  final int _quantity;
  final String _brand;

  Yarn({required name, color, weight, fiber, quantity, brand})
    : _name = name,
      _color = color,
      _weight = weight,
      _fiber = fiber,
      _quantity = quantity,
      _brand = brand;

  String get name => _name;
  String get color => _color;
  int get weight => _weight;
  String get fiber => _fiber;
  int get quantity => _quantity;
  String get brand => _brand;
}
