import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loja_app/screen/login_screen.dart';
import 'package:loja_app/screen/sign_up_screen.dart';
import 'package:loja_app/screen/description_screen.dart';
import '../screen/myads.dart';
import '../helper/AdvertisementHelper.dart';
import '../model/Advertisement.dart';
import '../model/user.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class MainScreen extends StatefulWidget {

  User? user;

  MainScreen([this.user]);

  @override
  State<StatefulWidget> createState() => _InitState();

}

class _InitState extends State<MainScreen> {
  
  List<Advertisement> ads=[];
  Map<String, String> filters={
    "state": "Todos",
    "categ": "Todas"
  };
  var _db= AdvertisementHelper();

  List<String> states=[];
  List<String> categories=[];

  bool initialized=false;

//fessôr, essa aqui é pra testar tlgd
  void _addSomeAds() async{
    _db.deleteAds();

    final  json=jsonDecode(await DefaultAssetBundle.of(context)
      .loadString("lib/initial_advertisements.json"));

    for(Map ad in json["advertisements:"]){

      if(await _db.searchByTitle(ad["title"])) {continue;}

      ad["photo"] = (await rootBundle.load(ad["photo"]))
        .buffer.asUint8List();
      ad["id"]=null;

      Advertisement atual=Advertisement.fromMap(ad);

      await _db.insertAd(atual);
    }
    
    _getAds();
  }

  void _getAds() async {
    List results=[];

    if(filters.length==2 && !(["Todos", "None"].contains(filters["state"])) && 
    !(["Todas", "None"].contains(filters["categ"]))){
      results = await _db.getAds({
        "state":filters["state"],
        "category":filters["categ"]
      });
    }

    else if(!(["Todos", "None"].contains(filters["state"]))){
      print(filters[0]);
      results = await _db.getAds({
        "state" :filters["state"]
      });
    }

    else if(!(["Todas", "None"].contains(filters["categ"]!))){
      results = await _db.getAds({
        "category":filters["categ"]
      });
    }

    else
      {results = await _db.getAds();}
    
    ads.clear();

    for (var item in results) {
      Advertisement ad = Advertisement.fromMap(item);
      ads.add(ad);
    }

    states = await _db.getColumn("state");
    states.insert(0, "Todos");
    categories = await _db.getColumn("category");
    categories.insert(0, "Todas");

    setState(() {});

  }

  Widget listItemCreate(BuildContext context, int index) {
    Advertisement ad=ads[index];
    Image img=ad.getImage(context);

    return GestureDetector(
      onTap: () => descriptionRoute(ad),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), 
        ),
        shadowColor: Colors.purple.shade200,
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Image(
              image: img.image, 
              fit: BoxFit.cover, 
              width: MediaQuery.of(context).size.width, 
              height: MediaQuery.of(context).size.width*0.5,
            ),
            const SizedBox(height: 7,),
            Text(
              ad.title!,
              style: const TextStyle(
                fontWeight: FontWeight.w400
              ),
            ),
            const SizedBox(height: 7,),
            Text(
              "R\$"+ad.price.toString(),
              style: TextStyle(
                color: Colors.purple.shade800, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 7,),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getAds();
  }

  Widget createDropButton(List<String> options, String title){
    String tag="categ";

    if(title=="Estados") tag="state";

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:  [Colors.purple.shade400, Colors.purple.shade600],
          begin: Alignment.centerLeft,
          end:  Alignment.centerRight
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [BoxShadow(
          offset: const Offset(0, 10),
          blurRadius: 50,
          color: Colors.purple.shade300
        )],
      ),
      child: Row(
        children: [
          Text(title, style: TextStyle(color: Colors.white),),
          const SizedBox(width: 10,),
          Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.purple.shade200,
                  ),
                  child: DropdownButton<String>(
            borderRadius:BorderRadius.circular(10),
            value: filters[tag],
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white,),
            elevation: 16,
            alignment: Alignment.topCenter,
            style: const TextStyle(color: Colors.deepPurple),
            onChanged: (String? value) {
              filters[tag]=value!;
              _getAds();
            },
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white),),
              );
            }).toList(),
          ),),
        ],
      ),    
    );
  }

  Widget menu(){
    if(widget.user!=null){
      return PopupMenuButton(
          itemBuilder: (context){
            return [
                  PopupMenuItem<int>(
                      value: 0,
                      child: ListTile(
                        leading: Icon(Icons.visibility, color: Colors.purple.shade800,),
                        title: const Text("Meus Anúncios"),
                      ),
                  ),

                  PopupMenuItem<int>(
                      value: 1,
                      child: ListTile(
                        leading: Icon(Icons.logout, color: Colors.purple.shade800,),
                        title: const Text("Deslogar"),
                      ),
                  ),
              ];
          },
          onSelected:(value){
            if(value == 0){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => MyAds(widget.user),
                )
              );
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
                      child: ListTile(
                        leading: Icon(Icons.login, color: Colors.purple.shade800,),
                        title: const Text("Logar"),
                      ),
                  ),

                  PopupMenuItem<int>(
                      value: 1,
                      child: ListTile(
                        leading: Icon(Icons.person, color: Colors.purple.shade800,),
                        title: const Text("Cadastrar"),
                      ),
                  ),
              ];
          },
          onSelected:(value){
            if(value == 0){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const LoginScreen()
                  )
              );
            } else if(value == 1){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const SignUpScreen()
                  )
              );
            }
          }
        );
  }

  //funcao de mudanca de tela
  descriptionRoute(Advertisement advertisement) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => DescriptionScreen(advertisement),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if(!initialized){
      _addSomeAds();
      initialized=true;
    }
    _db.getColumn("state");

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Para Você",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: Colors.purple.shade700,
        actions: [
          menu()
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            child:Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: createDropButton(states, "Estados")),
                SizedBox(width: 8,),
                Expanded(child: createDropButton(categories, "Categorias"))
              ],  
            ),
          )),
          Container(
            padding: const EdgeInsets.fromLTRB(10.0,50.0,10.0,10.0),
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: ads.length,
                itemBuilder: listItemCreate
              ),
            ),
        ],
      ),
    );
  }
}