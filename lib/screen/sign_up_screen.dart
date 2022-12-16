import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:loja_app/controller/login_controller.dart';
import 'package:loja_app/model/user.dart';
import 'package:loja_app/screen/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => _InitState();

}

//essa tela possui campos centrais em que a pessoa cadastra nome, email e senha 
//existe tambem um controlador de senha que verifica se a senha inserida atende aos requisitos espfificados
//abaixo, existe um botao de cadastro, que salva os dados no banco e redireciona para tela de login
class _InitState extends State <SignUpScreen> {
  late LoginController controller;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FlutterPwValidatorState> validatorKey = GlobalKey<FlutterPwValidatorState>();
  
  bool validPassword = false;
  bool isEmail(String email) => EmailValidator.validate(email);

  //verifica se os campos de cadastro foram preenchidos corretamente
  void validateInput() async {
    if(_nameController.text.isNotEmpty && _passwordController.text.isNotEmpty && _emailController.text.isNotEmpty) {
      //verificando email
      if(isEmail(_emailController.text)) {
        if(validPassword) {
          _insertNewUser();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insira uma senha válida para se cadastrar!')),
          );
        } 
      } else {
        //limpando controller para receber um email novo
        _emailController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insira um email válido para se cadastrar!')),
        );
      }
                  
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira todos os dados para se cadastrar!')),
      );
    }
  }

  //essa funcao instancia um user, guarda seus dados no bd e redireciona para a tela de login
  void _insertNewUser() async {
    List<User> users;
    List listUsers = [];
    bool dbContainsEmail = await controller.dbContainsEmail(_emailController.text);
    
    if(!dbContainsEmail) {
      User user = User(name: _nameController.text, email: _emailController.text, password: _passwordController.text);
      controller.saveUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário cadastrado com sucesso! Entre na conta!')),
      );
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      loginRoute();

    } else {
      _emailController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email já cadastrado! Insira um novo email!')
        )
      );
    }
    
    //printando usuarios
      users = await controller.getAllUser();
      for(User user in users) {listUsers.add(user.toMap());}
      print(listUsers);
    
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

  //instanciando controller
  _InitState() {
    controller = LoginController();
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
            
            //caixa roxa que contem o logo e o nome do aplicativo
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(80)),
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

            //campo para a insercao do nome
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
                controller: _nameController,
                cursorColor: Colors.purple,
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.purple,
                  ),
                  hintText: "Insira seu nome",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none
                ),
              ),
            ),

            //campo para a insercao do email
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
                  color: Colors.purple.shade200,
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

            //verificador de requisitos da senha
            FlutterPwValidator(
              key: validatorKey,
              controller: _passwordController,
              defaultColor: Colors.purple,
              minLength: 6,
              uppercaseCharCount: 1,
              numericCharCount: 1,
              specialCharCount: 1,
              normalCharCount: 3,
              width: 300,
              height: 150,
              onSuccess: () {
                validPassword = true;
              },
            ),

            //botao para submissao da tentativa de cadastro
            GestureDetector(
              onTap: () async => validateInput(),
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
                padding: const EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:  [Colors.purple, Colors.purple.shade900],
                    begin: Alignment.centerLeft,
                    end:  Alignment.centerRight
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: Colors.purple.shade200
                  )],
                ),
                child: const Text(
                  "Cadastrar",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}