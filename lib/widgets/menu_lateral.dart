import 'package:elysium_app/services/login_service.dart';
import 'package:elysium_app/ui/anoletivo_pege.dart';
import 'package:elysium_app/ui/dashboard_page.dart';
import 'package:elysium_app/ui/galeria_index.dart';
import 'package:elysium_app/ui/mensagem_page.dart';
import 'package:elysium_app/ui/recados_page.dart';
import 'package:elysium_app/ui/turmas_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MenuLateral extends StatefulWidget {
  @override
  _MenuLateral createState() => _MenuLateral();
}

class _MenuLateral extends State<MenuLateral> {
  LoginService loginService = LoginService();

  Future<Map> _dados;

  Future<Map> getDados() async {
    return await loginService.getUser(context);
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
    // TODO: implement build
    return Drawer(
      child: FutureBuilder(
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
                    child:  Text('Usuário não logado!'),
                  );
                }
                return ListView(
                  children: <Widget>[
                    new UserAccountsDrawerHeader(
                      accountName: new Text(snapshot.data['dados']['name']),
                      accountEmail: new Text(snapshot.data['dados']['email']),
                      currentAccountPicture: new CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data['url'] +
                            'uploads/fotos-aluno/' +
                            snapshot.data['dados']['foto']),
                      ),
                    ),
                    ItemList(
                        'Início', Icon(Icons.home), DashboardPage(), context),
                    ItemList('Boletim', Icon(Icons.table_chart), TurmaPage(),
                        context),
                    ItemList('Calendário', Icon(Icons.calendar_today),
                        AnoLetivoPage(), context),
                    ItemList(
                        'Agenda', Icon(Icons.message), MensagemPage(), context),
                    ItemList('Mural de recados', Icon(Icons.mail),
                        RecadosPage(), context),
                    ItemList(
                        'Fotos', Icon(Icons.photo), GaleriaIndexPage(), context),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: new Text('Sair'),
                      onTap: () {
                        LoginService.logout(context);
                      },
                    )
                  ],
                );
            }
          }),
    );
  }

  Widget ItemList(String titulo, Icon icone, Widget pagina, context) {
    return new ListTile(
      leading: icone,
      title: new Text(titulo),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (BuildContext context) => pagina));
      },
    );
  }
}
