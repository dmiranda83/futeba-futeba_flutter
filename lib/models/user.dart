import 'package:futeba/models/team.dart';

class User {
  final int id;
  final String name;
  final String cellPhone;
  final String changePassword;
  final String active;
  final String role;
  final List<Team> teams;

  User({
    required this.id,
    required this.name,
    required this.cellPhone,
    required this.changePassword,
    required this.active,
    required this.role,
    required this.teams,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var list = json['teams'] as List;
    List<Team> teamsList = list.map((teams) => Team.fromJson(teams)).toList();
    return User(
        id: json['id'],
        name: json['name'],
        cellPhone: json['cellPhone'],
        changePassword: json['changePassword'],
        active: json['active'],
        role: json['role'],
        teams: teamsList);
  }
}
