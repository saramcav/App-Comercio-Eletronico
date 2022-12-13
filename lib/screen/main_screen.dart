import 'package:flutter/material.dart';
import 'package:loja_app/screen/login_screen.dart';
import 'package:loja_app/screen/sign_up_screen.dart';
import "dart:async";
import '../helper/AdvertisementHelper.dart';
import '../model/Advertisement.dart';
import '../model/user.dart';

class MainScreen extends StatefulWidget {

  User? user;

  MainScreen([this.user]);

  @override
  State<StatefulWidget> createState() => _InitState();

}

class _InitState extends State<MainScreen> {
   
  TextEditingController _controllerTask = TextEditingController();
  List<Advertisement> ads=[];

  var _db= AdvertisementHelper();

  void _getAds() async {
    List results = await _db.getAds();
    ads.clear();

    for (var item in results) {
      Advertisement ad = Advertisement.fromMap(item);
      ads.add(ad);
    }

    setState(() {});

  }

  Widget listItemCreate(BuildContext context, int index) {
    Advertisement ad=ads[index];
    String price=ad.price.toString();

    return Row(children: [
      ad.getImage(),
      Column(children: [
        Text(ad.title!),
        Text("R\$$price")
      ],)
    ],);
  }

  @override
  void initState() {
    super.initState();
    _getAds();
  }

  Widget createDropButton(List<String> options, String title){
    String dropdownValue=options.first;
    return Column(children: [
      Text(title),
      DropdownButton<String>(
      value: dropdownValue,
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
        setState(() {
          dropdownValue = value!;
        });
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
                      child: Text("Logá"),
                  ),

                  PopupMenuItem<int>(
                      value: 1,
                      child: Text("Cadastrá"),
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
            Expanded(child: createDropButton(["Todos", "SP", "RJ", "GO", "AC"], "Estados")),
            Expanded(child: createDropButton([ "Todas", "Carro", "telefone"], "Categorias"))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),

    ]));
  }
}