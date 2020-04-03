import 'package:cached_network_image/cached_network_image.dart';
import 'package:elysium_app/services/login_service.dart';
import 'package:elysium_app/ui/full_image.dar.dart';
import 'package:elysium_app/widgets/menu_lateral.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecadosPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecadosPage();
}

class _RecadosPage extends State<RecadosPage> {
  LoginService loginService = LoginService();

  Map _dados;

  Future<Map> _getRecados() async {
    _dados = await loginService.getRequest('/api/comunicados', context);
    return _dados;
  }

  @override
  void initState() {
    // inicializando o objeto da classe Future no initState
    // que é chamado apenas quando o Widget entra pela primeira vez na árvore de widgets
    _getRecados();
    super.initState();
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
  Widget ImagemFromUrl(String nome, String url) {
    if (nome != null && nome.isNotEmpty) {
      if (nome.contains('http')) {
        return GestureDetector(
          child: CachedNetworkImage(
            imageUrl: nome,
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return FullScreenPage(nome);
            }));
          },
        );
      }
      var endereco = "${url}uploads/${nome}";
      return GestureDetector(
        child: CachedNetworkImage(
          imageUrl: endereco,
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return FullScreenPage(endereco);
          }));
        },
      );
    }

    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuLateral(),
      appBar: AppBar(
        title: Text('Recados'),
      ),
      body: FutureBuilder<Map>(
        future: _getRecados(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container(
                width: 200.0,
                height: 200.0,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[500]),
                  strokeWidth: 5.0,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Erro de conexão! :('),
                );
              }
              return _listaRecados(context, snapshot);
          }
        },
      ),
    );
  }

  Widget _listaRecados(BuildContext context, AsyncSnapshot<Map> snapshot) {
    if (snapshot.hasError) {
      return Container();
    }
    return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: snapshot.data["dados"].length,
        itemBuilder: (context, index) {
          var dados = snapshot.data["dados"][index];

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Text(
                      dados['titulo'],
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  ImagemFromUrl(dados['imagem'], snapshot.data['url']),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    dados['conteudo'].toString().trim(),
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
