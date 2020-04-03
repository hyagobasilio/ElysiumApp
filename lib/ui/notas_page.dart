import 'package:elysium_app/services/login_service.dart';
import 'package:elysium_app/widgets/menu_lateral.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotaPage extends StatefulWidget {
  Map _dados;
  int _index;
  Map _periodo;

  NotaPage(this._dados, this._index, this._periodo);

  @override
  State<StatefulWidget> createState() => _NotaPage(_dados, _index, _periodo);
}

class _NotaPage extends State<NotaPage> {
  LoginService loginService = LoginService();

  Map _dados;
  int index;
  Map _periodo;

  _NotaPage(this._dados, this.index, this._periodo);

  Future<Map> getDados() async {
    final String url =
        "api/getBoletim/turma/${_dados['id']}/periodo/${_periodo['id']}";
    return await loginService.getRequest(url, context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MenuLateral(),
        appBar: AppBar(
          title: Text(_periodo['titulo']),
        ),
        body: FutureBuilder(
            future: getDados(),
            builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
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
                  if(snapshot.hasError) {
                    return Center(child: Text('Usuario não logado'),);
                  }
                  return _CriarTabela(snapshot.data['dados']);
              }
            }));
  }

  Widget _CriarTabela(dados) {
    List<DataColumn> cols = List<DataColumn>();
    List<DataRow> rows = List<DataRow>();

    int x = 1;
    dados.forEach((v) {
      if (x == 1) {
        v.forEach((item) {

          cols.add(DataColumn(label: Text(item ?? '')));
        });
      } else {
        List<DataCell> dataCell = List<DataCell>();
        v.forEach((item) {
          dataCell.add(DataCell(Text(item ?? ' - ')));
        });

        rows.add(DataRow(cells: dataCell.toList()));
      }
      x++;
    });

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(columns: cols.toList(), rows: rows.toList())),
    );
  }
}
