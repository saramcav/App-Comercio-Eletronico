import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserHelper {
  static final _userHelper = UserHelper.internal();
  static Database? _db;
  static const String tableName = "user";

  UserHelper.internal();

  factory UserHelper() {
    return _userHelper;
  }

  Future<Database> get db async {
    _db ??= await initDb();
    return _db!;
  }

  _onCreateDb(Database db, int version) {

    String sql = """
    CREATE TABLE $tableName(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR NOT NULL,
      email VARCHAR NOT NULL,
      password VARCHAR NOT NULL
    );
    """;

    db.execute(sql);

  }

  initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "user2.db");

    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDb
    );

    return db;
  }
}