import 'package:bargainz/components/app-scaffold.dart';
import 'package:bargainz/components/stream-list-view.dart';
import 'package:bargainz/database/retail-database.dart';
import 'package:bargainz/models/retailer.dart';
import 'package:bargainz/pages/retailers/retailer-dialog-box.dart';
import 'package:bargainz/pages/retailers/retailer-tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Retailers extends StatefulWidget {
  const Retailers({super.key});

  @override
  State<Retailers> createState() => _RetailersState();
}

class _RetailersState extends State<Retailers> {
  // Delete retailer
  void onDelete(String id) {
    setState(() {
      RetailerDatabase.deleteRetailer(id);
    });
  }

  // Edit retailer
  void onEdit(Retailer retailer) {
    showDialog(
        context: context,
        builder: (context) {
          return RetailerDialogBox(
            id: retailer.id,
            retailer: retailer,
          );
        });
  }

  // Add new retailer
  void addRetailer(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return RetailerDialogBox(
            retailer: Retailer.empty(),
          );
        });
  }

  // Builder function for list view
  ListView retailerListView(List<DocumentSnapshot> docs) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => addRetailer(context),
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
            RetailerTile(
              title: doc['name'],
              onDelete: (context) => onDelete(doc.id),
              onEdit: (context) => onEdit(Retailer.toObjectWithSnapshot(doc)),
            ),
        if (docs.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                'No retailers',
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
      listViewBuilder: retailerListView,
      stream: RetailerDatabase.getRetailers(),
    ));
  }
}
