import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loja_app/model/Advertisement.dart';
import 'package:loja_app/model/user.dart';
import 'package:loja_app/helper/AdvertisementHelper.dart';
import 'package:loja_app/screen/description_screen.dart'; 

class MyAds extends StatefulWidget {

  User? user;
  MyAds([this.user]);

  @override
  State<StatefulWidget> createState() => _InitState();

}

class _InitState extends State<MyAds> {

  List<Advertisement> ads=[];
  var _db= AdvertisementHelper();

  XFile? image;
  Uint8List? defaultImg;

  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _getAds() async {
    List results=[];

    results = await _db.getAds();
    
    ads.clear();

    for (var item in results) {
      Advertisement ad = Advertisement.fromMap(item);
      ads.add(ad);
    }

    setState(() {});

  }

  void _saveAd() async {
    Uint8List? img_bytes = image==null? defaultImg: await image!.readAsBytes();

    Advertisement nova = Advertisement(_titleController.text, _stateController.text, _categoryController.text,
    double.parse(_priceController.text), _telephoneController.text, _descriptionController.text,"", img_bytes);
    
    int result = await _db.insertAd(nova);
  
    _getAds();
  }

  void _removeAd(int index) async {
      await _db.deleteAd(ads[index].id!);

    _getAds();
  }

  void _editAd(int index) async {

    ads[index].title = _titleController.text;
    ads[index].state = _stateController.text;
    ads[index].category = _categoryController.text;
    ads[index].price = double.parse(_priceController.text);
    ads[index].telephone = _telephoneController.text;
    ads[index].description = _descriptionController.text;
    ads[index].photo = image == null? defaultImg : await image!.readAsBytes();
    
    await _db.updateAd(ads[index]);

    _getAds();
  }

  @override
  void initState() {
    super.initState();
    _getAds();
  }

  descriptionRoute(Advertisement advertisement) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => DescriptionScreen(advertisement),
      )
    );
  }

  void _pop_up(int index, bool edit) async {
    ImagePicker picker = ImagePicker();
    bool _pass = true;
    defaultImg = (await rootBundle.load("./images/noimage.png")).buffer.asUint8List();
    image = null;

    if(!edit) {
      _stateController.clear();
      _categoryController.clear();
      _titleController.clear();
      _priceController.clear();
      _telephoneController.clear();
      _descriptionController.clear();
    }

    else{
      _titleController.text = ads[index].title!;
      _stateController.text = ads[index].state!;
      _categoryController.text = ads[index].category!;
      _priceController.text = ads[index].price.toString();
      _telephoneController.text = ads[index].telephone!;
      _descriptionController.text = ads[index].description!;
    }

    var S1 = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Criar anúncio"),
          content: Column(
            mainAxisSize: MainAxisSize.min, 
                    
            children: [
              TextField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Título", hintText: "Digite o título"
                ),
              ),
              TextField(
                controller: _descriptionController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Descrição", hintText: "Digite a descrição"
                ),
              ),
            ],
          ), 
          actions: [
            TextButton(
              onPressed: () {
                _pass = false;
                Navigator.pop(context);
              },
              child: Text("Cancelar")
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Próximo")
            ),
          ],
        );
      },
    );

    if (!_pass) return;

    var S2 = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Criar anúncio"),
          content: Column(
            mainAxisSize: MainAxisSize.min, 
                    
            children: [
              TextField(
                controller: _stateController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Estado", 
                  hintText: "Digite o estado"
                ),
              ),
              TextField(
                controller: _categoryController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Categoria", 
                  hintText: "Digite a categoria"
                ),
              ),
            ],
          ), 
          actions: [
            TextButton(
              onPressed: () {
                _pass = false;
                Navigator.pop(context);
              },
              child: Text("Cancelar")
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Próximo")
            ),
          ],
        );
      },
    );

    if (!_pass) return;

    var S3 = await showDialog(
      context: context,
      builder: (context) {
      return AlertDialog(
        title: Text("Criar anúncio"),
        content: Column(
          mainAxisSize: MainAxisSize.min, 
                      
          children: [
            TextField(
              controller: _priceController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Preço", hintText: "Digite o preço"
              ),
            ),
            TextField(
              controller: _telephoneController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Telefone", hintText: "Digite o telefone de contato"
              ),
            ),
          ],
        ), 
        actions: [
          TextButton(
            onPressed: () {
              _pass = false;
              Navigator.pop(context);
            },
            child: Text("Cancelar")
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Próximo")
          ),
        ],
        );
      },
    );
    
    if (!_pass) return;

    image = await picker.pickImage(source: ImageSource.gallery);

    if (!edit) _saveAd();
    else _editAd(index);
  }

  Widget listItemCreate(BuildContext context, int index) {
    
    Advertisement ad=ads[index];
    Image img=ad.getImage(context);

    return GestureDetector(
      onTap: () => descriptionRoute(ad),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), 
        ),
        shadowColor: Colors.purple.shade200,
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all(width: 5, color: Colors.white)),
              child: Image(
              image: img.image,
              // 
              fit: BoxFit.cover, 
              width: MediaQuery.of(context).size.width, 
              height: MediaQuery.of(context).size.width*0.5,
            )),
            const SizedBox(height: 7,),
            Text(
                ad.title!,
                style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w400, 
                ),
            ),
            const SizedBox(height: 7,),
            Text(
              "R\$"+ad.price.toString(),
              style: TextStyle(
                color: Colors.purple.shade700,  
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 7,),
            Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                icon: const Icon(Icons.edit, color: Colors.purple,),
                tooltip: 'Editar anúncio',
                onPressed: () async {
                  _pop_up(index,true);
                }),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.purple,),
                tooltip: 'Deletar anúncio',
                onPressed: () {
                  _removeAd(index);
                },
            ),
            ]),
            ),
            const SizedBox(height: 7,),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meus Anúncios",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: Colors.purple.shade700,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        onPressed: () => _pop_up(-1, false)
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          shrinkWrap: true,
          itemCount: ads.length,
          itemBuilder: listItemCreate
        ),
      ),
    );
  }
}