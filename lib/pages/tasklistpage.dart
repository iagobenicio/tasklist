import 'package:flutter/material.dart';
import 'package:tasklist/bloc/tasklist_bloc.dart';
import 'dialogscreen.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool _loadgin = true;
  TaskListControl _tasklistcontrol = TaskListControl();
  dynamic _statusError;
  List<dynamic>? _task;

  @override
  void initState() {
    super.initState();

    _tasklistcontrol.getDataFromFile().then((value){
      setState(() {
        _loadgin = false;
        _task = value;
      });
    }, onError: (error) {
      setState(() {
        _loadgin = false;
        _statusError = error;
      });
    });
  }

  @override
  void dispose() {
    _tasklistcontrol.closeTaskStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List _removeItems = [];
    if (_loadgin) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (_statusError != null) {
        return Scaffold(
          body: Center(
            child: Text(_statusError),
          ),
        );
      } else {
        return Scaffold(
          body: SafeArea(
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(text: "TASK", style: TextStyle(fontSize: 24)),
                      TextSpan(
                        text: "List",
                        style: TextStyle(fontStyle: FontStyle.italic))
                      ]
                    ),
                  )
                ),
                Expanded(
                  flex: 10,
                  child: StreamBuilder(
                      initialData: _task,
                      stream: _tasklistcontrol.outpoutnewtasklist,
                      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString(),
                              style: TextStyle(color: Colors.white70)),
                          );
                        }else{      
                          if (snapshot.data!.isEmpty) {
                            return Center(
                              child: Text("você não tem tarefa cadastrada",
                                  style: TextStyle(color: Colors.white70)),
                            );
                          } else {
                            _removeItems = snapshot.data!;
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(snapshot.data![index]["task"]),
                                  trailing: Checkbox(value: snapshot.data![index]["isComplete"],
                                  onChanged: (change) {
                                    _tasklistcontrol.upStateItemList(
                                      snapshot.data!, 
                                      index, 
                                      change
                                    );
                                  }),
                                );
                              },
                            );
                          }
                        }
                      }
                    )
                  ),
                  StreamBuilder(
                    initialData: _tasklistcontrol.showbutton,
                    stream: _tasklistcontrol.outpoutshowbutton,
                    builder: (context,snapshot){
                      if (snapshot.data == true) {
                        return Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                              onPressed: (){
                                _tasklistcontrol.completeTask(_removeItems);
                              }, 
                              child: Text("completar tarefas")
                            ),
                          )
                        );
                      } else {
                        return Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: (){}, 
                              child: Text("completar tarefas", style: TextStyle(
                                  color: Color.fromRGBO(82, 148, 226, 0.7)
                                ),
                              )
                            )
                          )                 
                        );
                      }
                    }
                  )
                ],
              ),
            )
          ),
          floatingActionButton: FloatingActionButton(
          onPressed: () {
          showDialog(
            context: context,
            builder: (contextdialog) {
              return DialogScreen(
                taskListControl: _tasklistcontrol,
              );
            });
          },
          child: Icon(Icons.add)),
        );
      }
    }
  }
}
