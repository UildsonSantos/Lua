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
    final path = join(databasePath, 'file.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE files (
        id INTEGER PRIMARY KEY,
        path TEXT NOT NULL,
        fileCount INTEGER NOT NULL,
        folderCount INTEGER NOT NULL,
        isFavorite INTEGER NOT NULL,
        name TEXT
      )
    ''');
  }
}