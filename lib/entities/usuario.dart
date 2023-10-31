import 'package:express_atypical/providers/database_provider.dart';
import 'package:sqflite/sqflite.dart';

const tableUsuario = "usuario";

const createTableUsuario = ' create table usuario ( '
    ' id NUMERIC, '
    ' status NUMERIC, '
    ' name TEXT, '
    ' email TEXT, '
    ' password TEXT, '
    ' data_nascimento NUMERIC, '
    ' phone TEXT, '
    ' deleted NUMERIC, '
    ' updated_at NUMERIC, '
    ' created_at NUMERIC, '
    ' type NUMERIC, '
    ' date_backup NUMERIC, '
    ' CONSTRAINT pk_usuario PRIMARY KEY ( '
    '   id ASC '
    ' ) '
    ' )';

const colId = 'id';
const colStatus = 'status';
const colName = 'name';
const colEmail = 'email';
const colPassword = 'password';
const colDataNascimento = 'data_nascimento';
const colPhone = 'phone';
const colDeleted = 'deleted';
const colUpdatedAt = 'updated_at';
const colCreatedAt = 'created_at';
const colType = 'type';
const colDateBackup = 'date_backup';


class Usuario {
  num id = 0;
  num status = 0;
  String name = "";
  String email = "";
  String password = "";
  num idataNascimento = 0;
  late DateTime dataNascimento;
  String phone = "";
  num deleted = 0;
  num updatedAt = 0;
  num createdAt = 0;
  num type = 0;
  num dateBackup = 0;

  Usuario(
      this.id,
      this.status,
      this.name,
      this.email,
      this.password,
      this.idataNascimento,
      this.phone,
      this.deleted,
      this.updatedAt,
      this.createdAt,
      this.type,
      this.dateBackup
      );

  Usuario.empty();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['name'] = name;
    map['email'] = email;
    map['password'] = password;
    map['data_nascimento'] = idataNascimento;
    map['phone'] = phone;
    map['deleted'] = deleted;
    map['updated_at'] = updatedAt;
    map['created_at'] = createdAt;
    map['type'] = type;
    map['date_backup'] = dateBackup;
    return map;
  }

  factory Usuario.fromMapObject(Map<String, dynamic> map) {
    return Usuario(
      (map['id'] ?? ""),
      (map['status'] ?? ""),
      (map['name'] ?? ""),
      (map['email'] ?? ""),
      (map['password'] ?? 0),
        (map['data_nascimento'] ?? 0),
      (map['phone'] ?? 0),
      (map['deleted'] ?? 0),
      (map['updated_at'] ?? 0),
        (map['created_at'] ?? 0),
        (map['type'] ?? 0),
        (map['date_backup'] ?? 0)
    );
  }
}

class UsuarioProvider {
  Future<Usuario> insert(Usuario usuario) async {
    Database db = await DatabaseProvider.db.database;
    if (usuario.id == 0) {
      usuario.id = await buscaNovoNumeroUsuario(usuario);
    }

    await db.rawInsert(
        " INSERT OR IGNORE INTO $tableUsuario( "
            " $colId, "
            " $colStatus, "
            " $colName, "
            " $colEmail, "
            " $colPassword, "
            " $colDataNascimento, "
            " $colPhone, "
            " $colDeleted, "
            " $colUpdatedAt, "
            " $colCreatedAt, "
            " $colType, "
            " $colDateBackup"
            ") values (?,?,?,?,?,?,?,?,?,?,?,?) ",
        [
          usuario.id,
          usuario.status,
          usuario.name,
          usuario.email,
          usuario.password,
          usuario.dataNascimento,
          usuario.phone,
          usuario.deleted,
          usuario.updatedAt,
          usuario.createdAt,
          usuario.type,
          usuario.dateBackup
        ]);
    update(usuario);
    return usuario;
  }

  Future<Usuario> update(Usuario usuario) async {
    Database db = await DatabaseProvider.db.database;

    await db.rawUpdate(
        " UPDATE $tableUsuario SET"
            " $colStatus = ?, "
            " $colName = ?, "
            " $colEmail = ?, "
            " $colPassword = ?, "
            " $colDataNascimento = ?, "
            " $colPhone = ?, "
            " $colDeleted = ?, "
            " $colUpdatedAt = ?, "
            " $colCreatedAt = ?, "
            " $colType = ?, "
            " $colDateBackup = ?"
            " WHERE $colId = ? ",
        [

          usuario.status,
          usuario.name,
          usuario.email,
          usuario.password,
          usuario.dataNascimento,
          usuario.phone,
          usuario.deleted,
          usuario.updatedAt,
          usuario.createdAt,
          usuario.type,
          usuario.dateBackup,
          usuario.id
        ]);
    return usuario;
  }

  Future<int> buscaNovoNumeroUsuario(Usuario usuario) async {
    Database db = await DatabaseProvider.db.database;
    int max = 1;
    await db.rawQuery(
        'SELECT MAX($colId) '
            'FROM $tableUsuario '
           ,
        []).then((value) {
      if (value.isNotEmpty && value.first.values.first != null) {
        max = int.parse(value.first.values.first.toString());
        max++;
      }
    });
    return max;
  }

  Future<Usuario> getUsuario(int idUsuario) async {
    Database db = await DatabaseProvider.db.database;
    List<Map<String, dynamic>> listaMap = await db.query(tableUsuario,
        where: '$colId = ?',
        whereArgs: [idUsuario]);
    List<Usuario> listaRetorno = List.empty(growable: true);
    for (var map in listaMap) {
      listaRetorno.add(Usuario.fromMapObject(map));
    }
    return listaRetorno.first;
  }
}