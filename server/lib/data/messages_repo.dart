import 'package:chatserver/data/init_db.dart';
import 'package:chatserver/models/message.dart';

class MessagesRepo {
 static Future<List<Message>> loadMessages({required int chatBoxId , required int shunk})async{
    try {
      final connection = PgConnect.connection;
      final result = await connection.execute(r'select * from message where chatboxid = $1 limit 10000*$2',parameters: [chatBoxId,shunk]);
      if(result.isEmpty){
        return [];
      }
    return  List.generate(result.length, (index){
       final messageData = result.elementAt(index).toColumnMap();
      return Message(id: messageData['id'], senderId: messageData['senderId'], content: messageData['content'], type: messageData['content'], sentAt: messageData['sentat']);
    });
    } catch (e) {
      print(e);
      return [];
    }
  }
}