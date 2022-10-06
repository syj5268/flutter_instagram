import 'package:flutter/material.dart';
import 'package:flutter_project_4/style.dart';
import './style.dart' as style; //경로

void main() {
  runApp(MaterialApp(theme: style.theme, home: MyApp()));
}

// var a = TextStyle(color: Colors.yellow); // 세부 글자 스타일 조정

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0; //현재 탭의 모습

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Instagram'), actions: [
        IconButton(
          icon: Icon(Icons.favorite_border_outlined),
          onPressed: () {},
          iconSize: 30,
        )
      ]),
      body: SingleChildScrollView(child: [layout(), Text('샵페이지1')][tab]),
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (i) {
            setState(() {
              tab = i;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: '홈'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined), label: '샵')
          ]),
    );
  }
}

class layout extends StatelessWidget {
  const layout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/cat.png",
            ),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('좋아요 100'), Text('글쓴이'), Text('글내용')],
            )),
          ],
        )),
        Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/cat.png",
            ),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('좋아요 100'),
                Text('글쓴이'),
                Text('글내용'),
              ],
            )),
          ],
        )),
        Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/cat.png",
            ),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('좋아요 100'), Text('글쓴이'), Text('글내용')],
            )),
          ],
        )),
      ],
    );
  }
}

//동적인 UI 만드는법
//1. state에 UI의 현재상태 저장, 즉, state에 var tab의 현재상태 저장
//2. state에 따라 tab이 어떻게 보일지 작성
//3. 유저가 쉽게 state 조작할 수 있게 button 등 만들기
