import 'dart:convert';

class User {
  final int? id;
  final String name;
  final String email;
  final String password;

  User({this.id, required this.name, required this.email, required this.password});

  factory User.fromMap(Map<String, dynamic> map) {
    return User (
      id: map["id"] ??= map["id"],
      name: map["name"] as String,
      email: map["email"] as String,
      password: map["password"] as String
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "name": name,
      "email": email,
      "password": password
    };
    
    return map;
  }  

  String toJson() => jsonEncode(toMap());

  factory User.fromJson(String source) => User.fromMap(jsonDecode(source) as Map<String, dynamic>);

}