import 'package:express_atypical/entities/categoria.dart';
import 'package:express_atypical/entities/palavra.dart';
import 'package:express_atypical/screens/editar_palavra.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show File, Platform;

import 'listar_categorias.dart';

class ListarPalavrasPage extends StatefulWidget {
  final Categoria categoriaSelecionada;

  const ListarPalavrasPage({Key? key, required this.categoriaSelecionada})
      : super(key: key);

  @override
  _ListarPalavrasState createState() => _ListarPalavrasState();
}

class _ListarPalavrasState extends State<ListarPalavrasPage> {
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

  late Future<List<Palavra>> listaPalavras;

  bool modoEdicao = false;

  @override
  initState() {
    listaPalavras = getPalavras();
    initTts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text(widget.categoriaSelecionada.deCategoria),
                actions: [
                  IconButton(onPressed: (){
                    setState(() {
                      modoEdicao = !modoEdicao;
                    });
                  },icon: Icon(modoEdicao ? Icons.cancel :Icons.edit))
                ]
            ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              addNovaPalavra(context);
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
        body: FutureBuilder(
            future: listaPalavras,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Palavra> listaCategoria = snapshot.data!;
                return GridView.count(
                    crossAxisCount:
                    (MediaQuery.of(context).orientation == Orientation.portrait
                        ? 3
                        : 5),
                    padding: EdgeInsets.all(4.0),
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    children:
                    montaListaPalavras(listaCategoria, context));
              }
              return const CircularProgressIndicator();
            }
        )
    );
  }

  List<Widget> montaListaPalavras(List<Palavra> listIcone, BuildContext buildContext) {
    return listIcone.map((data) {
      return Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Color.fromRGBO(212, 211, 209, 1),
          child: Material(
            child: InkWell(
              onTap: () {
                _speak(data.dePalavra!);
                if(modoEdicao) {
                  Navigator.push(
                      buildContext,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditarPalavraPage(
                                  palavraSelecionada: data))).then((value) {refresh();});
                }
              }, // needed
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  //image: NetworkImage("https://www.flaticon.com/br/icone-gratis/avo_375201?term=av%C3%B3&page=1&position=15&origin=search&related_id=375201"),
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
                        data.dePalavra ?? 'NULO!',
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


  void addNovaPalavra(BuildContext context) {
    Palavra novaPalavra = Palavra.empty();
    novaPalavra.id.idCategoria = widget.categoriaSelecionada.id.idCategoria;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditarPalavraPage(
                palavraSelecionada: novaPalavra))).then((value) {
      refresh();
    });
  }

  Future<List<Palavra>> getPalavras() async {
    List<Palavra> listaPalavras = List.empty(growable: true);
    PalavraProvider palavraProvider = PalavraProvider();
    listaPalavras = await palavraProvider.getPalavra(0, 0,widget.categoriaSelecionada.id.idCategoria);
    return listaPalavras;
  }

  void refresh() {
    listaPalavras = getPalavras();
    setState(() {});
  }
}
