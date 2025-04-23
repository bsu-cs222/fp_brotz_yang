// represents a single skein in the user's inventory

class Yarn {
  final String _name;
  final String _color;
  final String _fiber;
  final int _quantity;
  final String _brand;

  Yarn({
    required String name,
    required String color,
    required String fiber,
    required int quantity,
    required String brand,
  }) : _name = name,
       _color = color,
       _fiber = fiber,
       _quantity = quantity,
       _brand = brand;

  String get name => _name;
  String get color => _color;
  String get fiber => _fiber;
  int get quantity => _quantity;
  String get brand => _brand;
}
