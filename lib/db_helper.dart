import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/utils/utils.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'moods.db'),
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE moods_table(
            date TEXT PRIMARY KEY,
            mood_name TEXT,
            mood_image TEXT,
            activity_names TEXT,
            activity_images TEXT,
            comments TEXT
          )'''
        );
      },
      version: 1
    );
  }

  static Future<void> insert(
    String table,
    Map<String, Object> data
  ) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data, // not sure how an entry is stored in data
      conflictAlgorithm: ConflictAlgorithm.replace 
    );
  }

  static Future<bool> doesDataExist(String date) async {
    final db = await DBHelper.database();
    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM moods_table WHERE date = ?)', [date]);
    int? count = firstIntValue(exists);
    return (count == 1); 
  }

  static Future<List<Map<String, dynamic>>> getData(String date) async {
    final db = await DBHelper.database();
    var res = await db.rawQuery(
      'SELECT * FROM moods_table WHERE date = ?',[date]);
    return res; // not sure why need .toList()
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DBHelper.database();
    var res = await db.rawQuery(
      "SELECT * FROM moods_table ORDER BY date DESC");
    return res.toList(); // not sure why need .toList()
  }

  static Future<void> delete(String date) async {
    final db = await DBHelper.database();
    await db.rawDelete(
      'DELETE FROM moods_table WHERE date = ?',[date]
    );
  }

  Future<void> deleteDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    databaseFactory.deleteDatabase(dbPath); //FOR DELETING ENTIRE DATABASE
  }
}