import 'package:elysium_app/services/login_service.dart';
import 'package:elysium_app/ui/periodos_page.dart';
import 'package:elysium_app/ui/visualizar_galeria_page.dart';
import 'package:elysium_app/widgets/menu_lateral.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GaleriaIndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GaleriaIndexPage();
}

class _GaleriaIndexPage extends State<GaleriaIndexPage> {
  LoginService loginService = LoginService();

  Future<Map> _dados;

  Future<Map> getDados() async {
    return await loginService.getRequest('api/galeria', context);
  }

  @override
  void initState() {
    // inicializando o objeto da classe Future no initState
    // que é chamado apenas quando o Widget entra pela primeira vez na árvore de widgets
    _dados = getDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuLateral(),
      appBar: AppBar(
        title: Text('Lista de álbuns'),
      ),
      body: FutureBuilder(
          future: _dados,
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
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
                return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: snapshot.data['dados'].length,
                    itemBuilder: (context, index) {
                      return cartao(snapshot.data['dados'][index], context,
                          index, snapshot);
                    });
            }
          }),
    );
  }

  Widget cartao(dados, context, index, snapshot) {
    var autor = "${dados['titulo'].toString().trim()}";
    var titulo = "";
    var mensagem = "${dados['descricao']}";

    mensagem = (mensagem.length <= 28)
        ? mensagem
        : '${mensagem.trim().substring(0, 25)}...';

    titulo =
        (titulo.length <= 28) ? titulo : '${titulo.trim().substring(0, 25)}...';

    FontWeight fontWeight = FontWeight.w400;

    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VisualizarGaleriaPage(dados, snapshot.data['url'])));
        },
        child: Column(children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(left: 14.0, right: 14.0, top: 5.0, bottom: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.photo_size_select_actual),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              autor,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                  fontSize: 17.0),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  mensagem,
                                  style: TextStyle(
                                      fontWeight: fontWeight,
                                      color: Colors.black54,
                                      fontSize: 15.5),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ]));
  }
}
