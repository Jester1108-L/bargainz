import 'package:bargainz/models/item.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class ItemSummary extends StatelessWidget {
  final List<Item> _items = [
    Item(barcode: "09090"),
    Item(barcode: "09090"),
    Item(barcode: "09090"),
    Item(barcode: "09090"),
  ];

  ItemSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DataTable2(
        columnSpacing: 12,
        // horizontalMargin: 12,
        minWidth: 600,
        columns: const [
          DataColumn2(
            label: Text('Barcode'),
          ),
        ],
        rows: [
          for (Item item in _items)
            DataRow(cells: [DataCell(Text(item.barcode))])
        ],
      ),
    );
  }
}
