import 'package:flutter/material.dart';
import 'package:loja_app/model/Advertisement.dart';

class DescriptionScreen extends StatefulWidget {

  Advertisement? advertisement;

  DescriptionScreen([this.advertisement]);

  @override
  State<StatefulWidget> createState() => _InitState();

}

class _InitState extends State<DescriptionScreen> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "OLX",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: const Text("Aqui a tela de descricao, so to testando o listview"),
    );
  }

}