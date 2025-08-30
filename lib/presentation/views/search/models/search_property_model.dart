// models/property.dart
class SearchPropertyModel {
  final int id;
  final String title;
  final String price;
  final String? firstImage;
  final String? city;
  final int rooms;
  final int bathrooms;

  SearchPropertyModel({
    required this.id,
    required this.title,
    required this.price,
    this.firstImage,
    this.city,
    required this.rooms,
    required this.bathrooms,
  });

  factory SearchPropertyModel.fromJson(Map<String, dynamic> json) {
    return SearchPropertyModel(
      id: json['id'],
      title: json['title'] ?? '',
      price: json['price'] ?? '0',
      firstImage: json['firstImage'],
      city: json['location']?['city'],
      rooms: json['rooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
    );
  }
}
