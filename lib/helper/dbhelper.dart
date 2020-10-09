import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_sqli/helper/client_helper.dart';

class DatabaseHlper {
  static final _dbname = "mydb.db";
  static final _version = 1;
  static final _tablename = 'myTable';
  static final _columnId = 'id';
  static final _columnname = 'name';
  DatabaseHlper._privateConstructor();
  static final instance = DatabaseHlper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initiateDatabase();
    }
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationSupportDirectory();
    String path = join(directory.path, _dbname);
    return await openDatabase(path, version: _version, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    db.execute('''
CREATE TABLE $_tablename(
$_columnId INTEGER PRIMARY KEY,
$_columnname TEXT NOT NULL
)
''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tablename, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tablename);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[_columnId];
    return db.update(_tablename, row, where: '$_columnId=?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return db.delete(_tablename, where: "$_columnId=$id");
  }
}
