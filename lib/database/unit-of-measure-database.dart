import 'package:bargainz/database/firebase-database.dart';
import 'package:bargainz/models/unit-of-measure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Database class for unit of measure operations
class UnitsOfMeasureDatabase {
  static final FirebaseDatabase baseDatabase = FirebaseDatabase(collection_name: 'unitsofmeasure');

  // Get stream of units of measure
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUnitsOfMeasure() {
    return baseDatabase.getSnapshots();
  }

  // Insert unit of measure
  static Future<String> insertUnitOfMeasure(UnitOfMeasure unit_of_measure) async {
    return await baseDatabase.insertDoc(unit_of_measure);
  }

  // Update unit of measure
  static Future<void> updateUnitOfMeasure(UnitOfMeasure unit_of_measure) {
    return baseDatabase.updateDoc(unit_of_measure);
  }

  // Delete unit of measure
  static Future<void> deleteUnitOfMeasure(String id) {
    return baseDatabase.deleteDoc(id);
  }
}
