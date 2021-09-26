import 'dart:io';

import 'package:test/test.dart';
import 'package:tasklist/bloc/tasklist_bloc.dart';



main() {
    
    
    TaskListControl tasktest = TaskListControl();
  
   


    test("teste path_provider", ()async{

     final directory = await tasktest.getDirectoryFile();
     
     expect(directory, Directory('C:\\Users\\iagop\\AppData\\Local\\Temp'));

    });

     test("teste path_provider_file", ()async{
      
      var data = await tasktest.getDataFromFile();

      expect(data, equals([]));
       

    });






}