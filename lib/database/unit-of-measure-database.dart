import 'package:bargainz/models/unit-of-measure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UnitsOfMeasureDatabase {
  static final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('unitsofmeasure');

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUnitsOfMeasure() {
    return _collection.snapshots();
  }

  static Future<String> insertUnitOfMeasure(
      UnitOfMeasure unit_of_measure) async {
    return await _collection.add(unit_of_measure.toMap()).then((docRef) {
      return docRef.id;
    });
  }

  static Future<void> updateUnitOfMeasure(UnitOfMeasure unit_of_measure) {
    return _collection.doc(unit_of_measure.id).set(unit_of_measure.toMap());
  }

  static void deleteUnitOfMeasure(String id) {
    _collection.doc(id).delete();
  }
}
