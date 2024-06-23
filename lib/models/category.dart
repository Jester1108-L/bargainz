class Category {
  final String id;
  final String name;

  Category({required this.name, required this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}