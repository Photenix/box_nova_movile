class UserModel {
  String? nickname, email, firstName, lastName;

  UserModel({ required this.nickname, required this.email, required this.firstName, required this.lastName});

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'email': email,
      'first_name': firstName,
      'last_name': lastName
    };
  }
}