import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:express_atypical/entities/categoria.dart';
import 'package:express_atypical/entities/palavra.dart';
import 'package:express_atypical/screens/listar_palavras.dart';
import 'package:express_atypical/screens/listar_categorias.dart';
import 'package:express_atypical/screens/login.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage()
    );
  }
}
