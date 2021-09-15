class Place {
  final int id;
  final String name;
  final String type;
  final String address;
  final String city;
  final String neighborhood;
  final String zipCode;
  final String placeWithoutZipCode;

  Place({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.city,
    required this.neighborhood,
    required this.zipCode,
    required this.placeWithoutZipCode,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        id: json['id'] as int,
        name: json['name'] as String,
        type: json['type'] as String,
        address: json['address'] as String,
        city: json['city'] as String,
        neighborhood: json['neighborhood'] as String,
        zipCode: json['zipCode'] as String,
        placeWithoutZipCode: json['placeWithoutZipCode'] as String);
  }
}
