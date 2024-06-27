import 'package:bargainz/models/base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Class containing unit of measure details
class UnitOfMeasure implements Base {
  @override
  String? id;
  final String name;
  final String code;

  UnitOfMeasure({required this.name, required this.id, required this.code});

  UnitOfMeasure.empty({this.name = "", this.id, this.code = ""});

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }

  static UnitOfMeasure toObject(Map<String, dynamic> map) {
    return UnitOfMeasure(
        name: map['name'] ?? '', code: map['code'] ?? '', id: map['id'] ?? '');
  }

  static UnitOfMeasure toObjectWithSnapshot(DocumentSnapshot doc) {
    return UnitOfMeasure(
        name: doc['name'] ?? '', code: doc['code'] ?? '', id: doc.id);
  }
}
