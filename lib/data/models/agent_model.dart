import 'package:easyrent/data/models/propertyModel.dart';

class Agent {
  final int id;
  final String name;
  final String photo;
  final double rating;
  final String phone; // 👈 Add phone number
  final List<PropertyModel> properties;

  Agent({
    required this.id,
    required this.name,
    required this.photo,
    required this.rating,
    required this.phone,
    required this.properties,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      rating: (json['rating'] ?? 0).toDouble(),
      phone: json['phone'] ?? "", // parse phone number
      properties: (json['properties'] as List<dynamic>?)
              ?.map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
