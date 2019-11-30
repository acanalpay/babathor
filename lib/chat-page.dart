import 'package:babathor/message-box.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String toId;

  const ChatPage({Key key, this.toId}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.toId),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                itemCount: 20,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: MessageBox(content: "My Message. $index",isMe : (index%2) == 0 ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 1)),
                child: Row(
                  children: <Widget>[
                    Expanded(child:TextFormField()),
                    FlatButton(
                      child: Text("Send"),
                      onPressed: (){},
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
}
