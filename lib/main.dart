import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main-page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Generate ID'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userName = "";
  String userId = "";

  String createUserID(String name) {
    if (name != "") {
      String id = name + "@";

      for (int i = 0; i < 5; i++) {
        Random rand = new Random();
        id += rand.nextInt(9).toString();
      }
      userId = id;
      return id;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: checkId(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          if (snapshot.data == true) {
            return MainPage(userId: userId); 
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Username",
                      ),
                      onChanged: (value) {
                        userName = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text("Generate ID"),
                      onPressed: () {
                        writeId(createUserID(userName));
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (context) => MainPage(userId: userId)));
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  Future<bool> checkId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");
    return prefs.containsKey("userId");
  }

  writeId(String uId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", uId);
  }
}
