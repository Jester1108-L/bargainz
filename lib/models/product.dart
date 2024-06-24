class Product {
  String? id = null;
  final String barcode;
  final String name;
  final String description;
  final String category;
  final String retailer;

  Product(
      {required this.barcode,
      required this.name,
      required this.description,
      required this.category,
      required this.retailer,
      this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'description': description,
      'category': category,
      'retailer': retailer,
    };
  }
}
