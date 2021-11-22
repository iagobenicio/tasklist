import 'package:flutter/material.dart';
import 'package:tasklist/pages/tasklistpage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.white),
        headline6: TextStyle(color: Colors.white),
        subtitle1: TextStyle(color: Colors.white)
      ),
      scaffoldBackgroundColor: Color.fromRGBO(56, 60, 74, 1),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color.fromRGBO(82, 148, 226, 1)),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(
            124, 129, 140, 1
          )
        )
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Color.fromRGBO(64, 69, 82, 1),
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: TextStyle(color: Colors.white60),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white60
          )
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(82, 148, 226, 1)
          )
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          )
        )
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color.fromRGBO(82, 148, 226, 1)
      ),
    ),
    home: TaskList(),
  ));
}




