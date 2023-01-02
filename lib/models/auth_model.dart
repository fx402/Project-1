class AuthModel {
  int id;
  String userName;
  String email;
  String password;
  int? poin;

  AuthModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.password,
    required this.poin,
  });
}
