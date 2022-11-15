import 'package:flutter/material.dart';
//import 'package:flutter_project_4/style.dart';
import './style.dart' as style; //경로
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => Store1()),
        ChangeNotifierProvider(create: (c) => Store2()),
      ], //state 등록
      child: MaterialApp(theme: style.theme, home: MyApp())));
}

// var a = TextStyle(color: Colors.yellow); // 세부 글자 스타일 조정

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0; //현재 탭의 모습
  var data = [];
  var userImage;
  var userContent;

  addMyData() {
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': 100,
      'date': 'March 1',
      'content': userContent,
      'liked': false,
      'user': 'Sim'
    };
    setState(() {
      data.insert(0, myData);
    });
  }

  setUserContent(a) {
    setState(() {
      userContent = a;
    });
  }

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    //if (result.statusCode == 200){}
    var result2 = jsonDecode(result.body); //map 자료형
    //print(result2);
    setState(() {
      data = result2;
    });
  }

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    storage.setString('name', 'john');
    storage.remove('name');
    var map = {'age': 10};
    storage.setString('map', jsonEncode(map));
    var result = storage.getString('map') ?? '없는데요';
    print(result);
    print(jsonDecode(result)['age']);
    //매번 server 요청하는게 아니라 이 함수 쓸 것!
  }

  @override
  void initState() {
    super.initState(); //위젯로드 될 때 실행
    saveData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Instagram'), actions: [
        IconButton(
          icon: Icon(Icons.favorite_border_outlined),
          onPressed: () async {
            var picker = ImagePicker();
            var image = await picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              setState(() {
                userImage = image.path;
              });
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => Upload(
                          userImage: userImage,
                          setUserContent: setUserContent,
                          addMyData: addMyData,
                        )));
          },
          iconSize: 30,
        )
      ]),
      body: [Home(data: data), Text('샵페이지')][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: '샵')
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, this.data})
      : super(key: key); //부모가 보낸 state 등록은 첫 class
  final data;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //state 사용은 둘째 class

  var scroll = ScrollController();

  getMore() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    setState(() {
      widget.data.add(jsonDecode(result.body));
    });
  }

  @override
  void initState() {
    super.initState();

    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        print("같음");
        getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      return ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (c, i) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(widget.data[i]['image']),
                  GestureDetector(
                      child: Text(widget.data[i]['user']),
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (c) =>
                                    Profile())); //pageroutebuilder로도 가능
                      }),
                  Text('좋아요 ${widget.data[i]['likes']}'),
                  Text(widget.data[i]['date']),
                  Text(widget.data[i]['content']),
                ]);
          });
    } else {
      return Text('로딩중');
    }
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData})
      : super(key: key);
  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: (() {
                  addMyData();
                }),
                icon: Icon(Icons.send))
          ],
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.network(userImage),
          Text('이미지업로드화면'),
          TextField(
            onChanged: (text) {
              setUserContent(text);
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context); //페이지 닫기
              },
              icon: Icon(Icons.close)),
        ]));
  }
}

class Store1 extends ChangeNotifier {
  //state store
  var follower = 3;
  var friend = false;
  var profileImage = [];

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }

  addFollower() {
    if (friend == false) {
      follower++;
      friend = true;
    } else {
      follower--;
      friend = false;
    }
    notifyListeners(); //재랜더링= setState
  }
}

class Store2 extends ChangeNotifier {
  var name = 'John Kim';
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.watch<Store2>().name),
        ),
        body: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
          ),
          Text('팔로워 ${context.watch<Store1>().follower}명'),
          ElevatedButton(
              onPressed: () {
                context.read<Store1>().addFollower();
              },
              child: Text('팔로우')),
          ElevatedButton(
            onPressed: () {
              context.read<Store1>().getData();
              //Image.network(context.watch<Store1>().profileImage[0]);
            },
            child: Text('사진가져오기'),
          ),
        ]));
  }
}

//동적인 UI 만드는법
//1. state에 UI의 현재상태 저장, 즉, state에 var tab의 현재상태 저장
//2. state에 따라 tab이 어떻게 보일지 작성
//3. 유저가 쉽게 state 조작할 수 있게 button 등 만들기

//서버
//데이터 달라고하면 주는 프로그램
//method : get/post 택 1
//url

