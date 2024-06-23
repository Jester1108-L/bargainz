import 'package:bargainz/components/app-scaffold.dart';
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
  final _controller = TextEditingController();

  void onSave(bool updating, String id) {
    setState(() {
      Category category = Category(name: _controller.text, id: id);

      if (updating) {
        CategoryDatabase.updateCategory(category);
      } else {
        CategoryDatabase.insertCategory(category);
      }

      _controller.clear();
      Navigator.of(context).pop();
    });
  }

  void onDelete(String id) {
    setState(() {
      CategoryDatabase.deleteCategory(id);
    });
  }

  void onEdit(String id, String name) {
    showDialog(
        context: context,
        builder: (context) {
          _controller.text = name;

          return CategoryDialogBox(
            controller: _controller,
            onCancel: () => Navigator.of(context).pop(),
            onSave: () => onSave(true, id),
          );
        });
  }

  void addCategory(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CategoryDialogBox(
            controller: _controller,
            onCancel: () => Navigator.of(context).pop(),
            onSave: () => onSave(false, ""),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget childWidget = StreamBuilder<QuerySnapshot>(
      stream: CategoryDatabase.getCategories(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 250,
                  width: 250,
                  child: Image.asset('assets/images/image-loading.gif'),
                ),
              ),
            ],
          );
        }

        List<DocumentSnapshot> docs = snapshot.data!.docs;

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
            for (DocumentSnapshot doc in docs)
              CategoryTile(
                title: doc["name"],
                onDelete: (context) => onDelete(doc.id),
                onEdit: (context) => onEdit(doc.id, doc["name"]),
              )
          ],
        );
      },
    );

    return AppScaffold(childWidget: childWidget);
  }
}
