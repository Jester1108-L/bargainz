class Category {
  String? id = null;
  final String name;
  final String unit_of_measure;

  Category({required this.name, this.id, required this.unit_of_measure});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit_of_measure': unit_of_measure,
    };
  }
}