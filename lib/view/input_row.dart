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
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _buildTextField('Name', nameController, flex: 2),
          _buildTextField('Brand', brandController, flex: 2),
          _buildTextField('Fiber', fiberController, flex: 2),
          _buildTextField('Color', colorController, flex: 2),
          _buildColorPicker(context),
          _buildTextField(
            'Quantity',
            quantityController,
            flex: 1,
            isNumber: true,
          ),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int flex = 1,
    bool isNumber = false,
  }) {
    return SizedBox(
      width: flex * 100,
      child: TextField(
        key: Key(label.toLowerCase()),
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildColorPicker(BuildContext context) {
    return GestureDetector(
      onTap: onColorTap,
      child: Container(
        width: 200,
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: pickedColor,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.centerLeft,
        child: const Text(
          'Color Picker',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
