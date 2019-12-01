import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  final String content;
  final bool isMe;

  const MessageBox({Key key, this.content, this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1)
      ),
      child: getTextWidget(),
    );
  }

  Widget getTextWidget(){
    if(isMe)
      return Text(content,textAlign: TextAlign.right,);
    else
      return Text(content,textAlign: TextAlign.left,);
  }
}