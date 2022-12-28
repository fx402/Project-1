import 'package:project_alfin/models/user_model.dart';
import 'package:project_alfin/models/user_pref.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static late Database _database;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  static const String _tableName = 'user';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'user_db.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableName (
               id INTEGER PRIMARY KEY,
               name TEXT, email TEXT, password TEXT, isLogin INTEGER, poin INTEGER
             )''',
        );
      },
      version: 1,
    );

    return db;
  }

  Future<void> insertUser(UserPref userModel) async {
    final Database db = await database;
    await db.insert(_tableName, userModel.toMap());
    print('Data saved');
  }

  Future<List<UserPref>> getUsers() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);

    return results.map((res) => UserPref.fromMap(res)).toList();
  }

  Future<UserPref> getUserById(int id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.map((res) => UserPref.fromMap(res)).first;
  }

  Future<void> updateUser(UserPref userModel) async {
    final db = await database;

    await db.update(
      _tableName,
      userModel.toMap(),
      where: 'id = ?',
      whereArgs: [userModel.id],
    );
  }

  Future<void> deleteUser() async {
    final db = await database;

    await db.execute("delete * from " + _tableName
    );
  }
}