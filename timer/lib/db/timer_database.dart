import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timer/model/timers.dart';

class TimerDatabase {
  static final TimerDatabase instance = TimerDatabase._init();

  static Database? _database;

  TimerDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('timers.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableTimers ( 
  ${TimerFields.id} $idType, 
  ${TimerFields.title} $textType,
  ${TimerFields.duration} $textType
  )''');
  }

  Future<Timers> create(Timers timer) async {
    final db = await instance.database;

    // final json = timer.toJson();
    // final columns =
    //     '${TimerFields.title}, ${TimerFields.description}, ${TimerFields.time}';
    // final values =
    //     '${json[TimerFields.title]}, ${json[TimerFields.description]}, ${json[TimerFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableTimers, timer.toJson());

    return timer.copy(id: id);
  }

  Future<Timers> readTimers(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTimers,
      columns: TimerFields.values,
      where: '${TimerFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Timers.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Timers>> readAllTimers() async {
    final db = await instance.database;

    const orderBy = '${TimerFields.id} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableTimers, orderBy: orderBy);

    return result.map((json) => Timers.fromJson(json)).toList();
  }

  Future<int> update(Timers time) async {
    final db = await instance.database;

    return db.update(
      tableTimers,
      time.toJson(),
      where: '${TimerFields.id} = ?',
      whereArgs: [time.id],
    );
  }

  Future<int> delete(int? id) async {
    final db = await instance.database;
    db.delete(tableTimers, where: '${TimerFields.id} = ?', whereArgs: [id]);
    return await db.delete(
      tableTimers,
      where: '${TimerFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async {
    final db = await instance.database;

    return await db.delete(
      tableTimers,
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
