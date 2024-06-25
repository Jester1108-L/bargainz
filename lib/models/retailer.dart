class Retailer {
  final String id;
  final String name;

  Retailer({required this.name, required this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}