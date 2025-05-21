import 'package:bootcamp_proje/data/entity/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE toDos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');
  }

  Future<int> insertToDo(ToDo todo) async {
    final db = await database;
    return await db.insert('toDos', todo.toMap());
  }

  Future<List<ToDo>> getToDos({String? query}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;
    if (query != null && query.isNotEmpty) {
      maps = await db.query('toDos', where: 'name LIKE ?', whereArgs: ['%$query%']);
    } else {
      maps = await db.query('toDos');
    }
    return List.generate(maps.length, (i) => ToDo.fromMap(maps[i]));
  }

  Future<int> deleteToDo(int id) async {
    final db = await database;
    return await db.delete('toDos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateToDo(ToDo todo) async {
    final db = await database;
    return await db.update('toDos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  
}