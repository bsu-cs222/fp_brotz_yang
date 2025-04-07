import 'package:flutter/material.dart';

class InputRowView extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController brandController;
  final TextEditingController fiberController;
  final TextEditingController colorController;
  final TextEditingController quantityController;
  final VoidCallback onAdd;
  final VoidCallback onPieCharts;
  final VoidCallback onColorTap;
  final Color pickedColor;

  const InputRowView({
    super.key,
    required this.nameController,
    required this.brandController,
    required this.fiberController,
    required this.colorController,
    required this.quantityController,
    required this.onAdd,
    required this.onPieCharts,
    required this.onColorTap,
    required this.pickedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              key: Key('name'),
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: TextField(
              key: Key('brand'),
              controller: brandController,
              decoration: const InputDecoration(
                labelText: 'Brand',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: TextField(
              key: Key('fiber'),
              controller: fiberController,
              decoration: const InputDecoration(
                labelText: 'Fiber',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: TextField(
              key: Key('color'),
              controller: colorController,
              decoration: InputDecoration(
                labelText: 'Color',
                suffixIcon: IconButton(
                  icon: Icon(Icons.color_lens_rounded),
                  onPressed: onColorTap,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 1,
            child: TextField(
              key: Key('quantity'),
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            key: Key('add'),
            onPressed: onAdd,
            child: const Text('Add'),
          ),
          IconButton(
            icon: const Icon(Icons.pie_chart_rounded, color: Colors.blueAccent),
            onPressed: onPieCharts,
          ),
        ],
      ),
    );
  }
}
