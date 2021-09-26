import 'package:flutter/material.dart';
import 'package:tasklist/bloc/tasklist_bloc.dart';


class DialogScreen extends StatefulWidget {

  final TaskListControl taskListControl;
  
  const DialogScreen(
      {Key? key, required this.taskListControl})
      : super(key: key);

  @override
  _DialogScreenState createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {

  TextEditingController _textfieldcontrol = TextEditingController();


  @override
  void dispose() {
    _textfieldcontrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("textfield");
    return AlertDialog(
      title: Text("Cadastro de tarefas"),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextField(
              controller: _textfieldcontrol,
              decoration: InputDecoration(),
            ),  
          ],
        ),
      ),
      actions: [
        FloatingActionButton(
          mini: true,
          onPressed: () {
            widget.taskListControl.saveTaskOnFile(_textfieldcontrol.text);
          },
          child: Icon(Icons.check),
        )
      ],
    );
  }
}
