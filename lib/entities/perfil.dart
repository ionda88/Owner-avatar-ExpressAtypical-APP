import 'package:express_atypical/entities/perfilPK.dart';
import 'package:express_atypical/providers/database_provider.dart';
import 'package:sqflite/sqflite.dart';

const tablePerfil = "perfil";

const createTablePerfil = ' create table perfil ( '
    ' id_perfil NUMERIC, '
    ' id_usuario NUMERIC, '
    ' de_perfil TEXT, '
    ' dt_nascimento TEXT, '
    ' tipo TEXT, '
    ' dt_atualizacao TEXT, '
    ' dt_criacao NUMERIC, '
    ' deleted NUMERIC, '
    ' dt_delecao NUMERIC, '
    ' CONSTRAINT pk_usuario PRIMARY KEY ( '
    '   id_perfil ASC, '
    '   id_usuario ASC '
    ' ) '
    ' )';

const colIdPerfil = 'id_perfil';
const colIdUsuario = 'id_usuario';
const colDePerfil = 'de_perfil';
const colDtNascimento = 'dt_nascimento';
const colTipo = 'tipo';
const colDtAtualizacao = 'dt_atualizacao';
const colDtCriacao = 'dt_criacao';
const colDeleted = 'deleted';
const colDtDelecao = 'dt_delecao';

class Perfil {
  PerfilPK id = PerfilPK.empty();
  String dePerfil = "";
  num dtNascimento = 0;
  num tipo = 0;
  num dtAtualizacao = 0;
  num dtCriacao = 0;
  num deleted = 0;
  num dtDelecao = 0;

  Perfil(
      this.id,
      this.dePerfil,
      this.dtNascimento,
      this.tipo,
      this.dtAtualizacao,
      this.dtCriacao,
      this.deleted,
      this.dtDelecao);

  Perfil.empty();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id_perfil'] = id.idPerfil;
    map['id_usuario'] = id.idUsuario;
    map['de_perfil'] = dePerfil;
    map['dt_nascimento'] = dtNascimento;
    map['tipo'] = tipo;
    map['dt_atualizacao'] = dtAtualizacao;
    map['dt_criacao'] = dtCriacao;
    map['deleted'] = deleted;
    map['dt_delecao'] = dtDelecao;
    return map;
  }

  factory Perfil.fromMapObject(Map<String, dynamic> map) {
    return Perfil(
        PerfilPK((map['id_perfil'] ?? ""),(map['id_usuario'] ?? "")),
        (map['de_perfil'] ?? ""),
        (map['dt_nascimento'] ?? ""),
        (map['tipo'] ?? ""),
        (map['dt_atualizacao'] ?? 0),
        (map['dt_criacao'] ?? 0),
        (map['deleted'] ?? 0),
        (map['dt_delecao'] ?? 0),

    );
  }
}

class PerfilProvider {
  Future<Perfil> insert(Perfil perfil) async {
    Database db = await DatabaseProvider.db.database;
    // if (usuario.id == 0) {
    //   usuario.id = await buscaNovoNumeroUsuario(usuario);
    // }

    await db.rawInsert(
        " INSERT OR IGNORE INTO $tablePerfil( "
            " $colIdUsuario, "
            " $colIdPerfil, "
            " $colDePerfil, "
            " $colDtNascimento, "
            " $colTipo, "
            " $colDtAtualizacao, "
            " $colDtCriacao, "
            " $colDeleted, "
            " $colDtDelecao "
            ") values (?,?,?,?,?,?,?,?,?) ",
        [
          perfil.id.idUsuario,
          perfil.id.idPerfil,
          perfil.dePerfil,
          perfil.dtNascimento,
          perfil.tipo,
          perfil.dtAtualizacao,
          perfil.dtCriacao,
          perfil.deleted,
          perfil.dtDelecao
        ]);
    //update(perfil);
    return perfil;
  }

  Future<Perfil> update(Perfil perfil) async {
    Database db = await DatabaseProvider.db.database;

    await db.rawUpdate(
        " UPDATE $tablePerfil SET"
    " $colIdUsuario = ?, "
    " $colIdPerfil = ?, "
    " $colDePerfil = ?, "
    " $colDtNascimento = ?, "
    " $colTipo = ?, "
    " $colDtAtualizacao = ?, "
    " $colDtCriacao = ?, "
    " $colDeleted = ?, "
    " $colDtDelecao = ? "
            " WHERE $colIdUsuario = ? "
            " AND $colIdPerfil = ? ",
        [


          perfil.dePerfil,
          perfil.dtNascimento,
          perfil.tipo,
          perfil.dtAtualizacao,
          perfil.dtCriacao,
          perfil.deleted,
          perfil.dtDelecao,
          perfil.id.idUsuario,
          perfil.id.idPerfil
        ]);
    return perfil;
  }


  Future<int> buscaNovoNumeroPerfil(Perfil perfil) async {
    Database db = await DatabaseProvider.db.database;
    int max = 1;
    await db.rawQuery(
        'SELECT MAX($colIdPerfil) '
            'FROM $tablePerfil '
            'where $colIdUsuario = ? '
        ,
        [perfil.id.idUsuario]).then((value) {
      if (value.isNotEmpty && value.first.values.first != null) {
        max = int.parse(value.first.values.first.toString());
        max++;
      }
    });
    return max;
  }

  Future<List<Perfil>> getPerfisUsuario(num idUsuario) async {
    Database db = await DatabaseProvider.db.database;
    List<Map<String, dynamic>> listaMap = await db.query(tablePerfil,
        where: '$colIdUsuario = ?',
        whereArgs: [idUsuario]);
    List<Perfil> listaRetorno = List.empty(growable: true);
    for (var map in listaMap) {
      listaRetorno.add(Perfil.fromMapObject(map));
    }
    if(idUsuario == 0) {
      Perfil perfil = Perfil.empty();
      perfil.id.idUsuario = 0;
      perfil.id.idPerfil = 0;
      perfil.dePerfil = "Nicolas";
      listaRetorno.add(perfil);
    }
    return listaRetorno;
  }
}


