import 'package:bargainz/models/base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Class containing retailer details
class Retailer implements Base {
  @override
  String? id;
  final String name;

  Retailer({required this.name, required this.id});

  Retailer.empty({this.name = "", this.id});

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Retailer toObject(Map<String, dynamic> map) {
    return Retailer(name: map['name'] ?? '', id: map['id'] ?? '');
  }

  static Retailer toObjectWithSnapshot(DocumentSnapshot doc) {
    return Retailer(name: doc['name'] ?? '', id: doc.id);
  }
}
