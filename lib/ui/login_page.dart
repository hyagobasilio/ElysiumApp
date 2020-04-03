import 'dart:convert';
import 'package:elysium_app/bloc/login_bloc.dart';
import 'package:elysium_app/services/login_service.dart';
import 'package:elysium_app/ui/dashboard_page.dart';
import 'package:elysium_app/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class LoginPage extends StatefulWidget {
  Map dados;
  LoginPage(this.dados);

  
  @override
  State<StatefulWidget> createState() => _LoginPageState(dados);
}

class _LoginPageState extends State<LoginPage> {
  Map _dados;
  TextStyle style = TextStyle(fontSize: 20.0);
  _LoginPageState(this._dados);
  final _loginBloc = LoginBloc();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginService service = LoginService();

  void verificaSeLogado() async {
    var urlEscolhida = _dados['url'];
    await service.getDados().then((valor) {
      print('pagina iniciada..............');

      var dadosSalvos = json.decode(valor);
      
      if (dadosSalvos != null && urlEscolhida  == dadosSalvos['url'] && dadosSalvos['status']) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage()));
      }
    });
  }

   @override
  void initState() {
    // inicializando o objeto da classe Future no initState
    // que é chamado apenas quando o Widget entra pela primeira vez na árvore de widgets
    verificaSeLogado();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
    );
    void attemptSignUp(String username, String password, String url) async {
      var res = await http.post(
        '$url/api/login',
        body: {
          "email": username.trim(),
          "password": password
        }
      );

      var jsonDados = json.decode(res.body);
      if(jsonDados['status']) {
        jsonDados['dados']['url'] = _dados['url'];
        service.logar(jsonDados);
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => DashboardPage()));
      }
      displayDialog(context, 'Login', jsonDados['message']);
    }
    void _logar(){
      final email = _usernameController.text;
      final senha = _passwordController.text;
      
      attemptSignUp(email, senha, _dados['url']);

      
    }

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _logar,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text( _dados['titulo']),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 155.0,
                    child: Image.network(
                      _dados["url"] + "getLogo",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 45.0),
                  InputField(
                    controller: _usernameController,
                    hint: "Email",
                    obscure: false,
                    stream: _loginBloc.outEmail,
                    onChange: _loginBloc.changeEmail,
                  ),
                  SizedBox(height: 25.0),
                  InputField(
                    controller: _passwordController,
                    hint: "Senha",
                    obscure: true,
                    stream: _loginBloc.outPassword,
                    onChange: _loginBloc.changePassword,
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  loginButon,
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
