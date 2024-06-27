import 'package:bargainz/components/app-scaffold.dart';
import 'package:bargainz/components/stream-list-view.dart';
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
  // Delete unit of measure
  void onDelete(String id) {
    UnitsOfMeasureDatabase.deleteUnitOfMeasure(id);
    setState(() {});
  }

  // Edit unit of measure
  void onEdit(UnitOfMeasure unit_of_measure) {
    showDialog(
        context: context,
        builder: (context) {
          return UnitOfMeasureDialogBox(
            id: unit_of_measure.id,
            unit_of_measure: unit_of_measure,
          );
        });
  }

  // Add unit of measure
  void addUnitOfMeasure(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return UnitOfMeasureDialogBox(
            unit_of_measure: UnitOfMeasure.empty(),
          );
        });
  }

  // Builder function for list view
  ListView unitOfMeasureListView(List<DocumentSnapshot> docs) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => addUnitOfMeasure(context),
              style: const ButtonStyle(
                  elevation: WidgetStatePropertyAll(8),
                  backgroundColor: WidgetStatePropertyAll(Colors.white)),
              child: const Icon(
                Icons.add,
                color: Colors.teal,
              ),
            ),
          ],
        ),
        if (docs.isNotEmpty)
          for (DocumentSnapshot doc in docs)
            UnitOfMeasureTile(
              unit_of_measure: UnitOfMeasure.toObjectWithSnapshot(doc),
              onDelete: (context) => onDelete(doc.id),
              onEdit: (context) =>
                  onEdit(UnitOfMeasure.toObjectWithSnapshot(doc)),
            ),
        if (docs.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 32.0),
              child: Text(
                'No units of measure',
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
        title: "Units Of Measure",
        childWidget: StreamListView(
          listViewBuilder: unitOfMeasureListView,
          stream: UnitsOfMeasureDatabase.getUnitsOfMeasure(),
        ));
  }
}
