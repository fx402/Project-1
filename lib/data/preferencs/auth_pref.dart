import 'package:gatherash/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPref {
  Future<bool> setPrefUser(AuthModel user) async {
    final pref = await SharedPreferences.getInstance();
      final name = await pref.setString('userName', user.userName);
      final email = await pref.setString('email', user.email);
      final pass = await pref.setString('password', user.password);
      final poin = await pref.setInt('poin', user.poin!);
      final id = await pref.setInt('id', user.id);

    if (name && email && pass && id) return true;
    return false;
  }

  dynamic getPrefUser() async {
    return Future(() async {
      final pref = await SharedPreferences.getInstance();
      final name = pref.getString('userName');
      final email = pref.getString('email');
      final pass = pref.getString('password');
      final poin = pref.getInt('poin');
      final id = pref.getInt('id');

      if (name != null && email != null && pass != null && id != null) {
        return AuthModel(
          userName: name,
          email: email,
          password: pass,
          poin: poin,
          id: id
        );
      }
      return null;
    });
  }

  Future<dynamic> deletePrefUser() async {
    final pref = await SharedPreferences.getInstance();
    final name = await pref.remove('userName');
    final email = await pref.remove('email');
    final pass = await pref.remove('password');
    final poin = await pref.remove('poin');
    final id = await pref.remove('id');

    if (name && email && pass && poin && id) {
      return true;
    }
    return false;
  }

  Future<dynamic> isLogin() async {
    var currentUser = await getPrefUser();
    if (currentUser != null) {
      return true;
    }
    return false;
  }

  Future<String> validasiUser(String email) async {
    final pref = await SharedPreferences.getInstance();
    final emailPref = pref.getString('email');
    if (email != emailPref) {
      return 'Email tidak di temukan';
    }
    if (email == emailPref) {
      return 'Berhasil Login';
    }
    return '';
  }
}
