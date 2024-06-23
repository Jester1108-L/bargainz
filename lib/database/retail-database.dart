import 'package:bargainz/models/retailer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RetailerDatabase {
  static final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('retailers');

  static Stream<QuerySnapshot<Map<String, dynamic>>> getRetailers() {
    return _collection.snapshots();
  }

  static Future<List<Retailer>> getRetailersListing() async {
    return await _collection.get().then((snapshot) {
      return snapshot.docs
          .map((el) => Retailer(name: el['name'], id: el.id))
          .toList();
    });
  }

  static Future<String> insertRetailer(Retailer retailer) async {
    return await _collection.add(retailer.toMap()).then((docRef) {
      return docRef.id;
    });
  }

  static Future<void> updateRetailer(Retailer retailer) {
    return _collection.doc(retailer.id).set(retailer.toMap());
  }

  static void deleteRetailer(String id) {
    _collection.doc(id).delete();
  }
}
