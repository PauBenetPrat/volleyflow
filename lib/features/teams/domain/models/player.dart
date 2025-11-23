import 'player_position.dart';

enum PlayerGender {
  male,
  female,
}

class Player {
  final String id;
  final String name;
  final String? alias;
  final int? number;
  final int? age;
  final double? height; // in cm
  final PlayerPosition? mainPosition;
  final bool isCaptain;
  final PlayerGender? gender;

  Player({
    required this.id,
    required this.name,
    this.alias,
    this.number,
    this.age,
    this.height,
    this.mainPosition,
    this.isCaptain = false,
    this.gender,
  });

  Player copyWith({
    String? id,
    String? name,
    String? alias,
    int? number,
    int? age,
    double? height,
    PlayerPosition? mainPosition,
    bool? isCaptain,
    PlayerGender? gender,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      alias: alias ?? this.alias,
      number: number ?? this.number,
      age: age ?? this.age,
      height: height ?? this.height,
      mainPosition: mainPosition ?? this.mainPosition,
      isCaptain: isCaptain ?? this.isCaptain,
      gender: gender ?? this.gender,
    );
  }

  String getInitials() {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'alias': alias,
      'number': number,
      'age': age,
      'height': height,
      'mainPosition': mainPosition?.name,
      'isCaptain': isCaptain,
      'gender': gender?.name,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      alias: json['alias'] as String?,
      number: json['number'] as int?,
      age: json['age'] as int?,
      height: (json['height'] as num?)?.toDouble(),
      mainPosition: json['mainPosition'] != null
          ? PlayerPosition.values.firstWhere(
              (e) => e.name == json['mainPosition'],
              orElse: () => PlayerPosition.attack,
            )
          : null,
      isCaptain: json['isCaptain'] as bool? ?? false,
      gender: json['gender'] != null
          ? PlayerGender.values.firstWhere(
              (e) => e.name == json['gender'],
              orElse: () => PlayerGender.male,
            )
          : null,
    );
  }
}

