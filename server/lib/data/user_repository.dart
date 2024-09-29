import 'dart:ffi';

import 'package:chatserver/data/init_db.dart';
import 'package:chatserver/models/chat_box.dart';
import 'package:chatserver/models/user.dart';

class UserRepository {
  

 static  Future<User?> getUserById({required int userId})async{
    try {
      final connection = PgConnect.connection;
      final result = await connection.execute(r'select id,email,name,joinedat from cuser where id = $1',parameters:[userId] );
    if(result.isEmpty){
     return null;
       
    }
    final data = result.first.toColumnMap();
     return User(email: data["email"], id: data["id"], name: data["name"], joinedAt: data["joinedat"]);
    } catch (e) {
      print(e);
    }
    return null;
  }

 
 static Future<List<ChatBox>?> getUserChatBoxes({required int userId})async{
    try {
      final connection = PgConnect.connection;
      final result = await connection.execute(r'select * from chatbox cb where cb.userid in (select chatboxid from chatmate cm where cm.userid = $1  );',parameters:[userId] );
    if(result.isEmpty){
     return null;
       
    }

    return List.generate(result.length, (index){
      final chatboxData = result.elementAt(index).toColumnMap();
      return ChatBox(id: chatboxData['id'],name: chatboxData['name'], creatorId: chatboxData['creatorId'], admins: {}, secretPass: '', messages: []);
    });
    } catch (e) {
      print(e);
    }
    return null;
  }
  
 static Future<List<ChatBox>?> getCreatorChatBoxes({required int userId})async{
    try {
      final connection = PgConnect.connection;

      final result = await connection.execute(r'select * from chatbox cb where cb.creatorid  = $1;',parameters:[userId] );
    if(result.isEmpty){
     return null;
       
    }
    print(result.first);

    return List.generate(result.length, (index){
      final chatboxData = result.elementAt(index).toColumnMap();
      return ChatBox(id: chatboxData['id'],name: chatboxData['name'], creatorId: chatboxData['creatorId'], admins: {}, secretPass: '', messages: []);
    });
    } catch (e) {
      print(e);
    }
    return null;
  }
}