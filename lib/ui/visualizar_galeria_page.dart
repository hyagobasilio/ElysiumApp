import 'package:cached_network_image/cached_network_image.dart';
import 'package:elysium_app/services/login_service.dart';
import 'package:elysium_app/ui/full_image.dar.dart';
import 'package:elysium_app/widgets/menu_lateral.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VisualizarGaleriaPage extends StatefulWidget {
  Map _dados;
  String url;

  VisualizarGaleriaPage(this._dados, this.url);

  @override
  State<StatefulWidget> createState() => _VisualizarGaleriaPage(_dados, url);
}

class _VisualizarGaleriaPage extends State<VisualizarGaleriaPage> {
  Map _dados;
  String url;

  LoginService loginService = LoginService();

  _VisualizarGaleriaPage(this._dados, this.url);

  @override
  void initState() {
    // TODO: implement initState
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
        title: Text(_dados['titulo']),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Center(
            child: Text(
              _dados['titulo'],
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            _dados['descricao'],
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          _createClientsTable()
        ],
      ),
    );
  }

  getDados() {
    List lista = List<Widget>();
    lista.addAll([
      Center(
        child: Text(
          _dados['titulo'],
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        ),
      ),
      SizedBox(
        height: 15.0,
      ),
      Text(
        _dados['descricao'],
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
      SizedBox(
        height: 15.0,
      )
    ]);
    return lista.toList();
  }

  Widget _createClientsTable() {
    var fotos = _dados['fotos'];
    return Expanded(
        child: GridView.builder(
            padding: EdgeInsets.all(10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0),
            itemCount: fotos.length,
            itemBuilder: (context, index) {
              var urlFoto = "${url}api/galeria/foto/${fotos[index]['id']}";

              return GestureDetector(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: urlFoto,
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                      Divider(),
                      Text(fotos[index]['titulo'])
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return FullScreenPage(urlFoto);
                  }));
                },
              );
            }));
  }
}
