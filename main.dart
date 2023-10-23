import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _cepController = TextEditingController();
  String _result = "";

  Future<void> _getCEPInfo() async {
    final cep = _cepController.text;
    final Uri uri = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _result = "CEP: ${data['cep']}\n"
            "Logradouro: ${data['logradouro']}\n"
            "Bairro: ${data['bairro']}\n"
            "Cidade: ${data['localidade']}\n"
            "Estado: ${data['uf']}";
      });
    } else {
      setState(() {
        _result = "CEP não encontrado";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('App Consulta de CEP'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _cepController,
                decoration: InputDecoration(labelText: 'Digite o CEP'),
              ),
            ),
            ElevatedButton(
              onPressed: _getCEPInfo,
              child: Text('Consultar CEP'),
            ),
            Text(
              _result,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
