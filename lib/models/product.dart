import 'package:bargainz/models/base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Class containing product details
class Product implements Base {
  @override
  String? id;
  final String barcode;
  final String name;
  final String description;
  final String category;
  final String retailer;
  final String unit_of_measure;
  final double price;
  final double unit;

  Product(
      {required this.barcode,
      required this.name,
      required this.description,
      required this.category,
      required this.retailer,
      required this.price,
      required this.unit,
      required this.unit_of_measure,
      this.id});

  Product.empty(
      {this.barcode = '',
      this.name = '',
      this.description = '',
      this.category = '',
      this.retailer = '',
      this.price = 0,
      this.unit = 0,
      this.unit_of_measure = '',
      this.id});

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'description': description,
      'category': category,
      'retailer': retailer,
      'unit_of_measure': unit_of_measure,
      'price': price,
      'unit': unit,
    };
  }

  static Product toObject(Map<String, dynamic> map) {
    return Product(
        barcode: map['barcode'] ?? '',
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        category: map['category'] ?? '',
        retailer: map['retailer'] ?? '',
        unit_of_measure: map['unit_of_measure'] ?? '',
        price: double.parse(map['price']),
        unit: double.parse(map['unit']),
        id: map['id'] ?? '');
  }

  static Product toObjectWithSnapshot(DocumentSnapshot doc) {
    return Product(
        barcode: doc['barcode'] ?? '',
        name: doc['name'] ?? '',
        description: doc['description'] ?? '',
        category: doc['category'] ?? '',
        retailer: doc['retailer'] ?? '',
        unit_of_measure: doc['unit_of_measure'] ?? '',
        price: doc["price"],
        unit: doc["unit"],
        id: doc.id);
  }
}
