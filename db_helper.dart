import 'notification_id.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'dart:async';

final String tableNotification = 'app_notification';
final String columnId = 'id';
final String notificationId = 'noteId';

class DBHelper {
  static Database? _database;
  static DBHelper? _dbHelper;

  DBHelper._createInstance();
  factory DBHelper() {
    _dbHelper ??= DBHelper._createInstance();
    return _dbHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var dbPath = path.join(dir,"notification.db");

    var database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableNotification ( 
          $columnId integer primary key autoincrement, 
          $notificationId integer not null
         )
        ''');
      },
    );
    // var result = await database.query('sqlite_master', columns: ['type', 'name']);
    // result.forEach((element) { print(element.values); });
    return database;
  }

  void insertNotification(NotificationID noteId) async {
    var db = await database;
    var result = await db.rawInsert("INSERT INTO $tableNotification($notificationId) VALUES(${noteId.id})");
    print('result : $result');
  }

  Future<List<NotificationID>> getNotifications() async {
    List<NotificationID> _notifications = [];

    var db = await database;
    var result = await db.rawQuery("SELECT * FROM $tableNotification");
    result.forEach((element) {
      var notificationId = NotificationID.fromJson(element);
      _notifications.add(notificationId);
    });

    return _notifications;
  }

  Future<int> delete(int? id) async {
    var db = await database;
    return await db.delete(tableNotification, where: '$columnId = ?', whereArgs: [id]);
  }
}

