import 'dart:io';

import 'package:grass/models/habit.dart';
import 'package:grass/models/habit_record.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseModel {
  int id;

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is BaseModel &&
    runtimeType == other.runtimeType &&
    id == other.id;

  @override
  int get hashCode => id.hashCode;

  BaseModel(this.id);
}

class DbHelper {
  factory DbHelper() => _getInstance();
  static DbHelper get instance => _getInstance();
  static DbHelper _instance;

  static DbHelper _getInstance() {
    if (_instance == null) {
      _instance = DbHelper._internal();
    }
    return _instance;
  }

  bool _didInit = false;
  Database _database;

  DbHelper._internal();

  Future<Database> getDb() async {
    if (!_didInit) await _init();
    return _database;
  }

  Future<void> close() async {
    if (_didInit && _database != null) {
      _database.close();
      _didInit = false;
    }
  }

  Future<Map<String, dynamic>> save(Map<String, dynamic> json, {String tableName}) async {
    final db = await DbHelper.instance.getDb();
    if (json['id'] == null) {
      json['id'] = await db.insert(tableName, json);
    } else {
      await db.update(
        tableName,
        json,
        where: 'id = ?',
        whereArgs: [json['id']],
      );
    }
    return json;
  }

  Future<int> delete(int id, {String tableName}) async {
    final db = await DbHelper.instance.getDb();
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'grass.db');
    print('数据库地址：$path');
    _database = await openDatabase(
      path, 
      version: 1,
      onCreate: (Database db, int version) async {
        await _createHabitTable(db);
        await _createHabitRecordTable(db);
      }, 
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await db.execute("DROP TABLE ${Habit.tableName}");
        await db.execute("DROP TABLE ${HabitRecord.tableName}");

        await _createHabitTable(db);
        await _createHabitRecordTable(db);
      },
    );
    _didInit = true;
  }

  Future _createHabitTable(Database db) {
    return db.transaction((Transaction txn) async {
      txn.execute("CREATE TABLE ${Habit.tableName} ("
          "${Habit.fieldId} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${Habit.fieldName} TEXT,"
          "${Habit.fieldRemarks} TEXT,"
          "${Habit.fieldRepeatStatusType} TEXT,"
          "${Habit.fieldRepeatSxtatusValues} TEXT,"
          "${Habit.fieldStartDate} INTEGER,"
          "${Habit.fieldAlertTime} INTEGER,"
          "${Habit.fieldIsArchived} INTEGER,"
          "${Habit.fieldCreatedDate} INTEGER,"
          "${Habit.fieldUpdatedDate} INTEGER);"
      );
    });
  }

  Future _createHabitRecordTable(Database db) {
    return db.transaction((Transaction txn) async {
      txn.execute("CREATE TABLE ${HabitRecord.tableName} ("
          "${HabitRecord.fieldId} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${HabitRecord.fieldHabitId} INTEGER,"
          "${HabitRecord.fieldIsDone} INTEGER,"
          "${HabitRecord.fieldCreatedDate} INTEGER,"
          "${HabitRecord.fieldUpdatedDate} INTEGER);"
      );
    });
  }
}
