class Position {
  final int id;
  final String name;

  Position({required this.id, required this.name});

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(id: json['id'] as int, name: json['name'] as String);
  }
}
