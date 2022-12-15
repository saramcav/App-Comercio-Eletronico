import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:loja_app/screen/login_screen.dart';
import 'package:loja_app/screen/sign_up_screen.dart';
import "dart:async";
import '../helper/AdvertisementHelper.dart';
import '../model/Advertisement.dart';
import '../model/user.dart';
import "dart:io";
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {

  User? user;

  MainScreen([this.user]);

  @override
  State<StatefulWidget> createState() => _InitState();

}

class _InitState extends State<MainScreen> {
   
  TextEditingController _controllerTask = TextEditingController();
  List<Advertisement> ads=[];
  Map<String, String> filters={
    "state": "Todos",
    "categ": "Todas"
  };
  var _db= AdvertisementHelper();

  List<String> states=[];
  List<String> categories=[];

//fessôr, essa aqui é pra testar tlgd
  void _addSomeAds() async {
    final image = (await rootBundle.load("./images/windows.png"))
    .buffer.asUint8List();

    final image1 = (await rootBundle.load("./images/abobra.jpg"))
    .buffer.asUint8List();

    Advertisement ad1=Advertisement("terreno do windows", "RJ", "terreno",
    2000.0, "21971164461", "é o terreno do windows véi", image);

    Advertisement ad2=Advertisement("Abobrinha brasileirinha", "Manaus", "legume",
    1000000.0, "21971164461", "BRASIIIILLL", image1);

    if(await _db.searchByTitle("terreno do windows"))
      return;

    await _db.insertAd(ad1);
    await _db.insertAd(ad2);

    _getAds();
  }

  void _getAds() async {
    List results=[];

    print(filters);

    if(filters.length==2 && !(["Todos", "None"].contains(filters["state"])) && 
    !(["Todas", "None"].contains(filters["categ"])))
      results = await _db.getFilteredAds(filters["state"]!, filters["categ"]!);

    else if(!(["Todos", "None"].contains(filters["state"]))){
      results = await _db.getFilteredAds(filters["state"]!);
      print("aq");
    }

    else if(!(["Todas", "None"].contains(filters["categ"]!)))
      results = await _db.getFilteredAds("",filters["categ"]!);

    else
      results = await _db.getAds();
    
    ads.clear();

    for (var item in results) {
      Advertisement ad = Advertisement.fromMap(item);
      ads.add(ad);
    }

    states = await _db.getColumn("state");
    states.insert(0, "Todos");
    categories = await _db.getColumn("category");
    categories.insert(0, "Todas");

    print(ads);

    setState(() {});

  }

  Widget listItemCreate(BuildContext context, int index) {
    Advertisement ad=ads[index];
    Image img=ad.getImage(context);

    return Column(children: [
      img,
      Text(ad.title!),
      Text("R\$"+ad.price.toString())
    ],);
  }

  @override
  void initState() {
    super.initState();
    _getAds();
  }

  Widget createDropButton(List<String> options, String title){
    String tag="categ";

    if(title=="Estados") tag="state";

    return Column(children: [
      Text(title),
      DropdownButton<String>(
      value: filters[tag],
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      alignment: Alignment.topCenter,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        filters[tag]=value!;
        _getAds();
      },
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),)
      ]);
  }

  Widget menu(){
    if(widget.user!=null){
      return PopupMenuButton(
          itemBuilder: (context){
            return [
                  PopupMenuItem<int>(
                      value: 0,
                      child: Text("Meus anúncios"),
                  ),

                  PopupMenuItem<int>(
                      value: 1,
                      child: Text("Deslogar"),
                  ),
              ];
          },
          onSelected:(value){
            if(value == 0){
                //ir pro meus alucio
            }else if(value == 1){
                widget.user=null;
                setState(() {});
            }
          }
        );
    }
    return PopupMenuButton(
          itemBuilder: (context){
            return [
                  PopupMenuItem<int>(
                      value: 0,
                      child: Text("Logar"),
                  ),

                  PopupMenuItem<int>(
                      value: 1,
                      child: Text("Cadastrar"),
                  ),
              ];
          },
          onSelected:(value){
            if(value == 0){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => LoginScreen()
                  )
              );
            }else if(value == 1){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => SignUpScreen()
                  )
              );
            }
          }
        );;
  }

  @override
  Widget build(BuildContext context) {
    _addSomeAds();
    _db.getColumn("state");

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de olx"),
        backgroundColor: Color.fromARGB(255, 122, 33, 163),
        actions: [
          menu()
        ],
      ),
      body: Column(children: [
        Row(
          children: [
            Expanded(child: createDropButton(states, "Estados")),
            Expanded(child: createDropButton(categories, "Categorias"))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        Expanded(child: ListView.builder(
          itemCount: ads.length,
          itemBuilder: listItemCreate
        ))
    ]));
  }
}