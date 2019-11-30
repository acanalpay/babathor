import 'package:babathor/chat-page.dart';
import 'package:babathor/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FutureBuilder(
          future: getId(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return SafeArea(
              child: Scaffold(
                  body: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                    SelectableText(snapshot.data),
                    Expanded(
                        child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                      itemCount: 20,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: ListTile(
                          title: Text('Murat'),
                          onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => ChatPage(
                                      toId: 'Murat',
                                    )));
                          },
                        )),
                      ),
                    )),
                    RaisedButton(
                      child: Text('Start new chat'),
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                    RaisedButton(
                      child: Text('Logout'),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove('userId');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                    title: "Generate ID",
                                  )),
                        );
                      },
                    )
                  ]))),
            );
          },
        ),
      ),
    );
  }
}

getId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.get("userId");
}
