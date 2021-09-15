class Place {
  final int id;
  final String name;
  final String type;
  final String address;
  final String city;
  final String neighborhood;
  final String zipCode;
  final bool placeWithoutZipCode;

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
        id: json['id'],
        name: json['name'],
        type: json['type'],
        address: json['address'],
        city: json['city'],
        neighborhood: json['neighborhood'],
        zipCode: json['zipCode'],
        placeWithoutZipCode: json['placeWithoutZipCode']);
  }
}
