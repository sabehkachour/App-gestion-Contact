import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  late Database _db;

  factory DatabaseHelper() => _instance ??= DatabaseHelper._internal();
  DatabaseHelper._internal();

  Future<void> initDb() async {
    sqfliteFfiInit();
    var databasesPath = await databaseFactoryFfi.getDatabasesPath();
    String path = join(databasesPath, 'contacts.db');

    _db = await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE IF NOT EXISTS users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT,
            email TEXT
          )
        ''');

          await db.execute('''
          CREATE TABLE IF NOT EXISTS contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            phone TEXT,
            email TEXT
          )
        ''');
        },
      ),
    );
  }

  // USERS
  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final results = await _db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    return await _db.insert('users', user);
  }

  // CONTACTS
  Future<List<Map<String, dynamic>>> getContacts() async {
    return await _db.query('contacts', orderBy: 'name ASC');
  }

  Future<int> insertContact(Map<String, dynamic> contact) async {
    return await _db.insert('contacts', contact);
  }

  Future<int> updateContact(int id, Map<String, dynamic> contactData) async {
    return await _db.update(
      'contacts',
      contactData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteContact(int id) async {
    return await _db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}