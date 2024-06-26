import 'package:bargainz/components/app-scaffold.dart';
import 'package:bargainz/components/stream-list-view.dart';
import 'package:bargainz/database/category-database.dart';
import 'package:bargainz/models/category.dart';
import 'package:bargainz/pages/categories/category-dialog-box.dart';
import 'package:bargainz/pages/categories/category-tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  // Delete category
  void onDelete(String id) {
    CategoryDatabase.deleteCategory(id);
    setState(() {});
  }

  // On category edit, show dialog
  void onEdit(Category category) {
    showDialog(
        context: context,
        builder: (context) {
          return CategoryDialogBox(
            id: category.id,
            category: category,
          );
        });
  }

  // Add category
  void addCategory(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CategoryDialogBox(
            category: Category.empty(),
          );
        });
  }

  // Builder function for list view
  Widget categoryListView(List<DocumentSnapshot> docs) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => addCategory(context),
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.green)),
              child: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 244, 253, 255),
              ),
            ),
          ],
        ),
        if (docs.isNotEmpty)
          for (DocumentSnapshot doc in docs)
            CategoryTile(
              category: Category.toObjectWithSnapshot(doc),
              onDelete: (context) => onDelete(doc.id),
              onEdit: (context) => onEdit(Category.toObjectWithSnapshot(doc)),
            ),
        if (docs.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                'No categories',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        childWidget: StreamListView(
            stream: CategoryDatabase.getCategories(),
            listViewBuilder: categoryListView));
  }
}
