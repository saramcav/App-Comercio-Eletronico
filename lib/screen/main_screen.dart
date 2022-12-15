import 'package:flutter/material.dart';
import 'package:loja_app/screen/login_screen.dart';
import 'package:loja_app/screen/sign_up_screen.dart';
import 'package:loja_app/screen/description_screen.dart';
import '../helper/AdvertisementHelper.dart';
import '../model/Advertisement.dart';
import '../model/user.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {

  User? user;

  MainScreen([this.user]);

  @override
  State<StatefulWidget> createState() => _InitState();

}

class _InitState extends State<MainScreen> {
   
  //TextEditingController _controllerTask = TextEditingController();
  
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

    final image1 = (await rootBundle.load("./images/abobora.jpg"))
    .buffer.asUint8List();

    Advertisement ad1=Advertisement("terreno do windows", "RJ", "terreno",
    2000.0, "21971164461", "é o terreno do windows véi", image);

    Advertisement ad2=Advertisement("Abobrinha brasileirinha", "Manaus", "legume",
    1000000.0, "21971164461", "BRASIIIILLL", image1);

    if(await _db.searchByTitle("terreno do windows"))
      {return;}

    await _db.insertAd(ad1);
    await _db.insertAd(ad2);

    _getAds();
  }

  void _getAds() async {
    List results=[];

    print(filters);

    if(filters.length==2 && !(["Todos", "None"].contains(filters["state"])) && 
    !(["Todas", "None"].contains(filters["categ"])))
      {results = await _db.getFilteredAds(filters["state"]!, filters["categ"]!);}

    else if(!(["Todos", "None"].contains(filters["state"])))
      {results = await _db.getFilteredAds(filters["state"]!);}

    else if(!(["Todas", "None"].contains(filters["categ"]!)))
      {results = await _db.getFilteredAds("",filters["categ"]!);}

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

    print(ads);

    setState(() {});

  }

  Widget listItemCreate(BuildContext context, int index) {
    Advertisement ad=ads[index];
    Image img=ad.getImage(context);

    return GestureDetector(
      onTap: () => descriptionRoute(),
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
      padding: const EdgeInsets.only(left: 25.0, right: 20.0),
      child: Row(
        children: [
          Text(title),
          const SizedBox(width: 10,),
          DropdownButton<String>(
            value: filters[tag],
            icon: const Icon(Icons.arrow_downward),
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
                child: Text(value),
              );
            }).toList(),
          ),
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
                  const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Logar"),
                  ),

                  const PopupMenuItem<int>(
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

  descriptionRoute([Advertisement? advertisement]) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => DescriptionScreen(advertisement),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    _addSomeAds();
    _db.getColumn("state");

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
        backgroundColor: Colors.purple.shade700,
        actions: [
          menu()
        ],
      ),
      body: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: createDropButton(states, "Estados")),
                VerticalDivider(color: Colors.purple.shade800, thickness: 1.5, width: 0,),
                Expanded(child: createDropButton(categories, "Categorias"))
              ],  
            ),
          ),
          Divider(color: Colors.purple.shade800, height: 0,thickness: 1,),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Expanded(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                shrinkWrap: true,
                itemCount: ads.length,
                itemBuilder: listItemCreate
              ),
            ),
          ),
        ],
      ),
    );
  }
}