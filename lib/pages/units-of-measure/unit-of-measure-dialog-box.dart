import 'package:flutter/material.dart';

class UnitOfMeasureDialogBox extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController codeController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const UnitOfMeasureDialogBox(
      {super.key,
      required this.nameController,
      required this.codeController,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Unit Of Measure"),
            const Divider(
              thickness: 1,
              color: Color.fromARGB(64, 0, 0, 0),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "Name"),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  TextField(
                    controller: codeController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "Code"),
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
