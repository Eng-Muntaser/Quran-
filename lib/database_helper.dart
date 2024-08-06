import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE settings (
      id INTEGER PRIMARY KEY,
      language TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE favorites (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      reciterId TEXT,
      moshafId TEXT
    )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      var tableExist = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='favorites'");
      if (tableExist.isEmpty) {
        await db.execute('''
        CREATE TABLE favorites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          reciterId TEXT,
          moshafId TEXT
        )
        ''');
      } else {
        await db.execute('''
        ALTER TABLE favorites ADD COLUMN moshafId TEXT;
        ''');
      }
    }
  }

  Future<void> saveLanguage(String language) async {
    final db = await instance.database;

    await db.insert(
      'settings',
      {'id': 1, 'language': language},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getLanguage() async {
    final db = await instance.database;

    final maps = await db.query(
      'settings',
      columns: ['language'],
      where: 'id = ?',
      whereArgs: [1],
    );

    if (maps.isNotEmpty) {
      return maps.first['language'] as String?;
    } else {
      return null;
    }
  }

  Future<void> addFavorite(String reciterId, String moshafId) async {
    final db = await instance.database;

    await db.insert(
      'favorites',
      {'reciterId': reciterId, 'moshafId': moshafId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    print("Added to database: $reciterId with moshafId: $moshafId");
  }

  Future<void> removeFavorite(String reciterId, String moshafId) async {
    final db = await instance.database;

    await db.delete(
      'favorites',
      where: 'reciterId = ? AND moshafId = ?',
      whereArgs: [reciterId, moshafId],
    );
  }

  Future<List<Map<String, String>>> getFavorites() async {
    final db = await instance.database;

    final maps = await db.query('favorites');

    if (maps.isNotEmpty) {
      return maps
          .map((map) => {
                'reciterId': map['reciterId'] as String,
                'moshafId': map['moshafId'] as String
              })
          .toList();
    } else {
      return [];
    }
  }
}
