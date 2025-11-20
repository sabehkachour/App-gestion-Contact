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

    _db = await databaseFactoryFfi.openDatabase(path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            // Table users
            await db.execute('''
              CREATE TABLE IF NOT EXISTS users(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT,
                password TEXT,
                email TEXT
              )
            ''');
            // Table contacts avec structure simple
            await db.execute('''
              CREATE TABLE IF NOT EXISTS contacts(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                phone TEXT,
                email TEXT
              )
            ''');
          },
        ));
  }

  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    try {
      final results = await _db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );
      if (results.isNotEmpty) return results.first;
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      return await _db.insert('users', user);
    } catch (e) {
      print('Error inserting user: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getContacts() async {
    try {
      return await _db.query('contacts', orderBy: 'name ASC');
    } catch (e) {
      print('Error getting contacts: $e');
      return [];
    }
  }

  Future<int> insertContact(Map<String, dynamic> contact) async {
    try {
      return await _db.insert('contacts', contact);
    } catch (e) {
      print('Error inserting contact: $e');
      return -1;
    }
  }

  Future<int> updateContact(Map<String, dynamic> contact) async {
    try {
      return await _db.update('contacts', contact,
          where: 'id = ?', whereArgs: [contact['id']]);
    } catch (e) {
      print('Error updating contact: $e');
      return -1;
    }
  }

  Future<int> deleteContact(int id) async {
    try {
      return await _db.delete('contacts', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting contact: $e');
      return -1;
    }
  }
}