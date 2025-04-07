import 'package:flutter/material.dart';
import 'package:yarn_inventory_manager/model/yarn.dart';

class YarnListView extends StatelessWidget {
  final List<Yarn> items;
  final ValueChanged<int> onRemove;

  const YarnListView({super.key, required this.items, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            subtitle: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Brand: ',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  TextSpan(text: item.brand),
                  const TextSpan(
                    text: ' Fiber: ',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  TextSpan(text: item.fiber),
                  const TextSpan(
                    text: ' Color: ',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  TextSpan(text: item.color),
                  const TextSpan(
                    text: ' Quantity: ',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  TextSpan(text: '${item.quantity}'),
                ],
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.cancel, color: Colors.blueAccent),
              onPressed: () => onRemove(index),
            ),
          ),
        );
      },
    );
  }
}
