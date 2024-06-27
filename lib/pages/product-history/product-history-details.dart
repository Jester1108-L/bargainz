import 'package:bargainz/components/app-scaffold.dart';
import 'package:bargainz/models/product-history.dart';
import 'package:bargainz/models/product.dart';
import 'package:bargainz/pages/products/product-tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductHistoryDetails extends StatefulWidget {
  final ProductHistory product_history;

  const ProductHistoryDetails({super.key, required this.product_history});

  @override
  State<ProductHistoryDetails> createState() => _ProductHistoryDetailsState();
}

class _ProductHistoryDetailsState extends State<ProductHistoryDetails> {
  @override
  Widget build(BuildContext context) {
    DateTime created = DateTime.parse(
        widget.product_history.created ?? DateTime.now().toString());

    return AppScaffold(
        title: "History Details",
        childWidget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Details"),
              const Divider(
                thickness: 1,
                color: Color.fromARGB(64, 0, 0, 0),
              ),
              Text("Created: ${DateFormat('yyyy-MM-dd kk:mm').format(created)}"),
              const Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: Text("Products"),
              ),
              const Divider(
                thickness: 1,
                color: Color.fromARGB(64, 0, 0, 0),
              ),
              for (Product product in widget.product_history.products)
                ProductTile(
                  product: product,
                  enableSlider: false,
                  onDelete: (context) => {},
                  onEdit: (context) {},
                )
            ],
          ),
        ));
  }
}
