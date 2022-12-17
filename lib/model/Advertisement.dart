import 'dart:typed_data';

import 'package:flutter/material.dart';

//classe que contem os atributos do anuncio
//possui funcoes de codificar e decodificar seus atributos
class Advertisement{
  int? id;
  String? title;
  String? state;
  String? category;  
  double? price;
  String? telephone;
  String? description;
  String? author;
  Uint8List? photo;

  Advertisement(this.title, this.state, this.category,this.price, this.telephone, this.description, this.author, this.photo);

  Advertisement.fromMap(Map map) {
    this.id = map["id"];
    this.title = map["title"];
    this.state = map["state"];
    this.category = map["category"];    
    this.price = map["price"];
    this.telephone = map["telephone"];
    this.description = map["description"];
    this.author = map["author"];
    this.photo = map["photo"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "title": this.title,
      "state": this.state,
      "category": this.category,
      "price": this.price,
      "telephone": this.telephone,
      "description": this.description,
      "author": this.author,
      "photo": this.photo
    };
    
    map["id"] ??= this.id;

    return map;
  }  

  Image getImage(context){
    return Image.memory(photo!);
  }
}