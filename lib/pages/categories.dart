import 'package:bargainz/pages/categories/category-dialog-box.dart';
import 'package:bargainz/pages/categories/category-tile.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final _controller = TextEditingController();

  final List<String> _categories = [
    'Cheese',
    'Meat',
  ];

  void onSave(bool updating, int idx) {
    setState(() {
      if (updating) {
        _categories[idx] = _controller.text;
      } else {
        _categories.add(_controller.text);
      }

      _controller.clear();
      Navigator.of(context).pop();
    });
  }

  void onDelete(int index) {
    setState(() {
      _categories.removeAt(index);
    });
  }

  void onEdit(int index) {
    showDialog(
        context: context,
        builder: (context) {
          _controller.text = _categories[index];

          return CategoryDialogBox(
            controller: _controller,
            onCancel: () => Navigator.of(context).pop(),
            onSave: () => onSave(true, index),
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
            onSave: () => onSave(false, -1),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: Colors.teal,
        title: const Text(
          "Test",
          style: TextStyle(
            color: Color.fromARGB(255, 244, 253, 255),
          ),
        ),
        centerTitle: true,
        shadowColor: Colors.black,
        elevation: 8,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32, left: 8, right: 8),
        child: ListView(
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
            for (int i = 0; i < _categories.length; i++)
              CategoryTile(
                title: _categories[i],
                onDelete: (context) => onDelete(i),
                onEdit: (context) => onEdit(i),
              )
          ],
        ),
      ),
    );
  }
}
