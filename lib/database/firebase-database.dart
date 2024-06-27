import 'package:bargainz/models/base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Base database class to firebase service. Class contains basic connection operations
class FirebaseDatabase {
  late CollectionReference<Map<String, dynamic>> collection;

  // ignore: non_constant_identifier_names
  FirebaseDatabase({String collection_name = ""}) {
    collection = FirebaseFirestore.instance.collection(collection_name);
  }

  // Get stream of collection snapshots
  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshots() {
    return collection.snapshots();
  }

  // Insert doc into collection
  Future<String> insertDoc(Base doc) async {
    return await collection.add(doc.toMap()).then((docRef) {
      return docRef.id;
    });
  }

  // Update doc in collection
  Future<void> updateDoc(Base doc) {
    return collection.doc(doc.id).set(doc.toMap());
  }

  // Delete doc from collection
  Future<void> deleteDoc(String id) {
    return collection.doc(id).delete();
  }
}
