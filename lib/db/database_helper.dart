import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static Database? _db;

  DatabaseHelper() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi; // initialisation pour Windows
  }

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = await databaseFactory.getDatabasesPath() + '/contact.db';
    return await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE users(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                email TEXT UNIQUE,
                phone TEXT
              )
            ''');
          },
        ));
  }

  Future<bool> userExists(String email) async {
    final database = await db;
    final res =
        await database.rawQuery('SELECT * FROM users WHERE email = ?', [email]);
    return res.isNotEmpty;
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    final database = await db;
    await database.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final database = await db;
    return database.query('users');
  }
}
