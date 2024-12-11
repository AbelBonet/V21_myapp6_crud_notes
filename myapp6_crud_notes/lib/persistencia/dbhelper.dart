import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_flutter_crud/JsonModels/llibre_model.dart';  // Canviat a llibre_model
import 'package:sqlite_flutter_crud/settings/constants_db.dart';

class DatabaseHelper {
  final databaseName = '${ConstantsDb.DATABASE_NAME}.db';
  String Table =
      'CREATE TABLE ${ConstantsDb.TABLE_LLIBRES} (${ConstantsDb.FIELD_LLIBRES_ID} INTEGER PRIMARY KEY AUTOINCREMENT, ${ConstantsDb.FIELD_LLIBRES_TITOL} TEXT NOT NULL,
  ${ConstantsDb.FIELD_LLIBRES_CONTENT} TEXT NOT NULL, ${ConstantsDb.FIELD_LLIBRES_CREATED_AT} TEXT DEFAULT CURRENT_TIMESTAMP)'; // Taula llibres

Future<Database> initDB() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, databaseName);

  return openDatabase(path, version: 1, onCreate: (db, version) async {
    await db.execute(Table);
  });
}

//Search Method
Future<List<LlibreModel>> searchLlibres(String keyword) async {  // Canviat a searchLlibres
  final Database db = await initDB();
  List<Map<String, Object?>> searchResult = await db
      .rawQuery('select * from ${ConstantsDb.TABLE_LLIBRES} where ${ConstantsDb.FIELD_LLIBRES_TITOL} LIKE ?', ['%$keyword%']);
  return searchResult.map((e) => LlibreModel.fromMap(e)).toList();  // Canviat a LlibreModel
}

//CRUD Methods

//Create Llibre
Future<int> createLlibre(LlibreModel llibre) async {  // Canviat a createLlibre
  final Database db = await initDB();
  return db.insert(ConstantsDb.TABLE_LLIBRES, llibre.toMap());  // Canviat a TABLE_LLIBRES
}

//Get llibres
Future<List<LlibreModel>> getLlibres() async {  // Canviat a getLlibres
  final Database db = await initDB();
  List<Map<String, Object?>> result = await db.query(ConstantsDb.TABLE_LLIBRES);  // Canviat a TABLE_LLIBRES
  return result.map((e) => LlibreModel.fromMap(e)).toList();  // Canviat a LlibreModel
}

//Delete Llibres
Future<int> deleteLlibre(int id) async {  // Canviat a deleteLlibre
  final Database db = await initDB();
  return db.delete(ConstantsDb.TABLE_LLIBRES, where: '${ConstantsDb.FIELD_LLIBRES_ID} = ?', whereArgs: [id]);  // Canviat a FIELD_LLIBRES_ID
}

//Update Llibres
Future<int> updateLlibre(title, content, Id) async {  // Canviat a updateLlibre
  final Database db = await initDB();
  return db.rawUpdate(
      'update ${ConstantsDb.TABLE_LLIBRES} set ${ConstantsDb.FIELD_LLIBRES_TITOL} = ?, ${ConstantsDb.FIELD_LLIBRES_CONTENT} = ? where ${ConstantsDb.FIELD_LLIBRES_ID} = ?',  // Canviat a TABLE_LLIBRES, FIELD_LLIBRES_TITOL, FIELD_LLIBRES_CONTENT
      [title, content, Id]);
}
}
