// Base class for entity models
abstract class Base {
  String? id;

  // Convert object into map
  Map<String, dynamic> toMap();
  // Convert map into object
  // Base toObject(Map<String, dynamic> map);
}