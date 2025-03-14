import 'package:flutter/material.dart';
import 'package:loja_app/screen/login_screen.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => InitState();

}

//essa tela e somente uma tela roxa que contem o "logo" do aplicativo
//ao abri-lo, ela aparece durante 3 segundos para que va para a tela de login/cadastro/acesso direto
class InitState extends State<SplashScreen> {

  @override
  InitState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    return Timer(const Duration(seconds: 3), loginRoute);
  }

  //funcao de mudanca de tela
  loginRoute() {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => const LoginScreen()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.purple,
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.purple.shade800],
                begin: Alignment.topCenter,
                end:  Alignment.bottomCenter
              ),
            ),
          ),

          const Center(
            child:  Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 50.0,
            ), 
          ),
        ],
      ),
    );
  }
}