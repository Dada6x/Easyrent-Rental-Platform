import 'location_model.dart';

class OuterPropertyModel {
  final int? id;
  final int? rooms;
  final int? bathrooms;
  final double? price;
  final double? area;
  final String? firstImage;
  final Location? location;

  OuterPropertyModel({
    required this.id,
    required this.rooms,
    required this.bathrooms,
    required this.price,
    required this.area,
    required this.firstImage,
    required this.location,
  });

  factory OuterPropertyModel.fromJson(Map<String, dynamic> json) {
    return OuterPropertyModel(
      id: json['id'],
      rooms: json['rooms'],
      bathrooms: json['bathrooms'],
      price: json['price'] is! String
          ? (json['price'] as num).toDouble()
          : double.parse(json['price']),
      area: (json['area'] as num).toDouble(),
      firstImage: json['firstImage'],
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
    );
  }

  static List<OuterPropertyModel> propertiesFromSnapshot(List snapshot) {
    return snapshot.map((e) => OuterPropertyModel.fromJson(e)).toList();
  }
}
