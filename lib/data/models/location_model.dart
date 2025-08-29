class Location {
  final String? country;
  final String? governorate;
  final String? city;
  final String? quarter;
  final String? street;
  final double? lat;
  final double? lon;

  Location({
    required this.country,
    required this.governorate,
    required this.city,
    required this.quarter,
    required this.street,
    required this.lat,
    required this.lon,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      country: json['country'],
      governorate: json['governorate'],
      city: json['city'],
      quarter: json['quarter'],
      street: json['street'],
      lat: json['lat']??0.0,
      lon: json['lon']??0.0,
    );
  }
}
