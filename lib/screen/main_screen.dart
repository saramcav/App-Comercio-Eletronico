import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _InitState();

}

class _InitState extends State<MainScreen> {
  
  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.shopping_cart_outlined),
        /*title: const Text(
          "OLX",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),*/
        backgroundColor: Colors.purple.shade600,
      ),
    );
  }
}