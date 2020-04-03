import 'package:elysium_app/services/login_service.dart';
import 'package:elysium_app/ui/anoletivo_pege.dart';
import 'package:elysium_app/ui/galeria_index.dart';
import 'package:elysium_app/ui/mensagem_page.dart';
import 'package:elysium_app/ui/recados_page.dart';
import 'package:elysium_app/ui/turmas_page.dart';
import 'package:elysium_app/widgets/menu_lateral.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashboardPage();
}

class _DashboardPage extends State<DashboardPage> {
  LoginService loginService = LoginService();
  

  Map _dados;

  Future<void> _launchBrowser() async {
    var url = _dados['url']+'aluno';
    if ( await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false );
    }else {
      throw "Cold not launch $url";
    }
  }

  getDados() async {
    loginService.getUser(context).then((dados) => this._dados = dados);
  }

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      print('Carregando dados!');
    setState(() {
      getDados();
    });
  }
  void _navegarPara(context, pagina) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => pagina));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MenuLateral(),
        appBar: AppBar(
          title: Text('Bem vindo(a)'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 2.0),
          child: _gridView(),
        ));
  }

  Card makeDashboardItem(String title, IconData icon, Function() onTap) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: InkWell(
          onTap: onTap,
          child: new Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 50.0),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.blue,
                )),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style: new TextStyle(fontSize: 18.0, color: Colors.blue)),
                )
              ],
            ),
          ),
        ));
  }


  Widget _gridView() {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(4.0),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        makeDashboardItem('Boletim', Icons.insert_chart, () {
          _navegarPara(context, TurmaPage());
        }),
        makeDashboardItem('Calendário', Icons.calendar_today, () {
          _navegarPara(context, AnoLetivoPage());
        }),
        makeDashboardItem('Agenda', Icons.message, () {
          _navegarPara(context, MensagemPage());
        }),
        makeDashboardItem('Mural de recados', Icons.mail, () {
          _navegarPara(context, RecadosPage());
        }),
        makeDashboardItem('Fotos', Icons.photo, () {
          _navegarPara(context, GaleriaIndexPage());
        }),
        makeDashboardItem('Portal Web', Icons.web_asset,  _launchBrowser),
      ],
    );
  }

  Widget cartao(String titulo, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          titulo,
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          valor,
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(
          height: 5.0,
        )
      ],
    );
  }
}
