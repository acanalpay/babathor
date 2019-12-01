import 'package:babathor/chat-page.dart';
import 'package:babathor/db/LStorage.dart';
import 'package:babathor/db/message.dart';
import 'package:babathor/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  final String userId;

  const MainPage({Key key, this.userId}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  LStorage storage = new LStorage();
  String fromId;
  String generateChatID(String A, String B) {
    if (A.compareTo(B) < 0)
      return A + B;
    else
      return B + A;
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Please enter the id"),
          content: new TextFormField(
            onChanged: (value) {
              fromId = value;
            },
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Start"),
              onPressed: () async {
                String chatIds = generateChatID(widget.userId, fromId);
                bool isExist = await storage.fileIsExist(chatIds);
                if (!isExist) {
                  await storage.writeChatId(chatIds);
                }
                // await storage.deleteMethod('asd');
                // await storage.writeMessage(
                //     new Message('1', "AA", DateTime.now().toString(), 'from',
                //         widget.userId),
                //     chatIds);
                // await storage.writeMessage(new Message('2', "BB", DateTime.now().toString(), widget.userId, 'to'), "asd");
                // await storage.writeMessage(new Message('3', "CC", DateTime.now().toString(), widget.userId, 'to'), "asd");
                String a1 = await storage.readChatIds();
                String a2 = await storage.readMessages("asd");
                print(a1);
                print(a2);
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) =>
                        ChatPage(chatId: chatIds, userId: widget.userId)));
              },
            ),
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
                        child: FutureBuilder<Object>(
                            future: getChatsIds(),
                            builder: (context, snapshot) {
                              return ListView();
                            })),
                    RaisedButton(
                      child: Text('Start new chat'),
                      onPressed: () {
                        storage.deleteMethod('chatIds');
                        _showDialog();
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

  Future<List<String>> getChatsIds() async{
    String a = await storage.readChatIds();
    print(a);
  }
}

getId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.get("userId");
}
