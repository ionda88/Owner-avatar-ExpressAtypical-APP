import 'dart:ui';
import 'package:express_atypical/entities/usuario.dart';
import 'package:express_atypical/screens/listar_categorias.dart';
import 'package:express_atypical/screens/listar_perfis.dart';
import 'package:flutter/material.dart';

import '../entities/perfil.dart';

final formKey = GlobalKey<FormState>();


class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            height: 300,
            width: 300,
            child: DecorationCircle(),
          ),
          Positioned(
            left: 0,
            top: 0,
            height: MediaQuery.of(context).size.height,
            child: Container(
              width: 30,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.blueAccent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
            ),
          ),
          Positioned(
            left: 25,
            top: 290,
            child: Container(
              margin: const EdgeInsets.only(left: 40, bottom: 55),
              child: const Text(
                'Express atypical',
                style: TextStyle(fontFamily: 'Cubano', fontSize: 37, color: Colors.blue),
              ),),
          ),
          Positioned(
            left: 70,
            top: 140,
            child: Container(
              margin: const EdgeInsets.only(left: 40, bottom: 55),
              child: const Image(image: AssetImage('assets/logo.png')),),
          ),

          // Positioned(
          //   left: 25,
          //   top: 140,
          //   child: Container(
          //     margin: const EdgeInsets.only(left: 40, bottom: 55),
          //     child: const Text(
          //       'ATACADISTA',
          //       style: TextStyle(fontFamily: 'Cera', fontSize: 40, color: Colors.black),
          //     ),),
          // ),
          Fields(),
          Positioned(bottom: 180, left: 0, right: 0, child:             AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: 200,
            height: 45,
            margin: const EdgeInsets.symmetric(vertical: 15,horizontal: 70),
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: const BorderRadius.all(Radius.circular(40))),
            child: InkWell(
              onTap: () {
                entrarLogin(context);
                //validateAndSubmit(context);
              },
              child: Center(child: Text('Login',
                  style: TextStyle(fontSize: 20.0, color: Colors.white))),
            ),
          )),
          Positioned(bottom: 110, left: 0, right: 0, child:             AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: 200,
            height: 45,
            margin: const EdgeInsets.symmetric(vertical: 15,horizontal: 70),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.all(Radius.circular(40))),
            child: InkWell(
              onTap: () {
                entrarSemLogin(context);
              },
              child: Center(child: Text('Acessar sem login',
                  style: TextStyle(fontSize: 20.0, color: Colors.white))),
            ),
          )),
          Positioned(bottom: 40, left: 0, right: 0, child:             AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: 200,
            height: 45,
            margin: const EdgeInsets.symmetric(vertical: 15,horizontal: 70),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(40))),
            child: InkWell(
              onTap: () {
                validateAndSubmit(context);
              },
              child: Center(child: Text('Esqueci a senha',
                  style: TextStyle(fontSize: 20.0, color: Colors.black))),
            ),
          )),
        ],
      ),
    );
  }

  void validateAndSubmit(BuildContext context) async {
    //if (validateAndSave()) bloc.submitLogIn(context);
  }

  void entrarLogin(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListarPerfisPage(usuarioSelecionado: Usuario.empty())));
  }

  void entrarSemLogin(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ListarCategoriasPage(perfilSelecionado: Perfil.empty())));
  }
}



class Fields extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Container(
            margin: const EdgeInsets.only(top: 80),
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 6,
                      margin: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.none,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            icon: Icon(Icons.person_outline),
                            labelText: 'Email',
                          ),
                          style: const TextStyle(fontSize: 18),
                          onSaved: (String? value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                            //bloc.inUsuario.add(value!);
                          },
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ),
                    Card(
                      elevation: 6,
                      margin: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.none,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            icon: Icon(Icons.lock_outline),
                            labelText: 'Senha',
                          ),
                          style: const TextStyle(fontSize: 18),
                          onSaved: (String? value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                            //bloc.inSenha.add(value!);
                          },
                          validator: (value) {
                            //return BlocLogin.validatePassword(value!);
                          },
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}



class DecorationCircle extends StatelessWidget {
  const DecorationCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            height: 100,
            width: 150,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo.withOpacity(0.5),
                    Colors.blueAccent.withOpacity(0.5)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  bottomLeft: Radius.circular(200),
                )),
          ),
        ),
        Positioned(
          right: 0,
          top: 10,
          child: Container(
            height: 200,
            width: 60,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.blueAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(200),
                )),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.blueAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  bottomLeft: Radius.circular(200),
                )),
          ),
        ),
      ],
    );
  }
}
