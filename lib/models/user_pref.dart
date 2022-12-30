class UserPref {
  int id;
  String name;
  String password;
  String email;
  int isLogin;
  int? poin;

  UserPref({required this.id, required this.name,
    required this.password,
    required this.isLogin,
    required this.email, this.poin});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'isLogin': isLogin,
      'email': email,
      'poin': poin as int?,
    };
  }

  factory UserPref.fromMap(Map<String, dynamic> map)=> UserPref(
      id : map['id'],
      name : map['name'],
      password : map['password'],
      email : map['email'],
      isLogin : map['isLogin'],
      poin : map['poin'],
  );

}