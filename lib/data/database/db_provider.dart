import 'package:flutter/foundation.dart';
import 'package:project_alfin/data/database/database_helper.dart';
import 'package:project_alfin/models/user_model.dart';
import 'package:project_alfin/models/user_pref.dart';

class DbProvider extends ChangeNotifier {
  List<UserPref> _users = [];

  late DatabaseHelper _dbHelper;

  List<UserPref> get users => _users;

  DbProvider() {
    _dbHelper = DatabaseHelper();
    _getAllUser();
  }
    void _getAllUser() async {
      _users = await _dbHelper.getUsers();
      notifyListeners();
    }
  Future<void> addUser(UserPref userPref) async {
    await _dbHelper.insertUser(userPref);
    _getAllUser();
  }
  Future<UserPref> getUserById(int id) async {
    return await _dbHelper.getUserById(id);
  }
  void updateUser(UserPref userModel) async {
    await _dbHelper.updateUser(userModel);
    _getAllUser();
  }

  void deleteUser() async {
    await _dbHelper.deleteUser();
    _getAllUser();
  }
}