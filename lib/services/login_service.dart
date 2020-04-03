import 'dart:convert';
import 'dart:io';
import 'package:elysium_app/ui/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LoginService {
  final String email;
  final String senha;
  final String url;

  LoginService({this.email, this.senha, this.url});

  Future<File> getFile() async {
    Directory tempDir = await getTemporaryDirectory();
    return File("${tempDir.path}/dados.json");
  }

  Future<File> saveToken(dadosJson) async {
    var encode = json.encode(dadosJson['dados']);

    File file = await getFile();
    return file.writeAsString(encode);
  }

  Future<String> getDados() async {
    try {
      final file = await getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  void logar(res) async {
    this.saveToken(res);
  }

  static void logout(context) async {
    LoginService loginService = LoginService();
    final dados = await loginService.getDados();
    
    if (dados != null) {
      final saida = json.decode(dados);

      saida['status'] = false;

      loginService.saveToken(saida);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

    }
  }

  Future<Map> getUser(context) async {
    return getRequest('/api/me', context);
  }
  Future<Map> getMensagens(context) async {
    return getRequest('/api/mensagens', context );
  }

  Future<Map> getRequest(String url, context, {body}) async {
    String stringDados = await getDados();
    if(stringDados == null || stringDados == '') {
    print(stringDados);
      Navigator.push(
          null, MaterialPageRoute(builder: (context) => HomePage()));
    }
    
    final dados = json.decode(stringDados);
    var res = await http.get(dados['url'] + url,
        headers: {"Authorization": "Bearer " + dados['access_token']});
    var jsonRes = json.decode(res.body);

    if (jsonRes == null || !jsonRes['status']) {
      Navigator.push(
          null, MaterialPageRoute(builder: (context) => HomePage()));
    }
    return jsonRes;
  }

  Future<Map> postRequest(String url, context, {body}) async {
    String stringDados = await getDados();
    final dados = json.decode(stringDados);
    
    var res = await http.post(dados['url'] + url,
        headers: {"Authorization": "Bearer " + dados['access_token']},
        body: body);
        
    var jsonRes = json.decode(res.body);
    if ( jsonRes == null || !jsonRes['status']) {
      Navigator.push(
          null, MaterialPageRoute(builder: (context) => HomePage()));
    }
    return jsonRes;
  }
}
