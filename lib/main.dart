import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(
      MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _todoList = [];
  TextEditingController _todoController = TextEditingController();

  void _addToDo() {
    Map<String, dynamic> newToDo = Map<String, dynamic>();

    setState(() {
      newToDo["title"] = _todoController.text;
      newToDo["isChecked"] = false;
      _todoController.text = "";
      _todoList.add(newToDo);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Lista de Tarefas"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 1.0, 5.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("Add"),
                  textColor: Colors.white,
                  onPressed: _addToDo
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 5.0),
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_todoList[index]["title"]),
                  value: _todoList[index]["isChecked"],
                  secondary: CircleAvatar(
                    backgroundColor: Colors.white12,
                    child: Icon(
                      _todoList[index]["isChecked"]
                          ? Icons.check
                          : Icons.hdr_weak,
                    ),
                  ),
                  onChanged: (isChecked) {
                    print(isChecked);
                    setState(() {
                      _todoList[index]["isChecked"] = isChecked;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);

    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
