import 'package:easyrent/data/models/propertyModel.dart';

class Agent {
  final int id;
  final String name;
  final String photo;
  final double rating;
  final List<PropertyModel> properties; // 👈 Add this

  Agent({
    required this.id,
    required this.name,
    required this.photo,
    required this.rating,
    required this.properties,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      rating: (json['rating'] ?? 0).toDouble(),
      properties: (json['properties'] as List<dynamic>?)
              ?.map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [], 
    );
  }
}
