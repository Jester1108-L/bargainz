import 'package:bargainz/models/base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Class containing category details
class Category implements Base {
  @override
  String? id;
  final String name;
  final String unit_of_measure;

  Category({required this.name, this.id, required this.unit_of_measure});

  Category.empty({this.name = "", this.id, this.unit_of_measure = ""});

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit_of_measure': unit_of_measure,
    };
  }

  static Category toObject(Map<String, dynamic> map) {
    return Category(
        name: map['name'] ?? '',
        unit_of_measure: map['unit_of_measure'] ?? '',
        id: map['id'] ?? '');
  }

  static Category toObjectWithSnapshot(DocumentSnapshot doc) {
    return Category(
        name: doc['name'] ?? '',
        unit_of_measure: doc['unit_of_measure'] ?? '',
        id: doc.id);
  }
}
