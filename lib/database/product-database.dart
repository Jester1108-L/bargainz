import 'package:bargainz/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDatabase {
  static final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('products');

  static Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return _collection.snapshots();
  }

  static Future<String> insertProduct(Product product) async {
    return await _collection.add(product.toMap()).then((docRef) {
      return docRef.id;
    });
  }

  static Future<void> updateProduct(Product product) {
    return _collection.doc(product.id).set(product.toMap());
  }

  static void deleteProduct(String id) {
    _collection.doc(id).delete();
  }
}
