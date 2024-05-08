class UserModel {
  final String userId;
  final String email;
  final String name;
  final String profile;

  UserModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.profile,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        email = json['email'],
        name = json['name'],
        profile = json['profile'];

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'profile': profile,
    };
  }
}
