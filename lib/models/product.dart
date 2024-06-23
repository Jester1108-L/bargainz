class Product {
  final String id;
  final String barcode;

  Product({required this.barcode, required this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
    };
  }
}