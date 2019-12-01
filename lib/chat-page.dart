import 'package:babathor/db/LStorage.dart';
import 'package:babathor/db/db.dart';
import 'package:babathor/db/message.dart';
import 'package:babathor/message-box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  void initState(){
    super.initState();
    tcontroller = new TextEditingController();
    db = new Db();
    myInit();
  }

  void myInit(){
    newMessages = db.getNewMessages(widget.chatId,widget.userId);
    newMessages.then((value){
    if(value == null){
        messages = storage.getMessagesList(widget.chatId);
    }else{
      for (var message in value) {
        storage.writeMessage(message, widget.chatId).then((v) async {
          await db.delete(widget.chatId,widget.userId);
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
                  stream: Firestore.instance.collection('messages').document('all_messages').collection(widget.chatId).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData && snapshot.data != null) myInit();
                    return FutureBuilder<List<Message>>(
                        future: messages,
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return ListView(
                              children: getBoxes(snapshot.data),
                            );
                          }else{
                            return Text('Send the first message!');
                          }
                        });
                  }
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1)),
                child: Row(
                  children: <Widget>[
                    Expanded(child: TextFormField(
                      onChanged: (value){
                        sendMessage = value;
                      },
                      controller: tcontroller,
                    )),
                    FlatButton(
                      child: Text("Send"),
                      onPressed: () async{
                        await storage.writeMessage(Message('1',sendMessage,'23 Ocak', widget.userId), widget.chatId);
                        await db.sendMessage(Message('1',sendMessage,'23 Ocak', widget.userId), widget.chatId);
                        setState(() {
                        messages = storage.getMessagesList(widget.chatId);
                        });
                        tcontroller.clear();
                      },
                    ),
                    FlatButton(
                      child: Text("Delete"),
                      onPressed: () async{
                        await storage.deleteMethod(widget.chatId);
                        Navigator.pop(context);
                      },
                    )
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
      result.add(MessageBox(
        content:item.content, isMe: item.from == widget.userId
      ));
      result.add(SizedBox(height: 20,));
    }
    return result;
  }
}
