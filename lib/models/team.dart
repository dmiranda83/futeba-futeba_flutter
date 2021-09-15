import 'package:futeba/models/category.dart';
import 'package:futeba/models/place.dart';
import 'package:futeba/models/players.dart';

class Team {
  final int id;
  final String name;
  final String away;
  final String responsibleName;
  final String phoneContact1;
  final String phoneContact2;
  final Category category;
  final Place place;
  final List<Player> players;

  Team({
    required this.id,
    required this.name,
    required this.away,
    required this.responsibleName,
    required this.phoneContact1,
    required this.phoneContact2,
    required this.category,
    required this.place,
    required this.players,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    var list = json['players'] as List;
    List<Player> playersList =
        list.map((players) => Player.fromJson(players)).toList();
    return Team(
        id: json['id'],
        name: json['name'],
        away: json['away'],
        responsibleName: json['responsibleName'],
        phoneContact1: json['phoneContact1'],
        phoneContact2: json['phoneContact2'],
        category: Category.fromJson(json['category']),
        place: Place.fromJson(json['place']),
        players: playersList);
  }
}
