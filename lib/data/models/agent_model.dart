class Agent {
  final int id;
  final String name;
  final String photo;
  final double rating;

  Agent({
    required this.id,
    required this.name,
    required this.photo,
    required this.rating,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }
}


//! i think this shit need an list of properties :( 