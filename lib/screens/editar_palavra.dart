import 'dart:io';

import 'package:express_atypical/entities/categoria.dart';
import 'package:express_atypical/entities/palavra.dart';
import 'package:express_atypical/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditarPalavraPage extends StatefulWidget {
  final Palavra palavraSelecionada;

  const EditarPalavraPage({Key? key, required this.palavraSelecionada})
      : super(key: key);

  @override
  _EditarPalavraState createState() => _EditarPalavraState();
}

class _EditarPalavraState extends State<EditarPalavraPage> {

  final _dePalavraController = TextEditingController();
  final _deUrlImagemController = TextEditingController();
  final _deUrlAudioController = TextEditingController();

  XFile? _image;
  final _picker = ImagePicker();


  Future getImageFromGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = XFile(image.path);
        widget.palavraSelecionada.deUrlImagem = image.path;
      }
    });
  }

  Future getImageFromCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (image != null) {
        _image = XFile(image.path);
        widget.palavraSelecionada.deUrlImagem = image.path;
      }
    });
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Galeria'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Câmera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    atualizarControllers();
  }

  @override
  void dispose() {
    _dePalavraController.clear();
    _deUrlImagemController.clear();
    _deUrlAudioController.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Palavra'),
        actions: [
          if (widget.palavraSelecionada.id.idCategoria != 0) IconButton(onPressed: (){
            confirmaExcluir();
          },icon: const Icon(Icons.delete)),
          IconButton(onPressed: (){
            salvarCategoria(context);
          }, icon: const Icon(Icons.save))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if(widget.palavraSelecionada.deUrlImagem != "" && !widget.palavraSelecionada.deUrlImagem.startsWith("http"))
          Center(
            child: _image == null ? Text('No Image selected') : Image.file(File(_image!.path)),
          ),
          if(widget.palavraSelecionada.deUrlImagem.startsWith("http"))
            Center(child: Image.network(widget.palavraSelecionada.deUrlImagem),
            ),
          TextButton(
            child: Text('Selecionar Imagem'),
            onPressed: showOptions,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Nome',
              ),
              onChanged: (value) {
                setState(() {
                  widget.palavraSelecionada.dePalavra = value ?? "";
                });
              },
              controller: _dePalavraController,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          //   child: TextFormField(
          //     decoration: const InputDecoration(
          //       border: UnderlineInputBorder(),
          //       labelText: 'URL imagem',
          //     ),
          //     onChanged: (value) {
          //       setState(() {
          //         widget.palavraSelecionada.deUrlImagem = value ?? "";
          //       });
          //     },
          //     controller: _deUrlImagemController,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'URL audio',
              ),
              onChanged: (value) {
                setState(() {
                  widget.palavraSelecionada.deUrlImagem = value ?? "";
                });
              },
              controller: _deUrlAudioController,
            ),
          ),
        ],
      ),
    );
  }

  void salvarCategoria(BuildContext context) {
    PalavraProvider palavraProvider = PalavraProvider();
    palavraProvider.insert(widget.palavraSelecionada);
    Navigator.of(context).pop();
  }

  void atualizarControllers() {
    if(widget.palavraSelecionada.deUrlImagem != "") {
      _image = XFile(widget.palavraSelecionada.deUrlImagem);
    }

    _dePalavraController.text = widget.palavraSelecionada.dePalavra;
  //  _deUrlImagemController.text = widget.palavraSelecionada.deUrlImagem;
    _deUrlAudioController.text = widget.palavraSelecionada.deUrlAudio;
  }

  confirmaExcluir() {
    showDialog(
      context: context,
      builder: (BuildContext contextDialog) {
        return AlertDialog(
          title: const Text("Deseja realmente excluir essa palavra?"),
          //content: const Text("Enviando..."),
          actions: [
            TextButton(
              child: const Text("Não"),
              onPressed: () {
                Navigator.of(contextDialog).pop();
              },
            ),
            TextButton(
              child: const Text("Sim"),
              onPressed: () {
                confirmaExluirOK();
                Navigator.of(contextDialog).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void confirmaExluirOK() {
    PalavraProvider palavraProvider = PalavraProvider();
    palavraProvider.deletePalavra(widget.palavraSelecionada);
    Navigator.of(context).pop();
  }
}
