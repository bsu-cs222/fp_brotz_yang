import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_echart/flutter_echart.dart';
import 'package:yarn_inventory_manager/model/yarn.dart';
import 'package:yarn_inventory_manager/view/input_row.dart';

import 'yarn_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  Color _pickerColor = Colors.blue;

  final List<Yarn> _items = [];
  List<Yarn> _displayItems = [];
  bool _isPieChartVisible = false;

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
    });
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
            Visibility(
              visible: _isPieChartVisible && _displayItems.isNotEmpty,
              maintainState: true,
              child: Container(
                height: 300,
                color: Colors.blue,
                child: _buildPieChartContainer(),
              ),
            ),

            YarnListView(
              items: _displayItems,
              onRemove:
                  (index) => setState(() => _displayItems.removeAt(index)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartContainer() {
    if (_displayItems.isEmpty) return SizedBox();

    final Map<String, dynamic> _colorCounts = {};

    _displayItems.forEach((item) {
      String colorHex = item.swatchColor.value
          .toRadixString(16)
          .padLeft(8, '0');
      if (_colorCounts.containsKey(colorHex)) {
        _colorCounts[colorHex]['wuantity'] += item.quantity;
      } else {
        _colorCounts[colorHex] = {
          'quantity': item.quantity,
          'name': item.color.isNotEmpty ? item.color : 'Unnamed',
          'color': item.swatchColor,
        };
      }
    });

    List<EChartPieBean> _dataList =
        _colorCounts.values.map((data) {
          return EChartPieBean(
            title: data['name'],
            number: data['quantity'],
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
          isFrontgText: false,
          openType: OpenType.ANI,
          loopType: LoopType.DOWN_LOOP,
          clickCallBack: (int value) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Number of colors: $value')));
          },
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(25),
          child: const Text(
            'Colors',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
