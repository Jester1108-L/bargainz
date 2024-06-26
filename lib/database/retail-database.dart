import 'package:bargainz/database/firebase-database.dart';
import 'package:bargainz/models/retailer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Database class for retailer operations
class RetailerDatabase {
  static final FirebaseDatabase baseDatabase = FirebaseDatabase(collection_name: 'retailers');

  // Get stream of retailers
  static Stream<QuerySnapshot<Map<String, dynamic>>> getRetailers() {
    return baseDatabase.getSnapshots();
  }

  // Get listing of retailers
  static Future<List<Retailer>> getRetailersListing() async {
    return await baseDatabase.collection.get().then((snapshot) {
      return snapshot.docs
          .map((el) => Retailer(name: el['name'], id: el.id))
          .toList();
    });
  }

  // Insert retailer
  static Future<String> insertRetailer(Retailer retailer) async {
    return await baseDatabase.insertDoc(retailer);
  }

  // Update retailer
  static Future<void> updateRetailer(Retailer retailer) {
    return baseDatabase.updateDoc(retailer);
  }

  // Delete retailer
  static Future<void> deleteRetailer(String id) {
    return baseDatabase.deleteDoc(id);
  }
}
