class Coach {
  final String id;
  final String name;
  final bool isPrimary;

  Coach({
    required this.id,
    required this.name,
    this.isPrimary = true,
  });

  Coach copyWith({
    String? id,
    String? name,
    bool? isPrimary,
  }) {
    return Coach(
      id: id ?? this.id,
      name: name ?? this.name,
      isPrimary: isPrimary ?? this.isPrimary,
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
      'isPrimary': isPrimary,
    };
  }

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'] as String,
      name: json['name'] as String,
      isPrimary: json['isPrimary'] as bool? ?? true,
    );
  }
}

