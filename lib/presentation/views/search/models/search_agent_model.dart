// models/agent.dart
class SearchAgentModel {
  final int id;
  final String username;
  final String? phone;
  final String? profileImage;

  SearchAgentModel({
    required this.id,
    required this.username,
    this.phone,
    this.profileImage,
  });

  factory SearchAgentModel.fromJson(Map<String, dynamic> json) {
    return SearchAgentModel(
      id: json['id'],
      username: json['username'] ?? '',
      phone: json['phone'],
      profileImage: json['profileImage'],
    );
  }
}
