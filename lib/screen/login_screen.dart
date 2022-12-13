import 'package:flutter/material.dart';
import 'package:loja_app/controller/login_controller.dart';
import 'package:loja_app/screen/sign_up_screen.dart';
import 'package:loja_app/screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../model/user.dart';

enum LoginStatus { notSignIn, signIn }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _InitState();

}

class _InitState extends State<LoginScreen> {

  LoginStatus _loginStatus = LoginStatus.notSignIn;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginController controller;
  var value;

  _InitState() {
    controller = LoginController();
  }

  mainRoute([User? user]) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => MainScreen(user)
      )
    );
  }

  void _submit() async {
    try{
      User? user = await controller.getLogin(_emailController.text, _passwordController.text);
      if (user!=null) {
        savePref(1, user.email, user.password);
        _loginStatus = LoginStatus.signIn;
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

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", 0);
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  savePref(int value, String email, String pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", value);
      preferences.setString("email", email);
      preferences.setString("pass", pass);
    });
  }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
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
    case LoginStatus.signIn:
      return const Scaffold();
      //return HomePage(signOut);
    }
  }
}