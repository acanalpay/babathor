import 'package:babathor/constants.dart';
import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  final String content;
  final bool isMe;

  const MessageBox({Key key, this.content, this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration:kMessageContainerDecoration,
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