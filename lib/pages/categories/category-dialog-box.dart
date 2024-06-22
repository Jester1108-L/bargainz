import 'package:flutter/material.dart';

class CategoryDialogBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const CategoryDialogBox(
      {super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Create Category"),
            const Divider(
              thickness: 1,
              color: Color.fromARGB(64, 0, 0, 0),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "Category Name"),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton(
                  onPressed: onSave,
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.green)),
                  child: const Text("Save"),
                ),
                FilledButton(
                  onPressed: onCancel,
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
