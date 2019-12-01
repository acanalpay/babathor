import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:babathor/db/message.dart';
import 'package:path_provider/path_provider.dart';

class LStorage {
  static int count = 0;
  static int count2 = 0;
  Random rand = new Random();
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

  deleteMethod(String fName) async {
    final file = await localFile(fName);
    await file.delete();
  }

  String jSonParser2(String chats, String cId) {
    int chatID = int.parse(cId);
    String newChat = "{";
    for (int i = 0; i < chats.length; i++) {
      if (newChat == "{") newChat += "\"chat" + (chatID++).toString() + "\":\n\t";
      newChat += chats[i];
      if (chats[i] == "}") {
        if (i != chats.length - 1) {
          newChat += ",\n";
          newChat += "\"chat" + (chatID++).toString() + "\":\n\t";
        }
      }
    }
    return newChat + "}";
  }

  String jSonParser(String file, String secondData, String messageId) {
    if (file != "") {
      String messageID = "message" + messageId;
      return file.substring(0, file.length - 1) +
          ",\n" +
          '\"' +
          messageID +
          '\": ' +
          secondData +
          "}";
    } else {
      String messageID = "message" + messageId;
      return '{\"' + messageID + '\": ' + secondData + "}";
    }
  }

  Future<File> writeMessage(Message message, String chatId) async {
    final file = await localFile(chatId);
    String a = await file.readAsString();
    int lastId;
    if (a != "") {
      Map<String, dynamic> obj = json.decode(a);
      lastId = int.parse(obj.values.last['id']);
      message.id = (++lastId).toString();
    } else {
      lastId = 1;
      message.id = '1';
    }
    a = jSonParser(a, json.encode(message.toJson()), (lastId).toString());
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
