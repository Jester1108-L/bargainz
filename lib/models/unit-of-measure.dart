class UnitOfMeasure {
  final String id;
  final String name;
  final String code;

  UnitOfMeasure({required this.name, required this.id, required this.code});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}