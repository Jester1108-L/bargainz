import 'package:bargainz/database/firebase-database.dart';
import 'package:bargainz/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Database class for product operations
class ProductDatabase {
  static final FirebaseDatabase baseDatabase = FirebaseDatabase(collection_name: 'products');

  // Get stream of units of measure
  static Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return baseDatabase.getSnapshots();
  }

  // Get listing of products in collection
  static Future<List<Product>> getProductListing() async {
    return await baseDatabase.collection.get().then((snapshot) {
      return snapshot.docs
          .map((el) => Product(
              barcode: el["barcode"],
              name: el["name"],
              description: el["description"],
              category: el["category"],
              unit_of_measure: el["unit_of_measure"],
              retailer: el["retailer"],
              unit: el["unit"],
              price: el["price"],
              id: el.id))
          .toList();
    });
  }

  // Insert unit of measure
  static Future<String> insertProduct(Product product) async {
    return await baseDatabase.insertDoc(product);
  }

  // Update unit of measure
  static Future<void> updateProduct(Product product) {
    return baseDatabase.updateDoc(product);
  }

  // Delete unit of measure
  static Future<void> deleteProduct(String id) {
    return baseDatabase.deleteDoc(id);
  }

  // Delete all docs in collection
  static Future<void> deleteAll() {
    return baseDatabase.collection.snapshots().forEach((stream) {stream.docs.forEach((doc){deleteProduct(doc.id);});});
  }
}
