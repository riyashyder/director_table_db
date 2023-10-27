import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'DirectorDetailsDB.db';
  static const _databaseVersion = 4;

  static const directorTable = 'DirectorTable';

  static const colId = '_id';

  static const colCompanyName = '_companyName';
  static const colPanNo = '_panNo';
  static const colgstin = '_gstin';
  static const coloffaddress = '_offaddress';
  static const coldiraddress = '_diraddress';

  late Database _db;

  Future<void> initialization() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database database, int version) async {
    await database.execute('''
          CREATE TABLE $directorTable(
            $colId INTEGER PRIMARY KEY,
            $colCompanyName TEXT,   
            $colPanNo TEXT,     
            $colgstin TEXT,
            $coloffaddress TEXT,
            $coldiraddress TEXT           
          )
          ''');
  }

  _onUpgrade(Database database, int oldVersion, int newVersion) async {
    await database.execute('drop table $directorTable');
    _onCreate(database, newVersion);
  }

  Future<int> insertDirectorDetails(
      Map<String, dynamic> row, String tableName) async {
    return await _db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    return await _db.query(tableName);
  }

  Future<int> updateDirectorDetails(
      Map<String, dynamic> row, String tableName) async {
    int id = row[colId];
    return await _db.update(
      tableName,
      row,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteDirectorDetails(int id, String tableName) async {
    return await _db.delete(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }
}
