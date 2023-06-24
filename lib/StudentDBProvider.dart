import 'package:flutter_database_sqflite_riverpod/DBProvider.dart';
import 'package:sqflite/sqflite.dart';

import 'Student.dart';

class StudentDBProvider {
  static const String tableName = 'Student';
  static const String keyName = 'name';
  static const String keyRollNo = 'rollNo';
  static const String keyFee = 'fee';
  static const String createTable =
      'CREATE TABLE $tableName($keyRollNo INTEGER PRIMARY KEY,$keyName TEXT,$keyFee REAL)';

  Future<bool> insert({required Student student}) async {
    Database db = await DBProvider.database;
    int rowId = await db.insert(tableName, student.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return rowId > 0;
  }

  Future<List<Student>> fetch() async {
    Database db = await DBProvider.database;
    List<Map<String, dynamic>> studentList = await db.query(
      tableName,
    );
    return studentList.map((e) => Student.fromMap(e)).toList();
  }

  Future<bool> delete(int rollNo) async {
    Database db = await DBProvider.database;
    int rowId = await db
        .delete(tableName, where: '$keyRollNo = ?', whereArgs: [rollNo]);
    return rowId > 0;
  }

  Future<bool> update({required Student student}) async {
    Database db = await DBProvider.database;
    int rowId = await db.update(
      tableName,
      student.toMap(),
      where: '$keyRollNo = ?',
      whereArgs: [student.rollNo],
    );
    return rowId > 0;
  }
}
