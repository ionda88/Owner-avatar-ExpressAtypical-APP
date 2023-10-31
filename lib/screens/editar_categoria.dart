import 'dart:io';

import 'package:express_atypical/entities/categoria.dart';
import 'package:express_atypical/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditarCategoriaPage extends StatefulWidget {
  final Categoria categoriaSelecionada;

  const EditarCategoriaPage({Key? key, required this.categoriaSelecionada})
      : super(key: key);

  @override
  _EditarCategoriaState createState() => _EditarCategoriaState();
}

class _EditarCategoriaState extends State<EditarCategoriaPage> {
  final _deCategoriaController = TextEditingController();
  final _deUrlImagemController = TextEditingController();
  final _deUrlAudioController = TextEditingController();

  XFile? _image;
  final _picker = ImagePicker();

  @override
  void initState() {

    super.initState();
    atualizarControllers();
  }

  @override
  void dispose() {
    _deCategoriaController.clear();
    _deUrlImagemController.clear();
    _deUrlAudioController.clear();
    super.dispose();
  }

  Future getImageFromGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = XFile(image.path);
        widget.categoriaSelecionada.deUrlImagem = image.path;
      }
    });
  }

  Future getImageFromCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (image != null) {
        _image = XFile(image.path);
        widget.categoriaSelecionada.deUrlImagem = image.path;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Categoria'),
        actions: [
          if (widget.categoriaSelecionada.id.idCategoria != 0)
            IconButton(
                onPressed: () {
                  confirmaExcluir();
                },
                icon: const Icon(Icons.delete)),
          IconButton(
              onPressed: () {
                salvarCategoria(context);
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          if(widget.categoriaSelecionada.deUrlImagem != "" && !widget.categoriaSelecionada.deUrlImagem.startsWith("http"))
          Center(
            child: _image == null ? Text('No Image selected') : Image.file(File(_image!.path)),
          ),
          if(widget.categoriaSelecionada.deUrlImagem.startsWith("http"))
            Center(child: Image.network(widget.categoriaSelecionada.deUrlImagem),
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
                  widget.categoriaSelecionada.deCategoria = value ?? "";
                });
              },
              controller: _deCategoriaController,
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
          //         widget.categoriaSelecionada.deUrlImagem = value ?? "";
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
                  widget.categoriaSelecionada.deUrlImagem = value ?? "";
                });
              },
              controller: _deUrlAudioController,
            ),
          ),
        ],
      ),
    );
  }

  bool salvarCategoria(BuildContext context) {
    if (widget.categoriaSelecionada.deCategoria.isNotEmpty) {
      CategoriaProvider categoriaProvider = CategoriaProvider();
      categoriaProvider.insert(widget.categoriaSelecionada).then((value) {
        Navigator.of(context).pop();
      });
      return true;
    }
    return false;
  }

  void atualizarControllers() {
    if(widget.categoriaSelecionada.deUrlImagem != "" && !widget.categoriaSelecionada.deUrlImagem.startsWith("http")) {
      _image = XFile(widget.categoriaSelecionada.deUrlImagem);
    }
    _deCategoriaController.text = widget.categoriaSelecionada.deCategoria;
    //_deUrlImagemController.text = widget.categoriaSelecionada.deUrlImagem;
    _deUrlAudioController.text = widget.categoriaSelecionada.deUrlAudio;
  }

  confirmaExcluir() {
    showDialog(
      context: context,
      builder: (BuildContext contextDialog) {
        return AlertDialog(
          title: const Text("Deseja realmente excluir essa categoria?"),
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
    CategoriaProvider categoriaProvider = CategoriaProvider();
    categoriaProvider.deleteCategoria(widget.categoriaSelecionada);
    Navigator.of(context).pop();
  }
}
