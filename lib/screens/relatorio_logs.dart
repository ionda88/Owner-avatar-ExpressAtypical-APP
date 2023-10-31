import 'package:brasil_fields/brasil_fields.dart';
import 'package:express_atypical/entities/categoria.dart';
import 'package:express_atypical/entities/log.dart';
import 'package:express_atypical/entities/palavra.dart';
import 'package:express_atypical/entities/perfil.dart';
import 'package:express_atypical/screens/editar_palavra.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;

import 'listar_categorias.dart';

class RelatorioLogsPage extends StatefulWidget {
  final Perfil perfilSelecionado;

  const RelatorioLogsPage({Key? key, required this.perfilSelecionado})
      : super(key: key);

  @override
  _RelatorioLogsState createState() => _RelatorioLogsState();
}

class _RelatorioLogsState extends State<RelatorioLogsPage> {
  late Future<List<Log>> listaLogsF;

  @override
  initState() {
    listaLogsF = buscaLogs();
    super.initState();
  }

  Future<List<Log>> buscaLogs() async {
    List<Log> listaLogs = List.empty(growable: true);
    LogProvider logProvider = LogProvider();
    listaLogs = await logProvider.buscaLogs(widget.perfilSelecionado);
    return listaLogs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Relatório de uso"),
        ),
        body: FutureBuilder(
            future: listaLogsF,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //List<Log> listaLogs = snapshot.data!;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final log = snapshot.data![index];
                      return ListTile(
                          title: Text( log.origem +
                              " - " +
                              UtilData.obterDataDDMMAAAA(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      log.time)) + " " + UtilData.obterHoraHHMM(
                              DateTime.fromMillisecondsSinceEpoch(
                                  log.time))), subtitle: Text(widget.perfilSelecionado.dePerfil + " - " +log.message), leading: Text(log.id.toString()),);
                    });

                // return GridView.count(
                //     crossAxisCount:
                //     (MediaQuery.of(context).orientation == Orientation.portrait
                //         ? 3
                //         : 5),
                //     padding: EdgeInsets.all(4.0),
                //     crossAxisSpacing: 4.0,
                //     mainAxisSpacing: 4.0,
                //     children:
                //     montaListaPalavras(listaCategoria, context));
              }
              return const CircularProgressIndicator();
            }));
  }
}
