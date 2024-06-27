import 'package:bargainz/database/firebase-database.dart';
import 'package:bargainz/models/product-history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Database class for product history operations
class ProductHistoryDatabase {
  static final FirebaseDatabase baseDatabase =
      FirebaseDatabase(collection_name: 'product-history');
  static final FirebaseDatabase productBaseDatabase =
      FirebaseDatabase(collection_name: 'product-history-products');

  // Get stream of product history
  static Stream<QuerySnapshot<Map<String, dynamic>>> getProductHistory() {
    return baseDatabase.getSnapshots();
  }

  // Insert product history
  static Future<String> insertProductHistory(
      ProductHistory product_history) async {
    await baseDatabase.insertDoc(product_history).then((id) {
      product_history.products.forEach((product) {
        product.product_history_id = id;
        productBaseDatabase.insertDoc(product);
      });
    });

    return "";
  }

  // Update product history
  static Future<void> updateProductHistory(ProductHistory product_history) {
    return baseDatabase.updateDoc(product_history);
  }

  // Delete product history
  static Future<void> deleteProductHistory(String id) {
    return baseDatabase.deleteDoc(id);
  }

  // Delete all docs in collection
  static Future<void> deleteAll() {
    return baseDatabase.collection.snapshots().forEach((stream) {
      stream.docs.forEach((doc) {
        deleteProductHistory(doc.id);
      });
    });
  }
}
