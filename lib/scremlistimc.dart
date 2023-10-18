import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myappcalculadoraimc/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IMCListScreen extends StatefulWidget {
  @override
  _IMCListScreenState createState() => _IMCListScreenState();
}

class _IMCListScreenState extends State<IMCListScreen> {
  List<IMCResult> imcResults = [];

  @override
  void initState() {
    super.initState();
    _loadIMCResults();
  }

  Future<void> _loadIMCResults() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? imcResultsData = prefs.getStringList('imcResults');

    if (imcResultsData != null) {
      setState(() {
        imcResults = imcResultsData.map((data) => IMCResult.fromMap(json.decode(data))).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar IMC'),
      ),
      body: ListView.builder(
        itemCount: imcResults.length,
        itemBuilder: (context, index) {
          double imc = imcResults[index].imc;
          String formattedIMC = imc.toStringAsFixed(2);

          return ListTile(
            title: Text('Nome: ${imcResults[index].name}'),
            subtitle: Text(
                'Peso: ${imcResults[index].weight} kg, Altura: ${imcResults[index].height} cm\nIMC: $formattedIMC\nClassificação: ${imcResults[index].classification}'),
          );
        },
      ),
    );
  }
}