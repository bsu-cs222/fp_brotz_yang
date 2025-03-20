import 'package:flutter/material.dart';
import 'package:yarn_inventory_manager/dataBean.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '毛线仓库 / Yarn Inventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const MyHomePage(title: '毛线仓库 / Yarn Inventory'), // 应用入口
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

  // 数据列表 / Data List
  final List<DataBean> _items = [];

  // 添加数据方法 / Method to add data
  void _addItem() {
    // 获取输入值 / Get input values
    String name = _nameController.text.trim();
    String brand = _brandController.text.trim();
    String fiber = _fiberController.text.trim();
    String color = _colorController.text.trim();
    String quantityStr = _quantityController.text.trim();

    // 简单验证 / Simple validation
    if (name.isEmpty || brand.isEmpty || quantityStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请填写所有字段 / Please fill in all the fields.')),
      );
      return;
    }
    // 转换数量为整数 / Convert quantity to integer
    int quantity = int.parse(quantityStr);

    // 添加数据到列表 / Add data to the list
    DataBean data = DataBean();
    data.name = name;
    data.brand = brand;
    data.fiber = fiber;
    data.color = color;
    data.qty = quantity;
    _items.add(data);

    // 清空输入框 / Clear input fields
    _nameController.clear();
    _brandController.clear();
    _fiberController.clear();
    _colorController.clear();
    _quantityController.clear();

    // 更新状态 / Update state
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
          // 整体区域（使用Column布局垂直排列） 垂直排列（输入区域，列表区域）
          children: <Widget>[
            SizedBox(height: 15),
            Row(
              // 输入区域（使用Row布局水平排列）
              children: [
                Expanded(
                  //均分组件 将横向空间均匀的分配，有几个Expanded就分几份
                  child: TextField(
                    //输入框组件
                    controller: _nameController, //输入框控制器
                    decoration: InputDecoration(
                      //输入框样式
                      labelText: '名称 / Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _brandController,
                    decoration: InputDecoration(
                      labelText: '品牌 / Brand',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _fiberController,
                    decoration: InputDecoration(
                      labelText: '纤维 / Fiber',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _colorController,
                    decoration: InputDecoration(
                      labelText: '颜色 / Color',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '数量 / Quantity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addItem, //添加数据的方法
                  child: Text('添加 / Add'),
                ),
              ],
            ),
            ListView.builder(
              //列表区域 / list area
              shrinkWrap: true,
              itemCount: _items.length, //列表长度就代表有几条数据，也就是几行条目
              itemBuilder: (context, index) {
                final item = _items[index]; //获取对应行数的数据，index代表序号
                return ListTile(
                  //自带的快速展示控件
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
                          text: '品牌 / Brand: ',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        TextSpan(text: item.brand),
                        TextSpan(
                          text: ' 纤维 / Fiber: ',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        TextSpan(text: item.fiber),
                        TextSpan(
                          text: ' 颜色 / Color: ',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        TextSpan(text: item.color),
                        TextSpan(
                          text: ' 数量 / Quantity: ',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        TextSpan(text: '${item.qty}'),
                      ],
                    ),
                    style: TextStyle(fontSize: 14, letterSpacing: 0.5),
                  ),
                  //副标题
                  trailing: IconButton(
                    //图标 / icon
                    icon: Icon(Icons.cancel, color: Colors.blueAccent.shade100),
                    onPressed: () {
                      //图标的点击事件
                      setState(() {
                        //删除数据的方法
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
