import 'package:flutter_test/flutter_test.dart';
import 'package:tasklist/bloc/tasklist_bloc.dart';



main() {
    
    
    TaskListControl tasktest = TaskListControl();
  

    test("teste path_provider", ()async{

     final directoryfile = await tasktest.getDirectoryFile();
     
     expect(directoryfile.uri, isNotNull);

    });

     test("teste path_provider_file", ()async{
      
      var data = await tasktest.getDataFromFile();

      expect(data, equals([]));
       

    });

}