import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StreamListView extends StatelessWidget {
  final Stream<QuerySnapshot<Object?>> stream;
  final Widget Function(List<DocumentSnapshot>) listViewBuilder;

  const StreamListView(
      {super.key, required this.stream, required this.listViewBuilder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
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

        return listViewBuilder(snapshot.data!.docs);
      },
    );
  }
}
