import 'package:bargainz/components/app-scaffold.dart';
import 'package:bargainz/components/stream-list-view.dart';
import 'package:bargainz/database/product-history-database.dart';
import 'package:bargainz/models/product-history.dart';
import 'package:bargainz/pages/product-history/product-history-tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // Delete category
  void onDelete(String id) {
    ProductHistoryDatabase.deleteProductHistory(id);
    setState(() {});
  }

  // Builder function for list view
  Widget productHistoryListView(List<DocumentSnapshot> docs) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        if (docs.isNotEmpty)
          for (DocumentSnapshot doc in docs)
            ProductHistoryTile(
              product_history: ProductHistory.toObjectWithSnapshot(doc),
            ),
        if (docs.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 32.0),
              child: Text(
                'No history',
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
        title: "History",
        childWidget: StreamListView(
            stream: ProductHistoryDatabase.getProductHistory(),
            listViewBuilder: productHistoryListView));
  }
}
