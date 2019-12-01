import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:babathor/db/message.dart';
import 'package:path_provider/path_provider.dart';

class LStorage {
    static int count=0;
    static int count2=0;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> localFile(String chatId) async {
    final path = await _localPath;
    return File('$path/$chatId.json');
  }

  Future<bool> fileIsExist(String fileName) async {
    final file = await localFile(fileName);
    return file.exists();
  }

  Future<String> readChatIds() async {
    try {
      final file = await localFile("chatIds");
      String contents = await file.readAsString();

      contents = jSonParser2(contents, (count2++).toString());
      return contents;
    } catch (e) {
      return "null";
    }
  }

  Future<File> writeChatId(String chatId) async {
    final file = await localFile("chatIds");
    final file2 = await localFile(chatId);
    await file2.writeAsString("");
    return file.writeAsString(json.encode({chatId: "true"}),
        mode: FileMode.append);
  }

  Future<String> readMessages(String chatId) async {
    try {
      final file = await localFile(chatId);
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      return "null";
    }
  }

  deleteMethod(String chatId) async {
    final file = await localFile(chatId);
    await file.delete();
  }
  String jSonParser2(String file, String cId) {
    if(file !=""){
      String messageID = "chat" + cId;
      return file.substring(0,file.length-1) + ",\n" + '\"' + messageID + '\": ' + "}";
    }else{
      String messageID = "chat" + cId;
      return '{\"' + messageID + '\": ' + "}";
    }
  }

  String jSonParser(String file, String secondData, String messageId) {
    if(file !=""){
    String messageID = "message" + messageId;
    return file.substring(0,file.length-1) + ",\n" + '\"' + messageID + '\": ' + secondData + "}";
    }else{
    String messageID = "message" + messageId;
    return '{\"' + messageID + '\": ' + secondData + "}";
    }
  }
  Future<File> writeMessage(Message message, String chatId) async {
    final file = await localFile(chatId);
    String a = await file.readAsString();
      a = jSonParser(a, json.encode(message.toJson()), (count++).toString());
      print(a);
    return file.writeAsString(a);
  }

  Future<List<Message>> getMessagesList(String chatId) async {
    try {
      final file = await localFile(chatId);
      String contents = await file.readAsString();
      Map<String, dynamic> obj = json.decode(contents);
      List<Message> messages = new List<Message>();
      for (var i = 0; i < obj.length; i++) {
        messages.add(Message.fromJson(obj.values.elementAt(i)));
      }
      
      return messages;
    } catch (e) {
      return null;
    }
  }
}
