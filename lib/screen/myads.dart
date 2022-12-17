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

//essa pagina exibe os anuncios do usuario atual que esta logado
//nela, ha opcao de editar e criar um anuncio
class _InitState extends State<MyAds> {

  List<Advertisement> ads=[];
  var _db= AdvertisementHelper();

  //imagem que pegamos da galeria
  XFile? image;
  //utilizamos esse tipo para guardar no bd
  Uint8List? defaultImg;
  
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  //le o banco de dados, cria instancias de anuncios, guarda-os na lista ads e atualiza a tela
  void _getAds() async {
    
    List results=[];

    results = await _db.getAds({
      "author":widget.user!.name
    });
    
    ads.clear();

    for (var item in results) {
      Advertisement ad = Advertisement.fromMap(item);
      ads.add(ad);
    }

    setState(() {});

  }

  //chama a funcao do bd que insere
  //caso a imagem seja nula, cria um anuncio com a imagem default
  //chamada pela insercao e edicao
  void _saveAd() async {
    Uint8List? img_bytes = image == null? defaultImg : await image!.readAsBytes();

    print(widget.user!.name);

    Advertisement nova = Advertisement(_titleController.text, _stateController.text, _categoryController.text,
      double.parse(_priceController.text), _telephoneController.text, _descriptionController.text,
      widget.user!.name, img_bytes);
    
    int result = await _db.insertAd(nova);
  
    _getAds();
  }

  //chama a funcao do bd que remove quando clicam no icon
  void _removeAd(int index) async {
      await _db.deleteAd(ads[index].id!);

    _getAds();
  }

  //chama a funcao do bd que edita o anuncio
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

  //funcao de mudanca de tela
  descriptionRoute(Advertisement advertisement) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => DescriptionScreen(advertisement),
      )
    );
  }

  //edita ou insere, a depender de onde foi chamada
  //e acionada quando clicam no floatting button
  void _pop_up(int index, bool edit) async {
    ImagePicker picker = ImagePicker();
    bool _pass = true;
    defaultImg = (await rootBundle.load("./images/noimage.png")).buffer.asUint8List();
    image = null;
    String? alertTitle;

    //limpando controllers para a insercao
    if(!edit) {
      _stateController.clear();
      _categoryController.clear();
      _titleController.clear();
      _priceController.clear();
      _telephoneController.clear();
      _descriptionController.clear();
      alertTitle = "Crie o anúncio";
    }

    //salvando dadosa atuais para a edicao
    else{
      _titleController.text = ads[index].title!;
      _stateController.text = ads[index].state!;
      _categoryController.text = ads[index].category!;
      _priceController.text = ads[index].price.toString();
      _telephoneController.text = ads[index].telephone!;
      _descriptionController.text = ads[index].description!;
      alertTitle = "Edite o anúncio";
    }

    //showdialog em que a pessoa insere os novos dados do anuncio (nome, titulo, etc)
    var sd = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            alertTitle!,
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,        
              children: [
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  cursorColor: Colors.purple,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    labelText: "Título", 
                    hintText: "Digite o título"
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  maxLength: 200,
                  cursorColor: Colors.purple,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: "Descrição", 
                    hintText: "Digite a descrição"
                  ),
                ),
                TextField(
                  controller: _stateController,
                  autofocus: true,
                  maxLength: 2,
                  cursorColor: Colors.purple,
                  decoration: const InputDecoration(
                    labelText: "Estado", 
                    hintText: "Digite uma Sigla",
                  ),
                ),
                TextField(
                  controller: _categoryController,
                  maxLength: 20,
                  autofocus: true,
                  cursorColor: Colors.purple,
                  decoration: const InputDecoration(
                    labelText: "Categoria", 
                    hintText: "Digite a categoria"
                  ),
                ),
                TextField(
                controller: _priceController,
                autofocus: true,
                cursorColor: Colors.purple,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                maxLength: 20,
                decoration: const InputDecoration(
                  labelText: "Preço", 
                  hintText: "Digite o preço"
                ),
              ),
              TextField(
                controller: _telephoneController,
                autofocus: true,
                maxLength: 11,
                cursorColor: Colors.purple,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hoverColor: Colors.purple,
                  labelText: "Telefone", hintText: "Digite o telefone de contato"
                ),
              ),
              ],
            ), 
          ),
          actions: [
            TextButton(
              onPressed: () {
                _pass = false;
                Navigator.pop(context);
              },
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.purple),
      
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Escolher imagem",
                style: TextStyle(color: Colors.purple),
              ),
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

  //cria cards para cada anuncio que contem foto, nome e preco
  Widget listItemCreate(BuildContext context, int index) {
    
    Advertisement ad = ads[index];
    Image img = ad.getImage(context);

    //ao clicar em algum card, sera redirecionado para a tela de descricao,
    //passando o anuncio referente ao index clicado
    //assim o usuario visualizara o proprio anuncio  
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
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5, 
                  color: Colors.white)
              ),
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
            //icones de botoes que chamam a funcao de editar ou deletar
            Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                icon: const Icon(Icons.edit, color: Colors.green,),
                tooltip: 'Editar anúncio',
                onPressed: () async {
                  _pop_up(index,true);
                }),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red,),
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
      //botao que adiciona um anuncio
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