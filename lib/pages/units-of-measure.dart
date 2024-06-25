import 'package:bargainz/components/app-scaffold.dart';
import 'package:bargainz/database/unit-of-measure-database.dart';
import 'package:bargainz/models/unit-of-measure.dart';
import 'package:bargainz/pages/units-of-measure/unit-of-measure-dialog-box.dart';
import 'package:bargainz/pages/units-of-measure/unit-of-measure-tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UnitsOfMeasure extends StatefulWidget {
  const UnitsOfMeasure({super.key});

  @override
  State<UnitsOfMeasure> createState() => _UnitsOfMeasureState();
}

class _UnitsOfMeasureState extends State<UnitsOfMeasure> {
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  void onSave(bool updating, String id) {
    setState(() {
      UnitOfMeasure unit_of_measure = UnitOfMeasure(name: _nameController.text, id: id, code: _codeController.text);

      if (updating) {
        UnitsOfMeasureDatabase.updateUnitOfMeasure(unit_of_measure);
      } else {
        UnitsOfMeasureDatabase.insertUnitOfMeasure(unit_of_measure);
      }

      _nameController.clear();
      _codeController.clear();
      Navigator.of(context).pop();
    });
  }

  void onDelete(String id) {
    setState(() {
      UnitsOfMeasureDatabase.deleteUnitOfMeasure(id);
    });
  }

  void onEdit(String id, String name, String code) {
    showDialog(
        context: context,
        builder: (context) {
          _nameController.text = name;
          _codeController.text = code;

          return UnitOfMeasureDialogBox(
            nameController: _nameController,
            codeController: _codeController,
            onCancel: () => Navigator.of(context).pop(),
            onSave: () => onSave(true, id),
          );
        });
  }

  void addUnitOfMeasure(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return UnitOfMeasureDialogBox(
            nameController: _nameController,
            codeController: _codeController,
            onCancel: () => Navigator.of(context).pop(),
            onSave: () => onSave(false, ""),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget childWidget = StreamBuilder<QuerySnapshot>(
      stream: UnitsOfMeasureDatabase.getUnitsOfMeasure(),
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
                  onPressed: () => addUnitOfMeasure(context),
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
              UnitOfMeasureTile(
                title: doc["name"],
                code: doc["code"],
                onDelete: (context) => onDelete(doc.id),
                onEdit: (context) => onEdit(doc.id, doc["name"], doc["code"]),
              )
          ],
        );
      },
    );

    return AppScaffold(childWidget: childWidget);
  }
}
