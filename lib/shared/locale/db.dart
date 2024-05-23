import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "chat.db");
    Database chat = await openDatabase(path, onCreate: _onCreate, version: 1);
    return chat;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE "sender" (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  sender_id INTEGER,
  receiver_id INTEGER,
  sender_img TEXT,
  receiver_img TEXT,
  the_end TEXT,
  end_seder TEXT,
  sender_name TEXT,
  receiver_name TEXT,
  count INTEGER,
)
''');
    await db.execute('''
CREATE TABLE "reciver" (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  sender_id INTEGER,
  receiver_id INTEGER,
  sender_img TEXT,
  receiver_img TEXT,
  the_end TEXT,
  end_seder TEXT,
  sender_name TEXT,
  receiver_name TEXT,
  count INTEGER,
)
''');
    await db.execute('''
CREATE TABLE "chat" (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  sender_id INTEGER,
  chat_id INTEGER,
  text TEXT,
  img TEXT,
)
''');
  }

  readData(String sql) async {
    Database? myDb = await db;
    List<Map> response = await myDb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? myDb = await db;
    int response = await myDb!.rawDelete(sql);
    return response;
  }
}
