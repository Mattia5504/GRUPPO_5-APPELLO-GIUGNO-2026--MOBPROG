import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_tables.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();
  static const String _databaseName = 'planteat.db';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final databasesPath = await getDatabasesPath();
    final databasePath = join(databasesPath, _databaseName);

    return openDatabase(
      databasePath,
      version: _databaseVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute(DatabaseTables.createRecipes);
        await db.execute(DatabaseTables.createRecipeIngredients);
        await db.execute(DatabaseTables.createPantryItems);
        await db.execute(DatabaseTables.createMealPlanEntries);
        await db.execute(DatabaseTables.createShoppingItems);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }
}
