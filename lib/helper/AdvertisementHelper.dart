import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Advertisement.dart';

class AdvertisementHelper{
  static final _advertisementHelper = AdvertisementHelper.internal();
  static Database? _db;
  static final String tableName = "advertisement";

  AdvertisementHelper.internal();

  factory AdvertisementHelper() {
    return _advertisementHelper;
  }

  Future<Database> get db async {
    _db ??= await initDb();
    return _db!;
  }

  _onCreateDb(Database db, int version) {

    String sql = """
      CREATE TABLE advertisement(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        state VARCHAR(2) NOT NULL,
        category VARCHAR NOT NULL,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        telephone VARCHAR(20) NOT NULL,
        description TEXT NOT NULL,
        photo BLOB
      );
    """;

    db.execute(sql);

  }

  initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "advertisement.db");

    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDb
    );

    return db;
  }

  Future<int> insertAd(Advertisement advertisement) async{
    var database = await db;
    
    int result = await database.insert(tableName, advertisement.toMap());

    return result;

  }

  getAds() async {
    var database = await db;

    String sql = "SELECT * FROM $tableName";
    List advertisements = await database!.rawQuery(sql);

    return advertisements;
  }
  

  Future<int> deleteAd(int id) async {
    var database = await db;

    int result = await database!.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id]
    );

    return result;
  }

  Future<int> updateAd(Advertisement advertisement) async {
    var database = await db;

    int result = await database!.update(
      tableName,
      advertisement.toMap(),
      where: "id = ?",
      whereArgs: [advertisement.id]
    );

    return result;
  }

}