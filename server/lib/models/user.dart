class User {
  int id;
  String name;
  String email;
  DateTime joinedAt;

  User({
    required this.email,
    required this.id,
    required this.name,
    required this.joinedAt,
  });

  // Convert a User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }

  // Create a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }
}
