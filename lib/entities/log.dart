import 'package:express_atypical/entities/perfil.dart';
import 'package:express_atypical/entities/perfilPK.dart';
import 'package:express_atypical/providers/database_provider.dart';
import 'package:sqflite/sqflite.dart';

const createTableLog = ' create table log ( '
    ' id NUMERIC, '
    ' origem TEXT, '
    ' action TEXT, '
    ' message TEXT, '
    ' time NUMERIC, '
    ' id_usuario NUMERIC, '
    ' id_perfil NUMERIC, '
    ' CONSTRAINT pk_log PRIMARY KEY ( '
    '   id ASC '
    ' ) '
    ' )';

const colId = 'id';
const colOrigem = 'origem';
const colAction = 'action';
const colMessage = 'message';
const colTime = 'time';
const colIdUsuario = 'id_usuario';
const colIdPerfil = 'id_perfil';

const tableLog = "log";

class Log {
  num id = 0;
  String origem = "";
  String action = "";
  String message = "";
  int time = 0;

  num idUsuario = 0;
  num idPerfil = 0;

  Log(this.id, this.origem, this.action, this.message, this.time,
      this.idUsuario, this.idPerfil);

  Log.empty();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['origem'] = origem;
    map['action'] = action;
    map['message'] = message;
    map['time'] = time;
    map['id_usuario'] = idUsuario;
    map['id_perfil'] = idPerfil;
    return map;
  }

  factory Log.fromMapObject(Map<String, dynamic> map) {
    return Log(
        (map['id'] ?? 0),
        (map['origem'] ?? ""),
        (map['action'] ?? ""),
        (map['message'] ?? ""),
        (map['time'] ?? 0),
        (map['id_usuario'] ?? 0),
        (map['id_perfil'] ?? 0));
  }
}

class LogProvider {
  Future<Log> insert(Log log) async {
    Database db = await DatabaseProvider.db.database;
    if(log.id == 0) {
      log.id = await buscaNovoNumeroLog(log);
    }
    await db.rawInsert(
        " INSERT OR IGNORE INTO $tableLog( "
            " $colId, "
            " $colOrigem, "
            " $colAction, "
            " $colMessage, "
            " $colTime, "
            " $colIdUsuario, "
            " $colIdPerfil "
            ") values (?,?,?,?,?,?,?) ",
        [
          log.id,
          log.origem,
          log.action,
          log.message,
          log.time,
          log.idUsuario,
          log.idPerfil
        ]);
    return log;
  }

  Future<int> buscaNovoNumeroLog(Log log) async {
    Database db = await DatabaseProvider.db.database;
    int max = 1;
    await db.rawQuery(
        'SELECT MAX($colId) '
            'FROM $tableLog ',
        []).then((value) {
      if (value.isNotEmpty && value.first.values.first != null) {
        max = int.parse(value.first.values.first.toString());
        max++;
      }
    });
    return max;
  }

  Future<List<Log>> buscaLogs(Perfil perfilSelecionado) async {
    Database db = await DatabaseProvider.db.database;
    List<Map<String, dynamic>> listaMap = await db.query(tableLog,
        where: '$colIdUsuario = ? and $colIdPerfil = ?',
        whereArgs: [perfilSelecionado.id.idUsuario, perfilSelecionado.id.idPerfil],
        orderBy: '$colId DESC');
    List<Log> listaRetorno = List.empty(growable: true);
    for (var map in listaMap) {
      listaRetorno.add(Log.fromMapObject(map));
    }
    return listaRetorno;
  }
}
