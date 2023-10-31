import 'package:express_atypical/entities/categoria.dart';
import 'package:express_atypical/entities/log.dart';
import 'package:express_atypical/entities/palavra.dart';
import 'package:express_atypical/entities/perfil.dart';
import 'package:express_atypical/entities/usuario.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  static Database? _database;

  Future<Database> get database async => _database ??= await initDB();

  static String dbName = "expressatypical";

  static int version = 3;


  initDB() async {
    return await openDatabase(dbName, version: version, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          createDatabase(db);
        }, onUpgrade: (Database db, int oldVersion, int newVersion) {
          _onUpgrade(db, oldVersion, newVersion);
        });
  }

  Future<void> createDatabase(Database db) async {
    var batch = db.batch();
    batch.execute(createTableUsuario);
    batch.execute(createTablePerfil);
    batch.execute(createTableLog);
    batch.execute(createTableCategoria);
    batch.execute(createTablePalavra);
    await batch.commit(noResult: true);
    return;
  }

  static Future deleteDB() async {
    Database db = await DatabaseProvider.db.database;
    db.close();
    deleteDatabase(DatabaseProvider.dbName);
    _database = null;
    return;
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    for (var version = oldVersion + 1; version <= newVersion; version++) {
      switch (version) {
        case 2:
          {
            db.execute(createTableUsuario);
            db.execute(createTablePerfil);
            break;
          }
        case 3:
          {
            db.execute(createTableLog);

            break;
          }
      }
    }
  }
}