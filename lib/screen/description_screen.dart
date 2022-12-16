import 'package:flutter/material.dart';
import 'package:loja_app/model/Advertisement.dart';
import 'package:url_launcher/url_launcher.dart';

class DescriptionScreen extends StatefulWidget {

  Advertisement advertisement;

  DescriptionScreen(this.advertisement);

  @override
  State<StatefulWidget> createState() => _InitState();

}

//essa pagina recebe um Advertisement como parametro em seu construtor
//a partir do widget, sao acessados seus atributos para que sejam exibidos na tela 
class _InitState extends State<DescriptionScreen> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mais Informações",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: Colors.purple.shade700,
      ),
      body: Column(
        children: <Widget>[
          //caixa roxa que contem a imagem, o titulo, 
          //e uma caixa branca que contem categoria, estado, o preco e o dono do anuncio
          Container(
            height: 350,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(70)
              ),
              color: Colors.purple,
              gradient: LinearGradient(
                colors:  [Colors.purple.shade300, Colors.purple.shade800],
                begin: Alignment.topCenter,
                end:  Alignment.bottomCenter
              ),
            ),
            child: Container(
              width: double.infinity,
              height: 400,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    
                    //exibindo imagem do anuncio
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), 
                        side: BorderSide(
                          color: Colors.white, 
                          width: 1.5,
                        ),
                      ),
                      shadowColor: Colors.purple.shade200,
                      elevation: 5,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image(
                        image: widget.advertisement.getImage(context).image, 
                        fit: BoxFit.cover, 
                        width: MediaQuery.of(context).size.width*0.9, 
                        height: MediaQuery.of(context).size.width*0.5,)
                    ),
                    SizedBox(height: 10.0,),

                    //exibindo titulo do anuncio
                    Text(
                      "${widget.advertisement.title}",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10.0),

                     //exibindo caixa que contem categoria, estado, o preco e o vendedor do anuncio
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ), 
                      ),
                      color: Colors.white,
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 22.0),
                        child: Row(
                          children: <Widget>[
                            //coluna da categoria
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Categoria",
                                    style: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text(
                                    "${widget.advertisement.category}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            //coluna do estado
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Estado",
                                    style: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text(
                                    "${widget.advertisement.state}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            //coluna do preco
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Preço",
                                    style: TextStyle(
                                      color:Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text(
                                    "${widget.advertisement.price}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //coluna do vendedor 
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Vendedor",
                                    style: TextStyle(
                                      color:Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text(
                                    "${widget.advertisement.author}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //caixa que contem a descricao do anuncio
          Container(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Descrição:",
                  style: TextStyle(
                    color: Colors.purple,
                    fontStyle: FontStyle.normal,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 15,),
                Text(
                  "${widget.advertisement.description}",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),      
          ),
          SizedBox(height: 20.0,),

          //botao de ligar que faz a integracao com o telefone do celular passando o telefone do anuncio como url
          GestureDetector(
            onTap: () async => launchUrl(Uri(scheme: 'tel', path: '${widget.advertisement.telephone}')),
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
              padding: const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:  [Colors.purple, Colors.purple.shade800],
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
              child: const Text(
                "Ligar",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}