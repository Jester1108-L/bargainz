class Product {
  String? id = null;
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
}
