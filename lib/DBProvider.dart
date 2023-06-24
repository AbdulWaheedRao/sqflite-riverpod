import 'package:flutter_database_sqflite_riverpod/StudentDBProvider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? db;
  static Future<Database> get database async {
    String pathDirectory = await getDatabasesPath();
    String path = join(pathDirectory, 'student.db');
    return db ??
        await openDatabase(
          path,
          version: 1,
          onCreate: (db, version) => db.execute(StudentDBProvider.createTable),
        );
  }
}
