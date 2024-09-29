import 'package:chatserver/data/init_db.dart';
import 'package:chatserver/models/chat_box.dart';

class ChatBoxRepo {
 static Future<ChatBox?> addChatBox({ required String name , required int creatorId})async{
    try {
      final connection = PgConnect.connection;
   
      final result = await connection.execute(r'insert into chatbox(name,creatorid) values ($1,$2)',parameters: [name,creatorId]);
       final created = await connection.execute(r'select * from chatbox where name = $1 and creatorid = $2',parameters: [name,creatorId]);
      if(created == 0){
        return null;
      }
      final data = created.first.toColumnMap();
      return ChatBox(id: data['id'], name: name, creatorId: creatorId, admins:{creatorId}, secretPass: '', messages: []);
    } catch (e) {
      print(e);
    }
  }
  static Future<ChatBox?> rebuildChatBox({ required int id})async{
    try {
      final connection = PgConnect.connection;
   
       final box = await connection.execute(r'select * from chatbox where id = $1',parameters: [id]);
      if(box.isEmpty){
        return null;
      }
      final data = box.first.toColumnMap();
      return ChatBox(id: data['id'], name: data['name'], creatorId: data['creatorid'], admins:{data['creatorid']}, secretPass: '', messages: []);
    } catch (e) {
      print(e);
    }
  }
}
