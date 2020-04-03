import 'package:elysium_app/services/login_service.dart';
import 'package:elysium_app/ui/visualizar_mensagem.dart';
import 'package:elysium_app/widgets/menu_lateral.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MensagemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MensagemPage();
}

class _MensagemPage extends State<MensagemPage> {
  LoginService loginService = LoginService();

  Future<Map> _dados;

  Future<Map> getDados() async {
    return await loginService.getMensagens(context);
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
        title: Text('Mensagens'),
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
    var titulo = dados['titulo'];
    var mensagem = dados['mensagem'];
    var autor = dados['autor'];
    bool lida = dados['visualizada'];
    bool resposta = dados['resposta'];
    final bool isPergunta = dados['is_pergunta'];

    var arrayNome = autor.split(' ');
    autor = "${arrayNome[0]} ${arrayNome[arrayNome.length - 1]}";

    mensagem = (mensagem.length <= 28)
        ? mensagem
        : '${mensagem.trim().substring(0, 25)}...';

    titulo =
        (titulo.length <= 28) ? titulo : '${titulo.trim().substring(0, 25)}...';

    var date = DateTime.parse(dados['data']['date']);
    var formatador = DateFormat('d MMM');

    String data = formatador.format(date);

    FontWeight fontWeight = (lida) ? FontWeight.w400 : FontWeight.bold;

    return InkWell(
        onTap: () {
          snapshot.data['dados'][index]['visualizada'] = true;
          lida = true;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VisualizarMensagemPage(dados)));
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
                  child: Text(
                    autor.toString().trim().substring(0, 1),
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
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
                            Text(
                              data,
                              style: TextStyle(
                                  fontWeight: fontWeight,
                                  color: Colors.black54,
                                  fontSize: 13.5),
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
                                  titulo,
                                  style: TextStyle(
                                      fontWeight: fontWeight,
                                      color: Colors.black54,
                                      fontSize: 15.5),
                                ),
                                Text(
                                  mensagem,
                                  style: TextStyle(
                                      fontWeight: fontWeight,
                                      color: Colors.black54,
                                      fontSize: 15.5),
                                )
                              ],
                            ),
                            !isPergunta
                                ? null
                                : resposta
                                    ? Icon(
                                        Icons.help_outline,
                                        size: 25.0,
                                        color: Colors.green,
                                      )
                                    : Icon(
                                        Icons.help_outline,
                                        size: 25.0,
                                        color: Colors.red,
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
