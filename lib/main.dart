import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/api.dart';
import 'package:flutter_application_2/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: const MyHomePage(title: 'КОНВАЛ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CisloController = TextEditingController();
  bool zagruzka = false;
  String resultText = "Результат будет здесь";
  String from = "EUR";
  String To = "RUB";
  List<String> history = [];

  void Swap() {
    String oldFrom = from;
    setState(() {
      from = To;
      To = oldFrom;
      resultText = "PRESS КОН";
    });
  }

  void Obrabotat() async {
    final number = double.tryParse(CisloController.text);
    if (number == null) {
      setState(() {
        resultText = "Введи число";
      });
      return;
    }
    if (number < 0) {
      setState(() {
        resultText = "Странное число";
      });
      return;
    }
    setState(() {
      zagruzka = true;
    });
    try {
      final api = Api();
      final data = await api.loading();
      final fromRate = data.kurs[from];
      final toRate = data.kurs[To];
      if (fromRate == null || toRate == null) {
        setState(() {
          resultText = "Не повезло с поиском";
        });
        return;
      }
      final perOne = toRate / fromRate;
      final result = number * toRate / fromRate;

      setState(() {
        resultText =
            result.toStringAsFixed(3) +
            " " +
            To +
            "\n" +
            " " +
            "1" +
            " " +
            from +
            "=" +
            perOne.toStringAsFixed(3) +
            " " +
            To +
            "\n" +
            "Дата обновления:" +
            " " +
            data.updatedAt;
        history.add(resultText);
      });
    } catch (oshibka) {
      setState(() {
        resultText = "Не повезло с загрузкой";
      });
    } finally {
      setState(() {
        zagruzka = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 320,
              child: Column(
                mainAxisAlignment: .center,
                spacing: 16,
                children: [
                  TextField(
                    controller: CisloController,
                    decoration: InputDecoration(
                      labelText: "Число",
                      hintText: "228",
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton(
                        items: [
                          DropdownMenuItem(child: Text("RUB"), value: "RUB"),
                          DropdownMenuItem(child: Text("EUR"), value: "EUR"),
                          DropdownMenuItem(child: Text("USD"), value: "USD"),
                          DropdownMenuItem(child: Text("THB"), value: "THB"),
                          DropdownMenuItem(child: Text("VND"), value: "VND"),
                        ],

                        value: from,
                        onChanged: (newCurrency) {
                          if (newCurrency == null) {
                            return;
                          }
                          setState(() {
                            from = newCurrency;
                          });
                        },
                      ),
                      OutlinedButton(onPressed: Swap, child: Text("SWAP")),
                      DropdownButton(
                        items: [
                          DropdownMenuItem(child: Text("RUB"), value: "RUB"),
                          DropdownMenuItem(child: Text("EUR"), value: "EUR"),
                          DropdownMenuItem(child: Text("USD"), value: "USD"),
                          DropdownMenuItem(child: Text("THB"), value: "THB"),
                          DropdownMenuItem(child: Text("VND"), value: "VND"),
                        ],
                        value: To,
                        onChanged: (newCurrency) {
                          if (newCurrency == null) {
                            return;
                          }
                          setState(() {
                            To = newCurrency;
                          });
                        },
                      ),
                    ],
                  ),

                  if (zagruzka) CircularProgressIndicator(),
                  OutlinedButton(onPressed: Obrabotat, child: Text("КОН")),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(resultText),
                    ),
                  ),
                  Text("История"),
                  Text(history.join("\n\n")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
