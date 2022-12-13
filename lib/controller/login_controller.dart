import 'package:loja_app/helper/user_helper.dart';

import '../model/user.dart';

class LoginController {
  UserHelper con = UserHelper();


  Future<int> saveUser(User user) async {
    var db = await con.db;
    int res = await db.insert('user', user.toMap());
    return res;
  }
  
  Future<bool> dbContainsEmail(String email) async {
    var db = await con.db;
    String sql = """
    SELECT * FROM user WHERE email = '$email' """;

    var res = await db.rawQuery(sql);
   
    if (res.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
  
  Future<int> deleteUser(User user) async {
    var db = await con.db;
    int res = await db.delete("user", where: "id = ?", whereArgs: [user.id]);
    return res;
  }

  Future<User?> getLogin(String email, String password) async {
    var db = await con.db;
    String sql = """
    SELECT * FROM user WHERE email = '$email' AND password = '$password' """;
   
    var res = await db.rawQuery(sql);
   
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    
    return null;//User(id: -1, name: "", email: "", password: "");
  }

  Future<List<User>> getAllUser() async {
    var db = await con.db;
    
    var res = await db.query("user");

    List<User> list = res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];

    return list;
  }
  
}