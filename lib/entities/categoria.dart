import 'package:express_atypical/entities/categoriaPK.dart';
import 'package:express_atypical/entities/log.dart';
import 'package:express_atypical/entities/palavra.dart';
import 'package:express_atypical/providers/database_provider.dart';
import 'package:sqflite/sqflite.dart';

const tableCategoria = "categoria";

const createTableCategoria = ' create table categoria ( '
    ' id_usuario NUMERIC, '
    ' id_perfil NUMERIC, '
    ' id_categoria NUMERIC, '
    ' de_categoria TEXT, '
    ' de_url_imagem TEXT, '
    ' de_url_audio TEXT, '
    ' dt_atualizacao NUMERIC, '
    ' dt_criacao NUMERIC, '
    ' dt_delecao NUMERIC, '
    ' deleted NUMERIC, '
    ' CONSTRAINT pk_categoria PRIMARY KEY ( '
    '   id_usuario ASC, '
    '   id_perfil ASC, '
    '   id_categoria ASC '
    ' ) '
    ' )';

const colIdUsuario = 'id_usuario';
const colIdPerfil = 'id_perfil';
const colIdCategoria = 'id_categoria';

const colDeCategoria = 'de_categoria';
const colDeUrlImagem = 'de_url_imagem';
const colDeUrlAudio = 'de_url_audio';
const colDtAtualizacao = 'dt_atualizacao';
const colDtCriacao = 'dt_criacao';
const colDtDelecao = 'dt_delecao';
const colDeleted = 'deleted';

class Categoria {
  CategoriaPK id = CategoriaPK.empty();
  String deCategoria = "";
  String deUrlImagem = "";
  String deUrlAudio = "";

  int iDtAtualizacao = 0;
  late DateTime dtAtualizacao;
  int iDtCriacao = 0;
  late DateTime dtCriacao;
  int iDtDelecao = 0;
  late DateTime dtDelecao;
  int deleted = 0;

  List<Palavra> listaPalavra = List.empty(growable: true);

  Categoria(this.id, this.deCategoria, this.deUrlImagem, this.deUrlAudio,
      this.iDtAtualizacao, this.iDtCriacao, this.iDtDelecao, this.deleted);

  Categoria.empty();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id_usuario'] = id.idUsuario;
    map['id_perfil'] = id.idPerfil;
    map['id_categoria'] = id.idCategoria;
    map['de_categoria'] = deCategoria;
    map['de_url_imagem'] = deUrlImagem;
    map['de_url_audio'] = deUrlAudio;
    map['dt_atualizacao'] = dtAtualizacao.millisecondsSinceEpoch;
    map['dt_criacao'] = dtCriacao.millisecondsSinceEpoch;
    map['dt_delecao'] = dtDelecao.millisecondsSinceEpoch;
    map['deleted'] = deleted;
    return map;
  }

  factory Categoria.fromMapObject(Map<String, dynamic> map) {
    return Categoria(
      CategoriaPK((map['id_usuario'] ?? 0), (map['id_perfil'] ?? 0),
          (map['id_categoria'] ?? 0)),
      (map['de_categoria'] ?? ""),
      (map['de_url_imagem'] ?? ""),
      (map['de_url_audio'] ?? ""),
      (map['dt_atualizacao'] ?? 0),
      (map['dt_criacao'] ?? 0),
      (map['dt_delecao'] ?? 0),
      (map['deleted'] ?? 0),
    );
  }

  String validaCampos() {
    if(deCategoria.isEmpty) {
      return "Nome da categoria é obrigatório!";
    }
    return "";
  }
}

class CategoriaProvider {
  Future<Categoria> insert(Categoria categoria) async {
    Database db = await DatabaseProvider.db.database;
    if (categoria.id.idCategoria == 0) {
      categoria.id.idCategoria = await buscaNovoNumeroCategoria(categoria);
    }

    await db.rawInsert(
        " INSERT OR IGNORE INTO $tableCategoria( "
        " $colIdUsuario, "
        " $colIdPerfil, "
        " $colIdCategoria, "
        " $colDeCategoria, "
        " $colDeUrlImagem, "
        " $colDeUrlAudio, "
        " $colDtAtualizacao, "
        " $colDtCriacao, "
        " $colDtDelecao, "
        " $colDeleted"
        ") values (?,?,?,?,?,?,?,?,?,?) ",
        [
          categoria.id.idUsuario,
          categoria.id.idPerfil,
          categoria.id.idCategoria,
          categoria.deCategoria,
          categoria.deUrlImagem,
          categoria.deUrlAudio,
          categoria.iDtAtualizacao,
          categoria.iDtCriacao,
          categoria.iDtDelecao,
          categoria.deleted
        ]);

    LogProvider logProvider = LogProvider();
    Log log = Log.empty();
    log.idUsuario = categoria.id.idUsuario;
    log.idPerfil = categoria.id.idPerfil;
    log.origem = "categoria";
    log.action = "insert ${categoria.id.idCategoria}";
    log.message = "Inseriu nova categoria ${categoria.id.idCategoria} ${categoria.deCategoria}";
    log.time = DateTime.now().millisecondsSinceEpoch;
    logProvider.insert(log);
    update(categoria, insert: true);
    return categoria;
  }

  Future<Categoria> update(Categoria categoria, {bool insert = false}) async {
    Database db = await DatabaseProvider.db.database;

    await db.rawUpdate(
        " UPDATE $tableCategoria SET"
        " $colDeCategoria = ?, "
        " $colDeUrlImagem = ?, "
        " $colDeUrlAudio = ?, "
        " $colDtAtualizacao = ?, "
        " $colDtCriacao = ?, "
        " $colDtDelecao = ?, "
        " $colDeleted = ? "
        " WHERE $colIdUsuario = ? "
        " AND $colIdPerfil = ? "
        " AND $colIdCategoria = ? ",
        [
          categoria.deCategoria,
          categoria.deUrlImagem,
          categoria.deUrlAudio,
          categoria.iDtAtualizacao,
          categoria.iDtCriacao,
          categoria.iDtDelecao,
          categoria.deleted,
          categoria.id.idUsuario,
          categoria.id.idPerfil,
          categoria.id.idCategoria,
        ]);
    if(!insert) {
      LogProvider logProvider = LogProvider();
      Log log = Log.empty();
      log.idUsuario = categoria.id.idUsuario;
      log.idPerfil = categoria.id.idPerfil;
      log.origem = "categoria";
      log.action = "update ${categoria.id.idCategoria}";
      log.message = "Atualizou categoria ${categoria.id.idCategoria} ${categoria.deCategoria}";
      log.time = DateTime.now().millisecondsSinceEpoch;
      logProvider.insert(log);
    }
    return categoria;
  }

  Future<void> deleteCategoria(Categoria categoria) async {
    //Database db = await DatabaseProvider.db.database;

    LogProvider logProvider = LogProvider();
    Log log = Log.empty();
    log.idUsuario = categoria.id.idUsuario;
    log.idPerfil = categoria.id.idPerfil;
    log.origem = "categoria";
    log.action = "delete ${categoria.id.idCategoria}";
    log.message = "Deletou categoria ${categoria.id.idCategoria} ${categoria.deCategoria}";
    log.time = DateTime.now().millisecondsSinceEpoch;
    logProvider.insert(log);
    // return await db.execute(
    //     "DELETE FROM $tableCategoria where $colIdUsuario = ${categoria.id.idUsuario} and $colIdPerfil = ${categoria.id.idPerfil} and $colIdCategoria = ${categoria.id.idCategoria}");
    categoria.deleted = -1;
    categoria.iDtDelecao = DateTime.now().millisecondsSinceEpoch;
    update(categoria);
  }

  Future<void> deleteFrom() async {
    Database db = await DatabaseProvider.db.database;
    return await db.execute("DELETE FROM $tableCategoria");
  }

  Future<List<Categoria>> getCategorias(int idUsuario, int cdPerfil) async {
    Database db = await DatabaseProvider.db.database;
    List<Map<String, dynamic>> listaMap = await db.query(tableCategoria,
        where: '$colIdUsuario = ? and $colIdPerfil = ? and $colDeleted <> -1',
        whereArgs: [idUsuario, cdPerfil],
        orderBy: '$colIdCategoria ASC');
    List<Categoria> listaRetorno = List.empty(growable: true);
    for (var map in listaMap) {
      listaRetorno.add(Categoria.fromMapObject(map));
    }
    if(idUsuario == 0 && cdPerfil == 0) {
      Categoria categoria1 = Categoria.empty();
      categoria1.id.idPerfil = 0;
      categoria1.id.idUsuario = 0;
      categoria1.id.idCategoria = 10;
      categoria1.deCategoria = "Familia";
      categoria1.deUrlImagem =
      "https://cdn-icons-png.flaticon.com/512/4129/4129027.png";
      listaRetorno.add(categoria1);
    }
    return listaRetorno;
  }

  Future<int> buscaNovoNumeroCategoria(Categoria categoria) async {
    Database db = await DatabaseProvider.db.database;
    int max = 1;
    await db.rawQuery(
        'SELECT MAX($colIdCategoria) '
        'FROM $tableCategoria '
        'where $colIdUsuario = ? '
        'and $colIdPerfil = ? ',
        [categoria.id.idUsuario, categoria.id.idPerfil]).then((value) {
      if (value.isNotEmpty && value.first.values.first != null) {
        max = int.parse(value.first.values.first.toString());
        max++;
      }
    });
    return max;
  }
}
