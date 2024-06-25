import 'package:bargainz/components/app-scaffold.dart';
import 'package:bargainz/database/retail-database.dart';
import 'package:bargainz/models/retailer.dart';
import 'package:bargainz/pages/retailers/retail-dialog-box.dart';
import 'package:bargainz/pages/retailers/retail-tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Retailers extends StatefulWidget {
  Retailers({super.key});

  @override
  State<Retailers> createState() => _RetailersState();
}

class _RetailersState extends State<Retailers> {
  final _controller = TextEditingController();

  void onSave(bool updating, String id) {
    setState(() {
      Retailer retailer = Retailer(name: _controller.text, id: id);

      if (updating) {
        RetailerDatabase.updateRetailer(retailer);
      } else {
        RetailerDatabase.insertRetailer(retailer);
      }

      _controller.clear();
      Navigator.of(context).pop();
    });
  }

  void onDelete(String id) {
    setState(() {
      RetailerDatabase.deleteRetailer(id);
    });
  }

  void onEdit(String id, String name) {
    showDialog(
        context: context,
        builder: (context) {
          _controller.text = name;

          return RetailDialogBox(
            controller: _controller,
            onCancel: () => Navigator.of(context).pop(),
            onSave: () => onSave(true, id),
          );
        });
  }

  void addRetailer(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return RetailDialogBox(
            controller: _controller,
            onCancel: () => Navigator.of(context).pop(),
            onSave: () => onSave(false, ""),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget childWidget = StreamBuilder<QuerySnapshot>(
      stream: RetailerDatabase.getRetailers(),
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
            for (DocumentSnapshot doc in docs)
              RetailTile(
                title: doc['name'],
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
