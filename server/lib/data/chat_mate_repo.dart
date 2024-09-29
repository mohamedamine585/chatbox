import 'package:chatserver/data/init_db.dart';
import 'package:chatserver/models/chatbox_mate.dart';

class ChatMateRepo {
  
  static  Future<ChatMate?> joinChatbox({required int userId,required int chatboxId ,required String privilege })async{
    try {
      final connection = PgConnect.connection;
      final result = await connection.execute(r'insert into chatmate(chatboxid,userid,privilege) values($1,$2,$3)',parameters:[chatboxId,userId,privilege] );
    
    } catch (e) {
      print(e);
    }
    return null;
  }
}