import 'package:elysium_app/services/login_service.dart';
import 'package:elysium_app/widgets/menu_lateral.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VisualizarMensagemPage extends StatefulWidget {
  Map _dados;
  VisualizarMensagemPage(this._dados);

  @override
  State<StatefulWidget> createState() => _VisualizarMensagemPage(_dados);
}

class _VisualizarMensagemPage extends State<VisualizarMensagemPage> {
  Map _dados;

  LoginService loginService = LoginService();

  _VisualizarMensagemPage(this._dados);

  bool _voto;
  String _textoVoto = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    loginService
        .postRequest("/api/mensagens/visualizar/${_dados['id']}", context);
    
    setState(() {
      _voto = this._dados['resposta'];

      if (_dados['is_pergunta']) {
        if (_voto == null) {
          _textoVoto = 'Voçê ainda não votou!';
        } else {
          _textoVoto = 'Você votou: ';
        }
      } else {
        _textoVoto = '';
      }
    });
  }

  Widget widgetVoto(dados, voto) {
    if (dados['is_pergunta']) {
      if (voto == null) {
        return Text('');
      } else {
        return Text(
          voto ? 'Sim' : 'Não',
          style: TextStyle(fontWeight: FontWeight.bold, color: voto ? Colors.green : Colors.red),
        );
      }
    }
    return Text('');
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  void _votar(voto) async {
    await loginService
        .postRequest("/api/mensagens/responder/${_dados['id']}", context, body: { voto ? "resposta": "sem_resposta": "responsta" });
    setState(() {
      _voto = voto;
    });
    displayDialog(context, 'Sucesso!', 'Voto registrado com sucesso!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuLateral(),
      appBar: AppBar(
        title: Text('Mensagens'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Text(
                    _dados['titulo'],
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  _dados['mensagem'],
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: <Widget>[
                    Text(_textoVoto),
                    widgetVoto(_dados, _voto)
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                _dados['is_pergunta'] ? RaisedButton(
                  color: Colors.greenAccent,
                  onPressed: () {
                    _votar(true);
                  },
                  child: Text('Votar Sim!'),
                ) : null,
                _dados['is_pergunta'] ? RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    _votar(false);
                  },
                  child: Text('Votar Não!'),
                ) : null
              ],
            ),
          ),
        ),
      ),
    );
  }
}
