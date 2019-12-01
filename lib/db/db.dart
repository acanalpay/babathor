import 'dart:convert';
import 'dart:io';

import 'package:babathor/db/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class Db{
  final Firestore db = Firestore.instance;
  
  Future<List<Message>> getNewMessages(String chatId, String fromId)async{
    List<Message> result = new List<Message>();
    QuerySnapshot querySnapshot = await db.collection('messages').document('all_messages').collection(chatId).getDocuments();
    querySnapshot.documents.forEach((DocumentSnapshot documentSnapshot){
      if(documentSnapshot.data['from'] != fromId)
      result.add(Message(documentSnapshot.documentID,documentSnapshot.data['content'],documentSnapshot.data['date'],documentSnapshot.data['from']));
    });
    if(result.length == 0)
      return null;
    else
      return result;

  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> localFile(String chatId) async {
    final path = await _localPath;
    return File('$path/$chatId.json');
  }

  sendMessage(Message message, String chatId)async{
    final file = await localFile(chatId);
    String a = await file.readAsString();
    int lastId;
    if(a != ""){
    Map<String, dynamic> obj = json.decode(a);
    lastId = int.parse(obj.values.last['id']);
    message.id = (lastId).toString();
    }else{
      lastId = 1;
      message.id = '1';
    }
    await db.collection('messages').document('all_messages').collection(chatId).add(message.toJson());
  }

  delete(String chatId, String fromId) async{
    QuerySnapshot querySnapshot = await db.collection('messages').document('all_messages').collection(chatId).getDocuments();
    querySnapshot.documents.forEach((DocumentSnapshot documentSnapshot) async {
      if(documentSnapshot.data['from'] != fromId){
        await documentSnapshot.reference.delete();
    }});
  }

}