import 'package:flutter/material.dart';
import 'package:yarn_inventory_manager/model/Yarn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

  final List<Yarn> _items = [];

  void _addItem() {
    String name = _nameController.text.trim();
    String brand = _brandController.text.trim();
    String fiber = _fiberController.text.trim();
    String color = _colorController.text.trim();
    String quantityStr = _quantityController.text.trim();

    if (name.isEmpty || brand.isEmpty || quantityStr.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill in all the fields.')));
      return;
    }

    int quantity = int.parse(quantityStr);

    Yarn data = Yarn();
    data.name = name;
    data.brand = brand;
    data.fiber = fiber;
    data.color = color;
    data.qty = quantity;
    _items.add(data);

    _nameController.clear();
    _brandController.clear();
    _fiberController.clear();
    _colorController.clear();
    _quantityController.clear();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          // Center the content in the AppBar
          child: Row(
            mainAxisSize:
                MainAxisSize.min, // Ensures Row only takes up necessary space
            children: [
              Icon(Icons.local_florist_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text(widget.title),
              SizedBox(width: 10),
              Icon(
                Icons.local_florist_rounded, // Flower icon
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _brandController,
                    decoration: InputDecoration(
                      labelText: 'Brand',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _fiberController,
                    decoration: InputDecoration(
                      labelText: 'Fiber',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _colorController,
                    decoration: InputDecoration(
                      labelText: 'Color',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: _addItem, child: Text('Add')),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: item.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    style: TextStyle(fontSize: 16, letterSpacing: 0.5),
                  ),
                  subtitle: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Brand: ',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        TextSpan(text: item.brand),
                        TextSpan(
                          text: 'Fiber: ',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        TextSpan(text: item.fiber),
                        TextSpan(
                          text: 'Color: ',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        TextSpan(text: item.color),
                        TextSpan(
                          text: 'Quantity: ',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        TextSpan(text: '${item.qty}'),
                      ],
                    ),
                    style: TextStyle(fontSize: 14, letterSpacing: 0.5),
                  ),

                  trailing: IconButton(
                    icon: Icon(Icons.cancel, color: Colors.blueAccent.shade100),
                    onPressed: () {
                      setState(() {
                        _items.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
