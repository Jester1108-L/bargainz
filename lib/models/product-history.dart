import 'package:bargainz/models/base.dart';
import 'package:bargainz/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Class containing retailer details
class ProductHistory implements Base {
  @override
  String? id;
  String? created = DateTime.now().toString();
  List<Product> products = [];

  ProductHistory({required this.created, this.id});

  ProductHistory.empty({this.id});

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created,
    };
  }

  static ProductHistory toObject(Map<String, dynamic> map) {
    return ProductHistory(created: map['created'] ?? DateTime.now().toString(), id: map['id'] ?? '');
  }

  static ProductHistory toObjectWithSnapshot(DocumentSnapshot doc) {
    return ProductHistory(created: doc['created'] ?? DateTime.now().toString(), id: doc.id);
  }
}
