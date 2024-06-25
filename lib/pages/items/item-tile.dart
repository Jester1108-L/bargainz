import 'package:bargainz/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ItemTile extends StatelessWidget {
  final Product product;
  final Function(BuildContext)? onDelete;
  final Function(BuildContext)? onEdit;

  const ItemTile(
      {super.key,
      required this.product,
      required this.onDelete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Slidable(
        enabled: true,
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(8),
              onPressed: onDelete,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              foregroundColor: Colors.white,
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(8),
              onPressed: onEdit,
              icon: Icons.edit,
              backgroundColor: Colors.green.shade300,
              foregroundColor: Colors.white,
            ),
          ],
        ),
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Color.fromARGB(64, 0, 0, 0),
                ),
                Text(product.description),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Price: " + product.price.toString()),
                    Text("Unit: " + product.unit.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Barcode: " + product.barcode),
                    Text("UoM: " + product.unit_of_measure),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Category: " + product.category),
                    Text("Retailer: " + product.retailer),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
