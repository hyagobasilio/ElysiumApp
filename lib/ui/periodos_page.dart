import 'package:elysium_app/services/login_service.dart';
import 'package:elysium_app/ui/notas_page.dart';
import 'package:elysium_app/widgets/menu_lateral.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PeriodoPage extends StatefulWidget {
  Map _dados;

  PeriodoPage(this._dados);
  @override
  State<StatefulWidget> createState() => _PeriodoPage(_dados);
}

class _PeriodoPage extends State<PeriodoPage> {
  
  LoginService loginService = LoginService();

  Map _dados;

  _PeriodoPage(this._dados);



  @override
  Widget build(BuildContext context) {

    var _periodos = _dados['ano_letivo']['periodos'];
    
    return Scaffold(
      drawer: MenuLateral(),
      appBar: AppBar(
        title: Text('Periodos'),
      ),
      body: 
      
           ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: _periodos.length,
              itemBuilder: (context, index) {
                
                return cartao(_periodos[index], context,
                    index);
              })
    );
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
    );

  Widget cartao(periodo, context, index) {
    var autor = periodo['abreviacao'];
    var titulo = periodo['titulo'];
    var mensagem = "${periodo['inicio']} - ${periodo['fim']}";
    
    mensagem = (mensagem.length <= 28)
        ? mensagem
        : '${mensagem.trim().substring(0, 25)}...';

    titulo =
        (titulo.length <= 28) ? titulo : '${titulo.trim().substring(0, 25)}...';

    FontWeight fontWeight = FontWeight.w400;

    return InkWell(
        onTap: () {
          if (periodo['is_avaliado'] && _dados['formula_id'] != null && !_dados['is_sala_recurso']) {
            Navigator.push(this.context,
                  MaterialPageRoute(builder: (BuildContext context) => NotaPage(_dados, index, periodo)));
          }
        },
        child: Column(children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(left: 14.0, right: 14.0, top: 5.0, bottom: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: periodo['is_avaliado'] ? Colors.blue : Colors.grey,
                  child: Text('P', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500,
                  color: Colors.white),),
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
