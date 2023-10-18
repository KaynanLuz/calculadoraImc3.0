import 'package:myappcalculadoraimc/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final pathToDatabase = path.join(databasePath, 'imc_database.db');

    return await openDatabase(pathToDatabase, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE imc_results(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        weight REAL,
        height REAL,
        imc REAL,
        classification TEXT
      )
    ''');
  }

  Future<int> insertIMCResult(IMCResult result) async {
    final db = await database;
    return await db.insert('imc_results', result.toMap());
  }

  Future<List<IMCResult>> getIMCResults() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('imc_results');
    return List.generate(maps.length, (i) {
      return IMCResult.fromMap(maps[i]);
    });
  }
}