import 'package:flutter/material.dart'; //기본위젯들 쓰려면 이거 필요

var theme = ThemeData(

//    textButtonTheme: TextButtonThemeData(
//        style: TextButton.styleFrom(
//      backgroundColor: Colors.grey,
//    )),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.black,
    ),
    appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 1, //그림자 크기
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
        actionsIconTheme: IconThemeData(color: Colors.black)),
    textTheme: TextTheme(bodyText2: TextStyle(color: Colors.red)));

var _var1; //다른 파일에서 변수 사용 중복 방지하고 싶을때
