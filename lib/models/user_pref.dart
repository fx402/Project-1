class UserPref {
  int? id;
  String name;
  String password;
  int isLogin;
  int poin;

  UserPref({this.id, required this.name,
    required this.password,
    required this.isLogin,
  required this.poin});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'isLogin': isLogin,
      'poin': poin,
    };
  }

  factory UserPref.fromMap(Map<String, dynamic> map)=> UserPref(
      id : map['id'],
      name : map['name'],
      password : map['password'],
      isLogin : map['isLogin'],
      poin : map['poin'],
  );

}