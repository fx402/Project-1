import 'package:flutter/foundation.dart';
import 'package:project_alfin/data/preferencs/auth_pref.dart';
import 'package:project_alfin/models/auth_model.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLogin = false;
  AuthModel? _user;
  late AuthPref _authPref;

  AuthProvider() {
    _authPref = AuthPref();
  }

  dynamic get isLogin async {
    _isLogin = await _authPref.isLogin();
    return _isLogin;
  }


  setUser(AuthModel user) async {
    final saveUSer = await _authPref.setPrefUser(user);
    return saveUSer;
  }

  void getUser() async {
    _user = await _authPref.getPrefUser();
    notifyListeners();
  }

  AuthModel? get user {
    return _user;
  }

  dynamic deleteUSer() async {
    return await _authPref.deletePrefUser();
  }
}
