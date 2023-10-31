import 'dart:async';
import 'dart:io' show File, Platform;
import 'package:dio/dio.dart';
import 'package:express_atypical/entities/categoria.dart';
import 'package:express_atypical/entities/palavra.dart';
import 'package:express_atypical/entities/perfil.dart';
import 'package:express_atypical/screens/editar_categoria.dart';
import 'package:express_atypical/screens/listar_palavras.dart';
import 'package:express_atypical/screens/relatorio_logs.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ListarCategoriasPage extends StatefulWidget {
  final Perfil perfilSelecionado;

  const ListarCategoriasPage({Key? key, required this.perfilSelecionado})
      : super(key: key);

  @override
  _ListarCategoriasState createState() => _ListarCategoriasState();
}

enum TtsState { playing, stopped, paused, continued }

class _ListarCategoriasState extends State<ListarCategoriasPage> {
  final dio = Dio();
  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 0.8;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWindows => !kIsWeb && Platform.isWindows;

  bool get isWeb => kIsWeb;

  bool modoEdicao = false;

  late Future<List<Categoria>> listaCategorias;

  @override
  initState() {
    listaCategorias = getCategorias();
    initTts();
    super.initState();
  }

  void refresh() {
    listaCategorias = getCategorias();
    setState(() {});
  }

  Future<List<Categoria>> getCategoriasAPI() async {
    List<Categoria> listaCategoria = List.empty(growable: true);
    Response<Map> response = await dio.get(
        'https://us-central1-express-atypical.cloudfunctions.net/categorias');
    Map responseBody = response.data!;
    for (MapEntry item in responseBody.entries) {
      Categoria categoriaNova = Categoria.empty();
      categoriaNova.deCategoria = item.key;
      for (Map subItem in item.value) {
        Palavra iconeNovo = Palavra.empty();
        iconeNovo.dePalavra = subItem["deIcone"];
        iconeNovo.deUrlImagem = subItem["deUrlImagem"];
        categoriaNova.listaPalavra.add(iconeNovo);
      }

      listaCategoria.add(categoriaNova);
    }
    return listaCategoria;
  }

  Future<List<Categoria>> getCategorias() async {
    List<Categoria> listaCategoria = List.empty(growable: true);
    CategoriaProvider categoriaProvider = CategoriaProvider();
    listaCategoria = await categoriaProvider.getCategorias(
        widget.perfilSelecionado.id.idUsuario,
        widget.perfilSelecionado.id.idPerfil);
    return listaCategoria;
  }

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setLanguage("pt-PT");
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      //  print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      //  print(voice);
    }
  }

  Future _speak(String texto) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    await flutterTts.speak(texto);
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  // Future _stop() async {
  //   var result = await flutterTts.stop();
  //   if (result == 1) setState(() => ttsState = TtsState.stopped);
  // }
  //
  // Future _pause() async {
  //   var result = await flutterTts.pause();
  //   if (result == 1) setState(() => ttsState = TtsState.paused);
  // }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  void addNovaCategoria(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditarCategoriaPage(
                categoriaSelecionada: Categoria.empty()))).then((value) {
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          drawer: Drawer(
            child: Stack(children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: const Image(image: AssetImage("assets/logo.png"),),
                  accountName:
                      Text(widget.perfilSelecionado.id.idUsuario.toString()),
                  accountEmail: Text(widget.perfilSelecionado.dePerfil)),
              ListView(
                padding: const EdgeInsets.only(top: 200),
                children: <Widget>[
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        icon: const Icon(Icons.receipt),
                        label: const Text('Relatórios',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          
                          //Navigator.of(context).pop();

                          Navigator.of(context)
                              .push(MaterialPageRoute(
                              builder: (context) => RelatorioLogsPage(perfilSelecionado: widget.perfilSelecionado)))
                              .then((_) {
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
          appBar: AppBar(title: Text('Express Atypical'), actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    modoEdicao = !modoEdicao;
                  });
                },
                icon: Icon(modoEdicao ? Icons.cancel : Icons.edit))
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              addNovaCategoria(context);
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
          body: FutureBuilder(
              future: listaCategorias,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Categoria> listaCategoria = snapshot.data!;
                  return GridView.count(
                      crossAxisCount: (MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 3
                          : 5),
                      padding: EdgeInsets.all(4.0),
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      children: montaListaCategorias(listaCategoria, context));
                }
                return const CircularProgressIndicator();
              })),
    );
  }

  Widget _btnSection() {
    return Container(
      padding: EdgeInsets.only(top: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(Colors.green, Colors.greenAccent, Icons.play_arrow,
              'PLAY', _speak),
        ],
      ),
    );
  }

  Column _buildButtonColumn(Color color, Color splashColor, IconData icon,
      String label, Function func) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(icon),
              color: color,
              splashColor: splashColor,
              onPressed: () => func()),
          Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: color)))
        ]);
  }

  List<Widget> montaListaCategorias(
      List<Categoria> listCategoria, BuildContext buildContext) {
    return listCategoria.map((data) {
      return Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Color.fromRGBO(212, 211, 209, 1),
          child: Material(
            child: InkWell(
              onTap: () {
                _speak(data.deCategoria!);
                if (modoEdicao) {
                  Navigator.push(
                      buildContext,
                      MaterialPageRoute(
                          builder: (context) => EditarCategoriaPage(
                              categoriaSelecionada: data))).then((value) {
                    refresh();
                  });
                } else {
                  Navigator.push(
                      buildContext,
                      MaterialPageRoute(
                          builder: (context) => ListarPalavrasPage(
                              categoriaSelecionada: data))).then((value) {
                    refresh();
                  });
                }
              }, // needed
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image:
                  (data.deUrlImagem == "" ? NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/685/685655.png') :
                  (data.deUrlImagem.startsWith("http") ? NetworkImage(data.deUrlImagem) :
                  FileImage(File(data.deUrlImagem)) ) ) as ImageProvider,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                )),
                child: FractionallySizedBox(
                  alignment: Alignment.bottomCenter,
                  widthFactor: 1,
                  heightFactor: 0.3,
                  child: Container(
                    decoration: new BoxDecoration(
                        color: Color.fromRGBO(250, 90, 22, 1),
                        borderRadius: new BorderRadius.only(
                            bottomLeft: const Radius.circular(4.0),
                            bottomRight: const Radius.circular(4.0))),
                    child: Center(
                      child: Text(
                        data.deCategoria!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'BebasNeue',
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ));
    }).toList();
  }

  List<Widget> montaListaIcones(List<Palavra> listPalavra) {
    return listPalavra.map((data) {
      return Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Color.fromRGBO(212, 211, 209, 1),
          child: Material(
            child: InkWell(
              onTap: () {
                _speak(data.dePalavra!);
              }, // needed
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(data.deUrlImagem!),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                )),
                child: FractionallySizedBox(
                  alignment: Alignment.bottomCenter,
                  widthFactor: 1,
                  heightFactor: 0.3,
                  child: Container(
                    decoration: new BoxDecoration(
                        color: Color.fromRGBO(250, 90, 22, 1),
                        borderRadius: new BorderRadius.only(
                            bottomLeft: const Radius.circular(4.0),
                            bottomRight: const Radius.circular(4.0))),
                    child: Center(
                      child: Text(
                        data.dePalavra!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'BebasNeue',
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ));
    }).toList();
  }
}
