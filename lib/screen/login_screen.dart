import 'package:flutter/material.dart';
import 'package:loja_app/controller/login_controller.dart';
import 'package:loja_app/screen/sign_up_screen.dart';
import 'package:loja_app/screen/main_screen.dart';

import '../model/user.dart';

enum LoginStatus { notSignIn, signIn }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _InitState();

}

//essa tela possui caixas centrais em que a pessoa digita email e senha para realizar login
//abaixo, existe um botao de cadastro e outro de acesso direto, que a redirecionam as paginas relacionadas
class _InitState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginController controller;
  var value;

  _InitState() {
    controller = LoginController();
  }

  //funcao de mudanca de tela
  mainRoute([User? user]) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => MainScreen(user)
      )
    );
  }

  //essa funcao analisa se existe um usuario com o email e senha digitados nos campos de login
  //se existe, passa o user para a tela principal, 
  //senao exibe uma mensagem avisando que o cadastro nao existe 
  void _submit() async {
    try{
      User? user = await controller.getLogin(_emailController.text, _passwordController.text);
      if (user != null) {
        mainRoute(user);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não encontrado! Cadastre-se!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );     
    }   
  }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                //caixa que contém o "logo" e o nome do aplicativo
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(80)
                    ),
                    color: Colors.purple,
                    gradient: LinearGradient(
                      colors:  [Colors.purple, Colors.purple.shade800],
                      begin: Alignment.topCenter,
                      end:  Alignment.bottomCenter
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 75),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 55.0,
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(bottom: 50),
                          child: const Text(
                            "OLX",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //campo para a insercao do email
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 70),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey.shade200,
                    boxShadow: [BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 50,
                      color: Colors.purple.shade200
                    )],
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _emailController,
                    cursorColor: Colors.purple,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.email,
                        color: Colors.purple,
                      ),
                      hintText: "Insira seu Email",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none
                    ),
                  ),
                ),

                //campo para a insercao da senha
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey.shade200,
                    boxShadow: [BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 50,
                      color: Colors.purple.shade200
                    )],
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    cursorColor: Colors.purple,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.vpn_key,
                        color: Colors.purple,
                      ),
                      hintText: "Insira sua senha",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none
                    ),
                  ),
                ),

                //botao para submissao da tentativa de login
                GestureDetector(
                  onTap: () async => _submit(), 
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.center,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:  [Colors.purple, Colors.purple.shade800],
                        begin: Alignment.centerLeft,
                        end:  Alignment.centerRight
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 50,
                        color: Colors.purple.shade300
                      )],
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                //caixa que contém os botoes de "cadastrar-se" e "acesso direto"
                Container(
                  height: 250,
                  margin: const EdgeInsets.only(top: 40.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(80)
                    ),
                    color: Colors.purple,
                    gradient: LinearGradient(
                      colors:  [Colors.purple, Colors.purple.shade800],
                      begin: Alignment.topCenter,
                      end:  Alignment.bottomCenter
                    ),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //botao para redirecionamento para a pagina de cadastro
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen()
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors:  [Colors.purple.shade400, Colors.purple.shade600],
                                begin: Alignment.centerLeft,
                                end:  Alignment.centerRight
                              ),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [BoxShadow(
                                offset: const Offset(0, 5),
                                blurRadius: 20,
                                color: Colors.purple.shade800
                              )],
                            ),
                            child: const Text(
                              "Cadastrar-se",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        //botao para para redirecionamento sem cadastro para a tela principal
                        GestureDetector(
                          onTap: () {
                            mainRoute();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors:  [Colors.purple.shade400, Colors.purple.shade600],
                                begin: Alignment.centerLeft,
                                end:  Alignment.centerRight
                              ),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [BoxShadow(
                                offset: const Offset(0, 5),
                                blurRadius: 20,
                                color: Colors.purple.shade800
                              )],
                            ),
                            child: const Text(
                              "Acesso direto",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ), 
              ],
            ),
          ),
        );
  }
}