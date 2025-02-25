import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create Tables (Users + Properties)**
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY, 
        name TEXT,
        email TEXT,
        phoneNumber TEXT,
        isAdmin INTEGER, -- 1 = Admin, 0 = Tenant
        profilePictureUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE property_images(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        propertyId TEXT,
        imageUrl TEXT NOT NULL
      )
    ''');
  }

  // Upgrade Database Schema**
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE property_images(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          propertyId TEXT,
          imageUrl TEXT NOT NULL
        )
      ''');
    }
  }

  // --------------------------------
  // USER MANAGEMENT FUNCTIONS
  // --------------------------------

  Future<void> insertOrUpdateUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final db = await database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [userId], limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.update('users', user, where: 'id = ?', whereArgs: [user['id']]);
  }

  Future<void> deleteUser(String userId) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('users');
    await db.delete('property_images');
  }

  // --------------------------------
  //  PROPERTY IMAGE MANAGEMENT
  // --------------------------------

  // Insert Image URL into SQLite
  Future<void> insertPropertyImage(String propertyId, String imageUrl) async {
    final db = await database;
    await db.insert('property_images', {'propertyId': propertyId, 'imageUrl': imageUrl});
  }

  // Get All Images for a Specific Property
  Future<List<String>> getPropertyImages(String propertyId) async {
    final db = await database;
    final result = await db.query('property_images', where: 'propertyId = ?', whereArgs: [propertyId]);
    return result.map((row) => row['imageUrl'] as String).toList();
  }

  // Delete Images for a Property
  Future<void> deletePropertyImages(String propertyId) async {
    final db = await database;
    await db.delete('property_images', where: 'propertyId = ?', whereArgs: [propertyId]);
  }
}
