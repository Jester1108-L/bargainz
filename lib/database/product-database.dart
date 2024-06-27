import 'package:bargainz/database/firebase-database.dart';
import 'package:bargainz/database/product-history-database.dart';
import 'package:bargainz/models/product-history.dart';
import 'package:bargainz/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Database class for product operations
class ProductDatabase {
  static FirebaseDatabase baseDatabase =
      FirebaseDatabase(collection_name: 'products');
  static final FirebaseDatabase productHistoryBase =
      FirebaseDatabase(collection_name: 'product-history-products');

  // Get stream of units of measure
  static Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return baseDatabase.getSnapshots();
  }

  // Get listing of products in collection
  static Future<List<Product>> getProductListing() async {
    return await baseDatabase.collection.get().then((snapshot) {
      return snapshot.docs
          .map((el) => Product.toObjectWithSnapshot(el))
          .toList();
    });
  }

  // Get product with barcode
  static Future<Product> getProduct(String barcode) async {
    return await baseDatabase.collection.get().then((snapshot) {
      List<Product> products = snapshot.docs
          .map((el) => Product.toObjectWithSnapshot(el))
          .where((el){return el.barcode == barcode;})
          .toList();

      return products.isEmpty ? Product.empty() : products[0];
    });
  }

  // Get listing of products in collection
  static Future<List<Product>> getProductHistoryListing(
      {required String history_id}) async {
    return await productHistoryBase.collection.get().then((snapshot) {
      return snapshot.docs
          .map((el) => Product.toObjectWithSnapshot(el))
          .where((product) => (product.product_history_id == history_id))
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
  static Future<void> deleteAll() async {
    ProductHistory product_history =
        ProductHistory(created: DateTime.now().toString());

    product_history.products = await getProductListing();

    if (product_history.products.isNotEmpty) {
      await ProductHistoryDatabase.insertProductHistory(product_history);
    }

    for (Product product in product_history.products) {
        await deleteProduct(product.id ?? "");
    }
  }
}
