import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryTile extends StatelessWidget {
  final String title;
  final String unit_of_measure;
  final Function(BuildContext)? onDelete;
  final Function(BuildContext)? onEdit;

  const CategoryTile({super.key, required this.title, required this.unit_of_measure, required this.onDelete, required this.onEdit});

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
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Text("UoM: $unit_of_measure"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
