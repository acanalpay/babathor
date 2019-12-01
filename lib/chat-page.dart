import 'package:babathor/db/LStorage.dart';
import 'package:babathor/db/db.dart';
import 'package:babathor/db/message.dart';
import 'package:babathor/message-box.dart';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babathor/constants.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String userId;

  const ChatPage({Key key, this.chatId, this.userId}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String sendMessage;
  TextEditingController tcontroller;
  Db db;
  Future<List<Message>> messages;
  Future<List<Message>> newMessages;
  LStorage storage = new LStorage();

  @override
  void initState() {
    super.initState();
    tcontroller = new TextEditingController();
    db = new Db();
    myInit();
  }

  void myInit() {
    newMessages = db.getNewMessages(widget.chatId, widget.userId);
    newMessages.then((value) {
      if (value == null) {
        messages = storage.getMessagesList(widget.chatId);
      } else {
        for (var message in value) {
          storage.writeMessage(message, widget.chatId).then((v) async {
            await db.delete(widget.chatId, widget.userId);
            setState(() {
              messages = storage.getMessagesList(widget.chatId);
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.chatId),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: StreamBuilder<Object>(
                    stream: Firestore.instance
                        .collection('messages')
                        .document('all_messages')
                        .collection(widget.chatId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) myInit();
                      return FutureBuilder<List<Message>>(
                          future: messages,
                          builder: (context, snapshots) {
                            if (snapshots.data != null) {
                              return ListView(
                                children: getBoxes(snapshots.data),
                              );
                            } else {
                              return Text('Send the first message!');
                            }
                          });
                    })),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextFormField(
                      onChanged: (value) {
                        sendMessage = value;
                      },
                      controller: tcontroller,
                    )),
                    new RawMaterialButton(
                      onPressed: () async {
                        await storage.writeMessage(
                            Message('1', sendMessage, '23 Ocak', widget.userId),
                            widget.chatId);
                        await db.sendMessage(
                            Message('1', sendMessage, '23 Ocak', widget.userId),
                            widget.chatId);
                        setState(() {
                          messages = storage.getMessagesList(widget.chatId);
                        });
                        tcontroller.clear();
                      },
                      child: new Icon(
                        Icons.send,
                        color: Colors.blue,
                        size: 30.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(15.0),
                    ),
                    // FlatButton(
                    //   child: Text("Delete"),
                    //   onPressed: () async {
                    //     await storage.deleteMethod(widget.chatId);
                    //     Navigator.pop(context);
                    //   },
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getBoxes(List<Message> messageList) {
    List<Widget> result = new List<Widget>();
    for (var item in messageList) {
      if (item.from == widget.userId) {
        result.add(Bubble(
          margin: BubbleEdges.only(top: 10),
          child: Text(item.content),
          alignment: Alignment.topRight,
          color: Color.fromARGB(255, 225, 255, 199),
          nip: BubbleNip.rightTop,
        ));
      } else {
        result.add(Bubble(
          margin: BubbleEdges.only(top: 10),
          child: Text(item.content),
          alignment: Alignment.topLeft,
          nip: BubbleNip.leftTop,
        ));
      }
      result.add(SizedBox(
        height: 20,
      ));
    }
    return result;
  }
}
