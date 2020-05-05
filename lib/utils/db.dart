import 'dart:io';

import 'package:grass/models/habit.dart';
import 'package:grass/models/habit_record.dart';
import 'package:grass/models/motion_group_record.dart';
import 'package:grass/models/motion_record.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseModel<T> {
  int id;
  BaseModel(this.id);

  @override
  bool operator == (Object other) =>
    identical(this, other) ||
    other is BaseModel &&
    runtimeType == other.runtimeType &&
    id == other.id;

  @override
  int get hashCode => id.hashCode;

  String getTableName() {
    return '';
  }

  toJson();
  Future<void> preSave() async {}

  Future<int> save() async {
    final tableName = getTableName();
    if (tableName == '') {
      return -1;
    }
    
    final db = await DbHelper.instance.getDb();
    await preSave();
    final json = toJson();
    if (json['id'] == null) {
      return await db.insert(tableName, json);
    } else {
      await db.update(
        tableName,
        json,
        where: 'id = ?',
        whereArgs: [json['id']],
      );
      return json['id'];
    }
  }

  Future<int> delete() async {
    final tableName = getTableName();
    if (tableName == '') {
      return -1;
    }

    final db = await DbHelper.instance.getDb();
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
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

  bool _lock = false;
  bool _didInit = false;
  Database _database;

  DbHelper._internal();

  Future<Database> getDb() async {
    await _init();
    return _database;
  }

  Future<void> close() async {
    if (_didInit && _database != null) {
      _database.close();
      _didInit = false;
    }
  }

  Future _init() async {
    if (_didInit) {
      return;
    }

    if (_lock) {
      await Future.delayed(Duration(milliseconds: 100), () async => await _init());
      return;
    }

    _lock = true;
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'grass.db');
    print('数据库地址：$path');
    _database = await openDatabase(
      path, 
      version: 1,
      onCreate: (Database db, int version) async {
        await _createHabitTable(db);
        await _createHabitRecordTable(db);
        await _createMotionRecordTable(db);
        await _createMotionGroupRecordTable(db);
      }, 
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await db.execute('DROP TABLE ${Habit.tableName}');
        await db.execute('DROP TABLE ${HabitRecord.tableName}');
        await db.execute('DROP TABLE ${MotionRecord.tableName}');
        await db.execute('DROP TABLE ${MotionGroupRecord.tableName}');

        await _createHabitTable(db);
        await _createHabitRecordTable(db);
        await _createMotionRecordTable(db);
        await _createMotionGroupRecordTable(db);
      },
    );
    _lock = false;
    _didInit = true;
  }

  Future _createHabitTable(Database db) {
    return db.transaction((Transaction txn) async {
      txn.execute('CREATE TABLE ${Habit.tableName} ('
          '${Habit.fieldId} INTEGER PRIMARY KEY AUTOINCREMENT,'
          '${Habit.fieldName} TEXT,'
          '${Habit.fieldRemarks} TEXT,'
          '${Habit.fieldRepeatStatusType} TEXT,'
          '${Habit.fieldRepeatSxtatusValues} TEXT,'
          '${Habit.fieldStartDate} INTEGER,'
          '${Habit.fieldAlertTime} INTEGER,'
          '${Habit.fieldIsArchived} INTEGER,'
          '${Habit.fieldCreatedDate} INTEGER,'
          '${Habit.fieldUpdatedDate} INTEGER);'
      );
    });
  }

  Future _createHabitRecordTable(Database db) {
    return db.transaction((Transaction txn) async {
      txn.execute('CREATE TABLE ${HabitRecord.tableName} ('
          '${HabitRecord.fieldId} INTEGER PRIMARY KEY AUTOINCREMENT,'
          '${HabitRecord.fieldHabitId} INTEGER,'
          '${HabitRecord.fieldIsDone} INTEGER,'
          '${HabitRecord.fieldIsArchived} INTEGER,'
          '${HabitRecord.fieldCreatedDate} INTEGER,'
          '${HabitRecord.fieldUpdatedDate} INTEGER,'
          'FOREIGN KEY(${HabitRecord.fieldHabitId}) REFERENCES ${Habit.tableName}(${Habit.fieldId}) ON DELETE CASCADE);'
      );
    });
  }

  Future _createMotionRecordTable(Database db) {
    return db.transaction((Transaction txn) async {
      txn.execute('CREATE TABLE ${MotionRecord.tableName} ('
          '${MotionRecord.fieldId} INTEGER PRIMARY KEY AUTOINCREMENT,'
          '${MotionRecord.fieldMotionId} INTEGER,'
          '${MotionRecord.fieldHabitRecordId} INTEGER,'
          '${MotionRecord.fieldSortIndex} INTEGER,'
          'FOREIGN KEY(${MotionRecord.fieldHabitRecordId}) REFERENCES ${HabitRecord.tableName}(${HabitRecord.fieldId}) ON DELETE CASCADE);'
      );
    });
  }

  Future _createMotionGroupRecordTable(Database db) {
    return db.transaction((Transaction txn) async {
      txn.execute('CREATE TABLE ${MotionGroupRecord.tableName} ('
          '${MotionGroupRecord.fieldId} INTEGER PRIMARY KEY AUTOINCREMENT,'
          '${MotionGroupRecord.fieldMotionRecordId} INTEGER,'
          '${MotionGroupRecord.fieldContent} TEXT,'
          '${MotionGroupRecord.fieldIsDone} INTEGER,'
          '${MotionGroupRecord.fieldCreatedDate} INTEGER,'
          '${MotionGroupRecord.fieldUpdatedDate} INTEGER,'
          'FOREIGN KEY(${MotionGroupRecord.fieldMotionRecordId}) REFERENCES ${MotionRecord.tableName}(${MotionRecord.fieldId}) ON DELETE CASCADE);'
      );
    });
  }
}
