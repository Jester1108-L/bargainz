import 'package:bargainz/database/product-database.dart';
import 'package:bargainz/models/product.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class ProductSummary extends StatefulWidget {
  const ProductSummary({super.key});

  @override
  State<ProductSummary> createState() => _ProductSummaryState();
}

class _ProductSummaryState extends State<ProductSummary> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();

    ProductDatabase.getProducts().forEach((stream) {
      products = stream.docs.map((el) {
        return Product.toObjectWithSnapshot(el);
      }).toList();
      setState(() {});
    });
  }

  // Calculate price of product per unit of measure
  double getPricePerUoM(Product product) {
    return (((100 * (product.price / (product.unit == 0 ? 1 : product.unit))))
            .roundToDouble() /
        100);
  }

  @override
  Widget build(BuildContext context) {
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

    products.sort((p1, p2) {
      return getPricePerUoM(p1) > getPricePerUoM(p2) ? 1 : 0;
    });

    Map<String, List<Product>> grouping = {};

    for (Product product in products) {
      grouping[product.category] = [
        ...(grouping[product.category] ?? []),
        product
      ];
    }

    List<DataRow> rows = [];
    bool isOdd = true;

    grouping.forEach((key, value) {
      for (int i = 0; i < value.length; i++) {
        final product = value[i];
        int opacityVariant = 400 - (100 * i);
        opacityVariant = opacityVariant < 100 ? 100 : opacityVariant;

        rows.add(DataRow(
            color: WidgetStatePropertyAll(isOdd
                ? Colors.teal[opacityVariant]
                : Colors.green[opacityVariant]),
            cells: [
              DataCell(Text(product.name)),
              DataCell(Text(product.category)),
              DataCell(Text(product.retailer)),
              DataCell(Text(product.price.toString())),
              DataCell(Text(product.unit.toString())),
              DataCell(Text(product.unit_of_measure)),
              DataCell(Text(getPricePerUoM(product).toString())),
            ]));
      }

      isOdd = !isOdd;
    });

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DataTable2(
        columnSpacing: 8,
        minWidth: 400,
        columns: const [
          DataColumn2(
            fixedWidth: 48,
            label: Text('Name'),
          ),
          DataColumn2(
            label: Text('Category'),
          ),
          DataColumn2(
            label: Text('Retailer'),
          ),
          DataColumn2(
            fixedWidth: 48,
            label: Text('Price'),
          ),
          DataColumn2(
            fixedWidth: 48,
            label: Text('Unit'),
          ),
          DataColumn2(
            fixedWidth: 48,
            label: Text('UoM'),
          ),
          DataColumn2(
            fixedWidth: 48,
            label: Text('Price/UoM'),
          ),
        ],
        rows: rows,
      ),
    );
  }
}
