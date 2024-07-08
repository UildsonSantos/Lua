import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FileDatabase {
  static final FileDatabase instance = FileDatabase._internal();

  static Database? _database;

  FileDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'file_explorer.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE directories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      path TEXT NOT NULL,
      name TEXT,
      isFavorite INTEGER,
      type TEXT,
      parent_id TEXT
    )
    ''');
  }
}
