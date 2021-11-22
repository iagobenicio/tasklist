import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:tasklist/models/taskmodel.dart';


class TaskListControl{

  StreamController<List<TaskModel>> _newtasklist = StreamController();

  Sink<List<TaskModel>> get inputnewtasklist => _newtasklist.sink;
  Stream<List<TaskModel>> get outpoutnewtasklist => _newtasklist.stream;

  

  StreamController<bool> _showButton = StreamController();
  bool showbutton = false;
  int countItemShowButton = 0;
  Sink<bool> get inputshowbutton => _showButton.sink;
  Stream<bool> get outpoutshowbutton => _showButton.stream;
  
  

  Future<File> getDirectoryFile() async{

    try {

      final path = await getTemporaryDirectory();
      final File dataFile = File('${path.path}\\data.json');
      
      if(await dataFile.exists()){

        return dataFile;

      }else{

        final newFile = await dataFile.create();
        return newFile;

      }

    }on FileSystemException{
      throw FileSystemException("Erro no sistema de arquivo");
    }
    catch (e) {
      throw MissingPlatformDirectoryException("Erro de diretório");
    }
    
  }

  
  Future<List<TaskModel>> getDataFromFile()async{

    try {

      final pathfile = await getDirectoryFile();
      
      var dataFromFile = await pathfile.readAsString();

      if(dataFromFile.isNotEmpty){
        
        List dataToJson = jsonDecode(dataFromFile);

        List<TaskModel> taskList = dataToJson.map((element)
          => TaskModel.fromJson(element)
        ).toList();

        List<TaskModel> dataTaskModel = List.from(taskList.reversed);
        return dataTaskModel;

      }else{
        return [];
      }

    }on FileSystemException catch (e){
      throw e.message;
    }on MissingPlatformDirectoryException catch(e){
      throw e.message;
    }
    catch(e){
      throw Exception("Algum erro ocorreu");      
    }

  }

  void saveTaskOnFile(String task)async{
    try {

      final pathfile = await getDirectoryFile();
      
      var dataFromFile = await pathfile.readAsString();

      if(dataFromFile.isNotEmpty){
        
        List dataToJsonList = jsonDecode(dataFromFile);
        final Map<String,dynamic> mapTask = Map();

        mapTask["task"] = task;
        mapTask["isComplete"] = false;

        dataToJsonList.add(mapTask);
        var jsonDataFileUp = jsonEncode(dataToJsonList);

        await pathfile.writeAsString(jsonDataFileUp);

        List<TaskModel> taskmodel = dataToJsonList.map((element) 
          => TaskModel.fromJson(element)
        ).toList();

        List<TaskModel> dataTaskmodel = List.from(taskmodel.reversed);
        inputnewtasklist.add(dataTaskmodel); 
  
      }else{

        List newListDataToFile = [];
        Map<String,dynamic> mapTask = Map();

        mapTask["task"] = task;
        mapTask["isComplete"] = false;

        newListDataToFile.add(mapTask);
        var jsonDataFileUp = jsonEncode(newListDataToFile);

        await pathfile.writeAsString(jsonDataFileUp);
        
        List<TaskModel>? tasklist;
        tasklist!.add(TaskModel.fromJson(mapTask));

        List<TaskModel> newdataTaskmodel = List.from(tasklist.reversed);
        inputnewtasklist.add(newdataTaskmodel);

      }
      
    }on FileSystemException catch (e){
      _newtasklist.addError(e.message);
    }on MissingPlatformDirectoryException catch(e){
      _newtasklist.addError(e.message);
    } 
    catch(e){
      _newtasklist.addError("Algum erro ocorreu");
    }
  
  }

  void upStateItemList(List<TaskModel> listItems, int indexCahnge, bool? change){
    
    if (change == true) {
      
    
      countItemShowButton += 1;
      if(countItemShowButton == 1){

        inputshowbutton.add(true);

      }
  
    }else{

      countItemShowButton -= 1;
      if(countItemShowButton == 0){

        inputshowbutton.add(false); 

      }

    }

    listItems[indexCahnge].isComplete = change;
    inputnewtasklist.add(listItems);
  }


  void completeTask(List<TaskModel> listItems)async{
    listItems.removeWhere((element) => element.isComplete == true);

    try {

      final pathfile = await getDirectoryFile();
      
      List<Map<String,dynamic>> taskModelToJson = listItems.map((e) 
         => e.toJson()
      ).toList();

      String listToString = jsonEncode(taskModelToJson);

      await pathfile.writeAsString(listToString);

      countItemShowButton = 0;
      inputshowbutton.add(false);
      inputnewtasklist.add(listItems); 

      
    }on FileSystemException catch (e){
      _newtasklist.addError(e.message);
    }on MissingPlatformDirectoryException catch(e){
       _newtasklist.addError(e.message);
    } 
    catch(e){
      _newtasklist.addError(e);
    }

  }

  void closeTaskStream(){

    _newtasklist.close();
    _showButton.close();
    
  }
  

}