import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';



class TaskListControl{

  StreamController<List> _newtasklist = StreamController();

  Sink<List> get inputnewtasklist => _newtasklist.sink;
  Stream<List> get outpoutnewtasklist => _newtasklist.stream;


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

  
  Future<List> getDataFromFile()async{

    try {

      final pathfile = await getDirectoryFile();
      
      var dataFromFile = await pathfile.readAsString();

      if(dataFromFile.isNotEmpty){
        
        List dataToJson = jsonDecode(dataFromFile);
        dataToJson = List.from(dataToJson.reversed);
        return dataToJson;

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
        dataToJsonList = List.from(dataToJsonList.reversed);
        inputnewtasklist.add(dataToJsonList); 

      }else{

        List newListDataToFile = [];
        Map<String,dynamic> mapTask = Map();

        mapTask["task"] = task;
        mapTask["isComplete"] = false;

        newListDataToFile.add(mapTask);
        var jsonDataFileUp = jsonEncode(newListDataToFile);

        await pathfile.writeAsString(jsonDataFileUp);
        newListDataToFile = List.from(newListDataToFile.reversed);
        inputnewtasklist.add(newListDataToFile);

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

  void upStateItemList(List<dynamic> listItems, int indexCahnge, bool? change){
    
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

    listItems[indexCahnge]["isComplete"] = change;
    inputnewtasklist.add(listItems);
  }


  void completeTask(List<dynamic> listItems)async{
    listItems.removeWhere((element) => element["isComplete"] == true);

    try {

      final pathfile = await getDirectoryFile();
      
      String listToString = jsonEncode(listItems);

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
      _newtasklist.addError("Algum erro ocorreu");
    }

  }

  void closeTaskStream()async{

    await _newtasklist.close();
    await _showButton.close();
    
  }
  

}