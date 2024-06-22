import 'package:bargainz/pages/retailers/retail-dialog-box.dart';
import 'package:bargainz/pages/retailers/retail-tile.dart';
import 'package:flutter/material.dart';

class Retailers extends StatefulWidget {

  Retailers({super.key});

  @override
  State<Retailers> createState() => _RetailersState();
}

class _RetailersState extends State<Retailers> {
  final _controller = TextEditingController();

  final List<String> _retailers = [
    'PNP',
    'Checkers',
  ];

  void onSave(bool updating, int idx) {
    setState(() {
      if (updating) {
        _retailers[idx] = _controller.text;
      } else {
        _retailers.add(_controller.text);
      }

      _controller.clear();
      Navigator.of(context).pop();
    });
  }

  void onDelete(int index) {
    setState(() {
      _retailers.removeAt(index);
    });
  }

  void onEdit(int index) {
    showDialog(
      context: context,
      builder: (context) {
        _controller.text = _retailers[index];

        return RetailDialogBox(
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
          return RetailDialogBox(
            controller: _controller,
            onCancel: () => Navigator.of(context).pop(),
            onSave: () => onSave(false, -1),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 8, right: 8),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          ElevatedButton(
            onPressed: () => addCategory(context),
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.green)
            ),
            child: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 244, 253, 255),
            ),
          ),
          for (int i = 0; i < _retailers.length; i++)
            RetailTile(
              title: _retailers[i],
              onDelete: (context) => onDelete(i),
              onEdit: (context) => onEdit(i),
            )
        ],
      ),
    );
  }
}
