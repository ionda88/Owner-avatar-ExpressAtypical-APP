import 'package:express_atypical/entities/log.dart';
import 'package:express_atypical/entities/palavraPK.dart';
import 'package:express_atypical/providers/database_provider.dart';
import 'package:sqflite/sqflite.dart';

const tablePalavra = "palavra";

const createTablePalavra = ' create table palavra ( '
    ' id_usuario NUMERIC, '
    ' id_perfil NUMERIC, '
    ' id_categoria NUMERIC, '
    ' id_palavra NUMERIC, '
    ' de_palavra TEXT, '
    ' de_url_imagem TEXT, '
    ' de_url_audio TEXT, '
    ' dt_atualizacao NUMERIC, '
    ' dt_criacao NUMERIC, '
    ' dt_delecao NUMERIC, '
    ' deleted NUMERIC, '
    ' CONSTRAINT pk_palavra PRIMARY KEY ( '
    '   id_usuario ASC, '
    '   id_perfil ASC, '
    '   id_categoria ASC, '
    '   id_palavra ASC '
    ' ) '
    ' )';

const colIdUsuario = 'id_usuario';
const colIdPerfil = 'id_perfil';
const colIdCategoria = 'id_categoria';
const colIdPalavra = 'id_palavra';

const colDeCategoria = 'de_palavra';
const colDeUrlImagem = 'de_url_imagem';
const colDeUrlAudio = 'de_url_audio';
const colDtAtualizacao = 'dt_atualizacao';
const colDtCriacao = 'dt_criacao';
const colDtDelecao = 'dt_delecao';
const colDeleted = 'deleted';

class Palavra {
  PalavraPK id = PalavraPK.empty();
  String dePalavra = "";
  String deUrlImagem = "";
  String deUrlAudio = "";

  int iDtAtualizacao = 0;
  late DateTime dtAtualizacao;
  int iDtCriacao = 0;
  late DateTime dtCriacao;
  int iDtDelecao = 0;
  late DateTime dtDelecao;
  int deleted = 0;

  Palavra(this.id, this.dePalavra, this.deUrlImagem, this.deUrlAudio,
      this.iDtAtualizacao, this.iDtCriacao, this.iDtDelecao, this.deleted);

  Palavra.empty();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id_usuario'] = id.idUsuario;
    map['id_perfil'] = id.idPerfil;
    map['id_categoria'] = id.idCategoria;
    map['id_palavra'] = id.idPalavra;
    map['de_palavra'] = dePalavra;
    map['de_url_imagem'] = deUrlImagem;
    map['de_url_audio'] = deUrlAudio;
    map['dt_atualizacao'] = dtAtualizacao.millisecondsSinceEpoch;
    map['dt_criacao'] = dtCriacao.millisecondsSinceEpoch;
    map['dt_delecao'] = dtDelecao.millisecondsSinceEpoch;
    map['deleted'] = deleted;
    return map;
  }

  factory Palavra.fromMapObject(Map<String, dynamic> map) {
    return Palavra(
      PalavraPK((map['id_usuario'] ?? 0), (map['id_perfil'] ?? 0),
          (map['id_categoria'] ?? 0), (map['id_palavra'] ?? 0)),
      (map['de_palavra'] ?? ""),
      (map['de_url_imagem'] ?? ""),
      (map['de_url_audio'] ?? ""),
      (map['dt_atualizacao'] ?? 0),
      (map['dt_criacao'] ?? 0),
      (map['dt_delecao'] ?? 0),
      (map['deleted'] ?? 0),
    );
  }
}

class PalavraProvider {
  Future<Palavra> insert(Palavra palavra) async {
    Database db = await DatabaseProvider.db.database;

    if (palavra.id.idPalavra == 0) {
      palavra.id.idPalavra = await buscaNovoNumeroPalavra(palavra);
    }

    await db.rawInsert(
        " INSERT OR IGNORE INTO $tablePalavra( "
        " $colIdUsuario, "
        " $colIdPerfil, "
        " $colIdCategoria, "
        " $colIdPalavra, "
        " $colDeCategoria, "
        " $colDeUrlImagem, "
        " $colDeUrlAudio, "
        " $colDtAtualizacao, "
        " $colDtCriacao, "
        " $colDtDelecao, "
        " $colDeleted"
        ") values (?,?,?,?,?,?,?,?,?,?,?) ",
        [
          palavra.id.idUsuario,
          palavra.id.idPerfil,
          palavra.id.idCategoria,
          palavra.id.idPalavra,
          palavra.dePalavra,
          palavra.deUrlImagem,
          palavra.deUrlAudio,
          palavra.iDtAtualizacao,
          palavra.iDtCriacao,
          palavra.iDtDelecao,
          palavra.deleted
        ]);
    update(palavra);
    return palavra;
  }

  Future<Palavra> update(Palavra palavra, {bool insert = false}) async {
    Database db = await DatabaseProvider.db.database;

    await db.rawUpdate(
        " UPDATE $tablePalavra SET"
        " $colDeCategoria = ?, "
        " $colDeUrlImagem = ?, "
        " $colDeUrlAudio = ?, "
        " $colDtAtualizacao = ?, "
        " $colDtCriacao = ?, "
        " $colDtDelecao = ?, "
        " $colDeleted = ? "
        " WHERE $colIdUsuario = ? "
        " AND $colIdPerfil = ? "
        " AND $colIdCategoria = ? "
        " AND $colIdPalavra = ? ",
        [
          palavra.dePalavra,
          palavra.deUrlImagem,
          palavra.deUrlAudio,
          palavra.iDtAtualizacao,
          palavra.iDtCriacao,
          palavra.iDtDelecao,
          palavra.deleted,
          palavra.id.idUsuario,
          palavra.id.idPerfil,
          palavra.id.idCategoria,
          palavra.id.idPalavra,
        ]);
    if(!insert) {
      LogProvider logProvider = LogProvider();
      Log log = Log.empty();
      log.idUsuario = palavra.id.idUsuario;
      log.idPerfil = palavra.id.idPerfil;
      log.origem = "palavra";
      log.action = "update ${palavra.id.idCategoria}|${palavra.id.idPalavra}";
      log.message = "Atualizou palavra ${palavra.id.idPalavra} ${palavra.dePalavra}";
      log.time = DateTime.now().millisecondsSinceEpoch;
      logProvider.insert(log);
    }
    return palavra;
  }

  Future<void> deleteFrom() async {
    Database db = await DatabaseProvider.db.database;
    return await db.execute("DELETE FROM $tablePalavra");
  }

  Future<int> buscaNovoNumeroPalavra(Palavra palavra) async {
    Database db = await DatabaseProvider.db.database;
    int max = 1;
    await db.rawQuery(
        'SELECT MAX($colIdPalavra) '
        'FROM $tablePalavra '
        'where $colIdUsuario = ? '
        'and $colIdPerfil = ? '
        'and $colIdCategoria = ? ',
        [
          palavra.id.idUsuario,
          palavra.id.idPerfil,
          palavra.id.idCategoria
        ]).then((value) {
      if (value.isNotEmpty && value.first.values.first != null) {
        max = int.parse(value.first.values.first.toString());
        max++;
      }
    });
    return max;
  }

  Future<List<Palavra>> getPalavra(
      int idUsuario, int idPerfil, int idCategoria) async {
    Database db = await DatabaseProvider.db.database;
    List<Map<String, dynamic>> listaMap = await db.query(tablePalavra,
        where: '$colIdUsuario = ? and $colIdPerfil = ? and $colIdCategoria = ?',
        whereArgs: [idUsuario, idPerfil, idCategoria],
        orderBy: '$colIdPalavra ASC');
    List<Palavra> listaRetorno = List.empty(growable: true);
    for (var map in listaMap) {
      listaRetorno.add(Palavra.fromMapObject(map));
    }
    if(idCategoria == 10) {
      Palavra palavra1 = Palavra.empty();
      palavra1.id.idPerfil = 0;
      palavra1.id.idUsuario = 0;
      palavra1.id.idCategoria = 10;
      palavra1.id.idPalavra = 1;
      palavra1.dePalavra = "Pai";
      palavra1.deUrlImagem =
      "https://cdn-icons-png.flaticon.com/512/437/437535.png";
      listaRetorno.add(palavra1);

      Palavra palavra2 = Palavra.empty();
      palavra2.id.idPerfil = 0;
      palavra2.id.idUsuario = 0;
      palavra2.id.idCategoria = 10;
      palavra2.id.idPalavra = 2;
      palavra2.dePalavra = "Mãe";
      palavra2.deUrlImagem =
      "https://cdn-icons-png.flaticon.com/512/3557/3557853.png";
      listaRetorno.add(palavra2);

      Palavra palavra3 = Palavra.empty();
      palavra3.id.idPerfil = 0;
      palavra3.id.idUsuario = 0;
      palavra3.id.idCategoria = 10;
      palavra3.id.idPalavra = 3;
      palavra3.dePalavra = "Irmão";
      palavra3.deUrlImagem =
      "https://cdn-icons-png.flaticon.com/512/1855/1855505.png";
      listaRetorno.add(palavra3);
    }
    return listaRetorno;
  }

  Future<void> deletePalavra(Palavra palavra) async {

    LogProvider logProvider = LogProvider();
    Log log = Log.empty();
    log.idUsuario = palavra.id.idUsuario;
    log.idPerfil = palavra.id.idPerfil;
    log.origem = "palavra";
    log.action = "delete ${palavra.id.idCategoria}|${palavra.id.idPalavra}";
    log.message = "Deletou palavra ${palavra.id.idPalavra} ${palavra.dePalavra}";
    log.time = DateTime.now().millisecondsSinceEpoch;
    logProvider.insert(log);

    //Database db = await DatabaseProvider.db.database;
    // return await db.execute(
    //     "DELETE FROM $tablePalavra"
    //         " where $colIdUsuario = ${palavra.id.idUsuario} "
    //         "and $colIdPerfil = ${palavra.id.idPerfil} "
    //         "and $colIdCategoria = ${palavra.id.idCategoria} "
    //         "and $colIdPalavra = ${palavra.id.idPalavra}");

    palavra.deleted = -1;
    palavra.iDtDelecao = DateTime.now().millisecondsSinceEpoch;
    update(palavra);
  }
}
