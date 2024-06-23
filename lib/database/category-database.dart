import 'package:bargainz/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryDatabase {
  static final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('categories');

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCategories() {
    return _collection.snapshots();
  }

  static Future<String> insertCategory(Category category) async {
    return await _collection.add(category.toMap()).then((docRef) {
      return docRef.id;
    });
  }

  static Future<void> updateCategory(Category category) {
    return _collection.doc(category.id).set(category.toMap());
  }

  static void deleteCategory(String id) {
    _collection.doc(id).delete();
  }
}
