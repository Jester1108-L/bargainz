import 'package:bargainz/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final Function(BuildContext)? onDelete;
  final Function(BuildContext)? onEdit;
  final bool enableSlider;

  const ProductTile(
      {super.key,
      this.enableSlider = true,
      required this.product,
      required this.onDelete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final productCard = Card(
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
                Text("Price: R" + product.price.toStringAsFixed(2)),
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
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: enableSlider
          ? Slidable(
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
              child: productCard,
            )
          : productCard,
    );
  }
}
