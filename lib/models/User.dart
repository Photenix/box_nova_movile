class UserModel {
  String? id, nickname, email, firstName, lastName;

  UserModel({ required this.id, required this.nickname, required this.email, required this.firstName, required this.lastName});

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'email': email,
      'first_name': firstName,
      'last_name': lastName
    };
  }
}