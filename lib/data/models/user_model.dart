import 'package:easyrent/data/models/location_model.dart';

class User {
  final int id;
  final String phone;
  final String username;
  final Location location;
  final int age;
  String userType;
  final bool isAccountVerified;
  final String? profileImage; 
  final int? planId; // nullable

  User({
    required this.id,
    required this.phone,
    required this.username,
    required this.location,
    required this.age,
    required this.userType,
    required this.isAccountVerified,
    this.profileImage,
    this.planId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phone: json['phone'],
      username: json['username'],
      location: Location.fromJson(json['location']),
      age: json['age'],
      userType: json['userType'],
      isAccountVerified: json['isAccountVerified'],
      profileImage: json['profileImage'], // could be null
      planId: json['plan']['id'], // could be null
    );
  }
}
