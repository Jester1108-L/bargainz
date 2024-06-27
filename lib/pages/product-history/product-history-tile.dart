import 'package:bargainz/database/product-database.dart';
import 'package:bargainz/models/product-history.dart';
import 'package:bargainz/pages/product-history/product-history-details.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ProductHistoryTile extends StatefulWidget {
  final ProductHistory product_history;

  const ProductHistoryTile({super.key, required this.product_history});

  @override
  State<ProductHistoryTile> createState() => _ProductHistoryTileState();
}

class _ProductHistoryTileState extends State<ProductHistoryTile> {
  @override
  void initState() {
    super.initState();
    ProductDatabase.getProductHistoryListing(history_id: widget.product_history.id ?? "")
        .then((products) {
      widget.product_history.products = products;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime created = DateTime.parse(
        widget.product_history.created ?? DateTime.now().toString());

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Created: ${DateFormat('yyyy-MM-dd kk:mm').format(created)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "Product #: ${widget.product_history.products.length}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                ProductHistoryDetails(
                              product_history: widget.product_history,
                            ),
                          ),
                        );
                      },
                      child: const Text("View Details"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
