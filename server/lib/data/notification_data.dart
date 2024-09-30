import 'package:chatserver/data/init_db.dart';

class NotificationData {

  static Map<int,Map<int,dynamic>> notifications  = {};
 static Future<bool?> sendJoinNotification({required String senderId , required String targetId , required String chatboxId})async{
    try {
      final connection = PgConnect.connection;
      final result = await connection.execute(r'insert into join_chatbox_notification(senderid,targetid,chatboxid) values($1,$2,$3)',parameters: [senderId,targetId,chatboxId]);
      return result.affectedRows != 0;
    } catch (e) {
      print(e);
    }
    return null;
  }
  static Future<List<Map<String,dynamic>>> getAllNotifications({required String userId})async{
    List<Map<String,dynamic>> notifications = [];
      try {
         final connection = PgConnect.connection;
      final result = await connection.execute(r'select jn.id as jnid,jn.senderid,jn.chatboxid,jn.sentat,cu.name as sendername,cb.name as chatboxname from join_chatbox_notification as jn join cuser cu on cu.id = jn.senderid join chatbox cb on cb.id = jn.chatboxid where jn.targetid = $1 and checked = false',parameters: [userId]);
        result.forEach((r){
         final data = r.toColumnMap();

          notifications.add({
             'subject':'JOIN_CHATBOX',
             'id':data['jnid'],
             'senderid': data['senderid'],
             'chatboxid':data['chatboxid'],
             'timestamp':data['sentat'].toString(),
             'chatboxName':data['chatboxname'],
             'userName':data['sendername']
          });
        });
      } catch (e) {
        print(e);
      }
      return notifications;
  }
}
