import 'package:cached_network_image/cached_network_image.dart';
import 'package:elysium_app/services/login_service.dart';
import 'package:elysium_app/ui/full_image.dar.dart';
import 'package:elysium_app/widgets/menu_lateral.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnoLetivoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnoLetivoPage();
}

class _AnoLetivoPage extends State<AnoLetivoPage> {
  LoginService loginService = LoginService();

  Map _dados;

  Future<Map> _getAnoLetivo() async {
    _dados = await loginService.getRequest('/api/anoLetivo', context);
    return _dados;
  }

  @override
  void initState() {
    // inicializando o objeto da classe Future no initState
    // que é chamado apenas quando o Widget entra pela primeira vez na árvore de widgets
    _getAnoLetivo();
    super.initState();
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuLateral(),
      appBar: AppBar(
        title: Text('Ano Letivo'),
      ),
      body: FutureBuilder<Map>(
        future: _getAnoLetivo(),
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
              if(snapshot.hasError) {
                return Center(child: Text('Erro de conexão! :('),);
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
          var periodos = dados['periodos'];

          List<Widget> _lista = _periodos(periodos);
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Text(
                      dados['ano_letivo'].toString(),
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "${dados['data_inicio']} - ${dados['data_fim']}",
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  ImagemFromUrl(context, dados['imagem'], snapshot.data['url']),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    'Periodos',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Column(
                    children: _lista,
                  )
                ],
              ),
            ),
          );
        });
  }

  List<Widget> _periodos(dados) {
    List<Widget> lista = List<Widget>();

    for (int i = 0; i < dados.length; i++) {
      lista.add(getTextoPeriodo(dados[i]));
    }
    return lista;
  }

  Text getTextoPeriodo(dado) {
    return Text("${dado['abreviacao']} - ${dado['inicio']} - ${dado['fim']}");
  }

  Widget ImagemFromUrl(context, String nome, String url) {
    if (nome != null && nome.isNotEmpty) {
      url = "${url}uploads/${nome}";
      return GestureDetector(
        child: CachedNetworkImage(imageUrl: url,),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return FullScreenPage(url);
          }));
        },
      );
    }

    return Text('');
  }
}
