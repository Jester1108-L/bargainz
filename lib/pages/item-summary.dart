import 'package:bargainz/database/product-database.dart';
import 'package:bargainz/models/product.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class ItemSummary extends StatefulWidget {
  ItemSummary({super.key});

  @override
  State<ItemSummary> createState() => _ItemSummaryState();
}

class _ItemSummaryState extends State<ItemSummary> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();

    ProductDatabase.getProducts().forEach((stream) {
      products = stream.docs.map((el) {
        return Product(
            barcode: el["barcode"],
            name: el["name"],
            category: el["category"],
            price: el["price"],
            unit: el["unit"],
            retailer: el["retailer"],
            unit_of_measure: el["unit_of_measure"],
            description: el["description"]);
      }).toList();
      setState(() {});
    });
  }

  double getPricePerUoM(Product product) {
    return (((100 * (product.price / (product.unit == 0 ? 1 : product.unit))))
            .roundToDouble() /
        100);
  }

  @override
  Widget build(BuildContext context) {
    products.sort((p1, p2) {
      return getPricePerUoM(p1) > getPricePerUoM(p2) ? 1 : 0;
    });

    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            'No products',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DataTable2(
        columnSpacing: 8,
        minWidth: 600,
        columns: const [
          DataColumn2(
            label: Text('Name'),
          ),
          DataColumn2(
            label: Text('Category'),
          ),
          DataColumn2(
            label: Text('Retailer'),
          ),
          DataColumn2(
            label: Text('Price'),
          ),
          DataColumn2(
            label: Text('Unit'),
          ),
          DataColumn2(
            label: Text('Price/UoM'),
          ),
        ],
        rows: [
          for (Product item in products)
            DataRow(cells: [
              DataCell(Text(item.name)),
              DataCell(Text(item.category)),
              DataCell(Text(item.retailer)),
              DataCell(Text(item.price.toString())),
              DataCell(Text(item.unit.toString())),
              DataCell(Text(getPricePerUoM(item).toString())),
            ])
        ],
      ),
    );
  }
}
