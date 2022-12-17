import 'package:flutter/material.dart';
import 'screen/splash_screen.dart';

void main() {
  runApp(MaterialApp(
    title:  "Loja de Anúncios",
    theme: ThemeData(
    primarySwatch: Colors.blue,
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.purple),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.purple),
      ),
    ),
  ),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    
  ));
}
