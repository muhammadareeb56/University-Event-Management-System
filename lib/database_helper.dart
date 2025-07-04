import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        isAdmin INTEGER DEFAULT 0
      )
    ''');

    // In _createDB method, update the events table creation:
    await db.execute('''
  CREATE TABLE events (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    location TEXT,
    organizerId INTEGER,
    status TEXT DEFAULT 'pending', -- 'pending', 'approved', 'rejected'
    FOREIGN KEY (organizerId) REFERENCES users (id)
  )
''');


    // Create admin user
    await _createAdminUser(db);
  }

  Future<void> _createAdminUser(Database db) async {
    final admin = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: ['admin'],
      limit: 1,
    );

    if (admin.isEmpty) {
      await db.insert('users', {
        'username': 'admin',
        'password': 'admin123',
        'isAdmin': 1,
      });
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
