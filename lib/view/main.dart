import 'dart:math';

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
  Color _pickedColor = Colors.blue;

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

    Yarn data = Yarn();
    data.name = name;
    data.brand = brand;
    data.fiber = fiber;
    data.color = color;
    data.quantity = quantity;
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
              child: ColorPicker(
                pickerColor: _pickedColor,
                onColorChanged: (value) {
                  setState(() {
                    _pickedColor = value;
                  });
                },
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
              pickedColor: _pickedColor,
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

  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
    );
  }

  Widget _buildPieChartContainer() {
    if (_displayItems.isEmpty) return SizedBox();
    final Map<String, int> _nameCounts = {};

    _displayItems.forEach((item) {
      _nameCounts[item.brand] = (_nameCounts[item.brand] ?? 0) + 1;
    });
    List<EChartPieBean> _dataList = [];
    _nameCounts.forEach((name, count) {
      _dataList.add(
        EChartPieBean(title: name, number: count, color: _getRandomColor()),
      );
    });

    return PieChatWidget(
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
        ).showSnackBar(SnackBar(content: Text('Number of brands: $value')));
      },
    );
  }
}
