import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elysium_app/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:elysium_app/services/login_service.dart';
import 'package:elysium_app/ui/dashboard_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map> _getClients() async {
    http.Response response =
        await http.get('https://elysiumsistemas.com.br/api/dados.json');
    return json.decode(response.body);
  }

  LoginService service = LoginService();

  void verificaSeLogado() async {
    await service.getDados().then((valor) {
      var dadosSalvos = json.decode(valor);

      if (dadosSalvos != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    verificaSeLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Elysium APP'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                'Escolha sua escola!',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          Expanded(
              child: FutureBuilder<Map>(
            future: _getClients(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.grey[500]),
                      strokeWidth: 5.0,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Erro de conexão! :('),
                    );
                  }
                  return _createClientsTable(context, snapshot);
              }
            },
          ))
        ],
      ),
    );
  }

  Widget _createClientsTable(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasError) {
      return Container();
    }
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: snapshot.data["dados"].length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Card(
              child: CachedNetworkImage(
              imageUrl: snapshot.data["dados"][index]["url"] + "getLogo",
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
            ),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginPage(snapshot.data["dados"][index])));
            },
          );
        });
  }
}
