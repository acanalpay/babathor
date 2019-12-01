import 'package:babathor/db/LStorage.dart';
import 'package:babathor/db/message.dart';
import 'package:babathor/message-box.dart';
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
  Future<List<Message>> messages;
  LStorage storage = new LStorage();

  @override
  void initState(){
    tcontroller = new TextEditingController();
    messages = storage.getMessagesList(widget.chatId);
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
                child: FutureBuilder<List<Message>>(
                    future: messages,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return ListView(
                          children: getBoxes(snapshot.data),
                        );
                      }else{
                        return Text('Send the first message!');
                      }
                    })),
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
                        messages = storage.getMessagesList(widget.chatId);
                        tcontroller.clear();
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
