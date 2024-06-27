import 'package:bargainz/database/firebase-database.dart';
import 'package:bargainz/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Database class for category operations
class CategoryDatabase {
  static final FirebaseDatabase baseDatabase = FirebaseDatabase(collection_name: 'categories');

  // Get stream of categories
  static Stream<QuerySnapshot<Map<String, dynamic>>> getCategories() {
    return baseDatabase.getSnapshots();
  }

  // Insert category
  static Future<String> insertCategory(Category category) async {
    return await baseDatabase.insertDoc(category);
  }

  // Update category
  static Future<void> updateCategory(Category category) {
    return baseDatabase.updateDoc(category);
  }

  // Delete category
  static Future<void> deleteCategory(String id) {
    return baseDatabase.deleteDoc(id);
  }
}
