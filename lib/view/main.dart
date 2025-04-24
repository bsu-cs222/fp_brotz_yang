import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_echart/flutter_echart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yarn_inventory_manager/model/yarn.dart';

import 'input_row.dart';
import 'yarn_list.dart';

void main() {
  runApp(const YarnApp());
}

class YarnApp extends StatelessWidget {
  const YarnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yarn Inventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const MyHomePage(title: 'Yarn Inventory'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _fiberController = TextEditingController();
  final _colorController = TextEditingController();
  final _quantityController = TextEditingController();
  Color _pickerColor = Colors.blueAccent;

  List<Yarn> _items = [];
  List<Yarn> _displayItems = [];
  bool _isPieChartVisible = false;

  String _selectedSort = 'name';
  final List<String> _sortOptions = [
    'name',
    'brand',
    'color',
    'fiber',
    'quantity',
  ];
  bool _isDropdownVisible = false;

  @override
  void initState() {
    super.initState();
    _loadFromSP();
  }

  void _addItem() {
    String name = _nameController.text.trim();
    String brand = _brandController.text.trim();
    String fiber = _fiberController.text.trim();
    String color = _colorController.text.trim();
    String quantityStr = _quantityController.text.trim();

    if (name.isEmpty || brand.isEmpty || quantityStr.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
      return;
    }

    int quantity = int.tryParse(quantityStr) ?? 0;
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantity must be a positive number.')),
      );
      return;
    }

    Yarn data = Yarn(
      name: name,
      brand: brand,
      fiber: fiber,
      color: color,
      quantity: quantity,
      swatchColor: _pickerColor,
    );

    setState(() {
      _items.add(data);
      _displayItems = List.from(_items);
      _sortItems();
    });
    _saveToSP();
    _clearControllers();
  }

  void _clearControllers() {
    _nameController.clear();
    _brandController.clear();
    _fiberController.clear();
    _colorController.clear();
    _quantityController.clear();
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Pick a Color'),
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ColorPicker(
                  pickerColor: _pickerColor,
                  onColorChanged: (color) {
                    setState(() {
                      _pickerColor = color;
                    });
                  },
                  enableAlpha: false,
                  pickerAreaHeightPercent: 0.8,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }

  void _pieCharts() {
    setState(() => _isPieChartVisible = !_isPieChartVisible);
  }

  void _sortItems() {
    _displayItems.sort((a, b) {
      switch (_selectedSort) {
        case 'name':
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case 'brand':
          return a.brand.toLowerCase().compareTo(b.brand.toLowerCase());
        case 'color':
          return a.color.toLowerCase().compareTo(b.color.toLowerCase());
        case 'fiber':
          return a.fiber.toLowerCase().compareTo(b.fiber.toLowerCase());
        case 'quantity':
          return a.quantity.compareTo(b.quantity);
        default:
          return 0;
      }
    });
  }

  Future<void> _loadFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('yarnItems');
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        setState(() {
          _items = jsonList.map((json) => Yarn.fromJson(json)).toList();
          _displayItems = List.from(_items);
          _sortItems();
        });
      } catch (e) {
        throw ArgumentError('Error.');
      }
    }
  }

  Future<void> _saveToSP() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _items.map((item) => item.toJson()).toList();
    await prefs.setString('yarnItems', jsonEncode(jsonList));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_florist_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Text(widget.title),
              const SizedBox(width: 10),
              const Icon(Icons.local_florist_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            InputRowView(
              nameController: _nameController,
              brandController: _brandController,
              fiberController: _fiberController,
              colorController: _colorController,
              quantityController: _quantityController,
              onAdd: _addItem,
              onPieCharts: _pieCharts,
              onColorTap: _openColorPicker,
              pickedColor: _pickerColor,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isDropdownVisible = !_isDropdownVisible;
                });
              },
              child: const Text('Sort Yarn'),
            ),
            if (_isDropdownVisible)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButton<String>(
                  value: _selectedSort,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSort = value;
                        _sortItems();
                      });
                    }
                  },
                  items:
                      _sortOptions.map((option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(
                            'Sort by ${option[0].toUpperCase()}${option.substring(1)}',
                          ),
                        );
                      }).toList(),
                ),
              ),
            Visibility(
              visible: _isPieChartVisible && _displayItems.isNotEmpty,
              maintainState: true,
              child: Container(
                height: 300,
                color: Colors.white,
                child: _buildPieChartContainer(),
              ),
            ),
            Expanded(
              child: YarnListView(
                items: _displayItems,
                onRemove: (index) {
                  setState(() {
                    _displayItems.removeAt(index);
                    _saveToSP();
                    _sortItems();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartContainer() {
    if (_displayItems.isEmpty) return const SizedBox();

    final Map<String, dynamic> colorCounts = {};
    for (var item in _displayItems) {
      String colorHex = item.swatchColor
          .toARGB32()
          .toRadixString(16)
          .padLeft(8, '0');
      if (colorCounts.containsKey(colorHex)) {
        colorCounts[colorHex]['count'] += item.quantity;
      } else {
        colorCounts[colorHex] = {
          'count': item.quantity,
          'name': item.color.isNotEmpty ? item.color : 'Unnamed',
          'color': item.swatchColor,
        };
      }
    }

    List<EChartPieBean> dataList =
        colorCounts.values.map((data) {
          return EChartPieBean(
            title: data['name'],
            number: data['count'],
            color: data['color'],
          );
        }).toList();

    return Stack(
      alignment: Alignment.center,
      children: [
        PieChatWidget(
          dataList: dataList,
          isBackground: true,
          isLineText: true,
          bgColor: Colors.white,
          isFrontgText: false,
          initSelect: 1,
          openType: OpenType.ANI,
          loopType: LoopType.DOWN_LOOP,
        ),
        ClipOval(
          child: Image.asset(
            'assets/images/yarn.jpg',
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
