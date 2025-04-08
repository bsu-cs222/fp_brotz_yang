import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_echart/flutter_echart.dart';
import 'package:yarn_inventory_manager/model/yarn.dart';
import 'package:yarn_inventory_manager/view/input_row.dart';

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

// controller creation
class _MyHomePageState extends State<MyHomePage> {
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _fiberController = TextEditingController();
  final _colorController = TextEditingController();
  final _quantityController = TextEditingController();
  Color _pickerColor = Colors.blueAccent;

  final List<Yarn> _items = [];
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
  bool _isDropdownVisible = false; // drop-down visibility
  // adding system
  void _addItem() {
    String name = _nameController.text.trim();
    String brand = _brandController.text.trim();
    String fiber = _fiberController.text.trim();
    String color = _colorController.text.trim();
    String quantityStr = _quantityController.text.trim();

    if (name.isEmpty || brand.isEmpty || quantityStr.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields.')));
      return;
    }

    int quantity = int.parse(quantityStr);

    Yarn data = Yarn(
      name: name,
      brand: brand,
      fiber: fiber,
      color: color,
      quantity: quantity,
      swatchColor: _pickerColor,
    );

    _items.add(data);

    _nameController.clear();
    _brandController.clear();
    _fiberController.clear();
    _colorController.clear();
    _quantityController.clear();

    setState(() {
      _displayItems = List.from(_items);
      _sortItems(); // keep it sorted after adding
    });
  }

  // color picker logic
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
                  showLabel: true,
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

  // sorting system based on the first letter
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

  // decoration
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_florist_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text(widget.title),
              SizedBox(width: 10),
              Icon(Icons.local_florist_rounded, color: Colors.white),
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
            // button to toggle dropdown visibility
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isDropdownVisible = !_isDropdownVisible;
                });
              },
              child: Text('Sort Yarn'),
            ),
            // dropdown menu to select sorting method
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
                onRemove:
                    (index) => setState(() {
                      _displayItems.removeAt(index);
                      _sortItems(); // keep sorted after remove
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartContainer() {
    if (_displayItems.isEmpty) return SizedBox();

    final Map<String, dynamic> colorCounts = {};

    for (var item in _displayItems) {
      String colorHex = item.swatchColor.value
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

    List<EChartPieBean> _dataList =
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
          dataList: _dataList,
          isBackground: true,
          isLineText: true,
          bgColor: Colors.white,
          isFrontgText: true,
          initSelect: 1,
          openType: OpenType.ANI,
          loopType: LoopType.DOWN_LOOP,
          clickCallBack: (int value) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Number of colors: $value')));
          },
        ),
        // new center circle
        const Text(
          'Colors',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
