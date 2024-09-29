import 'package:chatserver/data/chat_box_repo.dart';
import 'package:chatserver/data/chat_mate_repo.dart';
import 'package:chatserver/data/user_repository.dart';
import 'package:chatserver/models/chat_box.dart';
import 'package:chatserver/models/chatbox_mate.dart';

class ChatBoxManager {
 static  Map<String,ChatBox> chatBoxes = {};
 static int maxBoxes = 1000 ;


 static Future<ChatBox?> addChatBox({required int creatorId})async{
  try {
    final user = await UserRepository.getUserById(userId: creatorId);
   if(user == null)
     return null;

   // produce new chatbox Id to kafka
    final chatbox = await ChatBoxRepo.addChatBox( name: DateTime.now().toString(), creatorId: creatorId);
    if(chatbox == null){
      throw Error();
    }
        await ChatMateRepo.joinChatbox(userId: creatorId, chatboxId: chatbox.id, privilege: roleToString(Role.ADMIN));

       chatBoxes.putIfAbsent(chatbox.id.toString(), ()=>chatbox);

    return chatbox; 
  } catch (e) {
    print(e);
  }
  
 }

 static ChatBox cloneChatBox({required ChatBox chatBox}){
   return ChatBox(id:  chatBoxes.keys.length,name: "name",creatorId:  chatBox.creatorId,admins:  chatBox.admins,secretPass:  chatBox.secretPass,messages:  chatBox.messages);
 }

 static ChatBox createChildBox({required int creatorId,required ChatBox chatBox}){
   return ChatBox(id: chatBoxes.keys.length,name:"name",superId: chatBox.superId,creatorId:  creatorId,admins:  {creatorId},secretPass:  chatBox.secretPass,messages:  chatBox.messages);
 }
 

 static removeChatBox({required String chatBoxId}){

   
    if(chatBoxes.containsKey(chatBoxId)){

       final chatbox = chatBoxes[chatBoxId];
  
   chatbox?.broadcastEvent('KILL_CHATBOX', 'ChatBox removed.');

   chatbox!.usersSockets.forEach((u)
   async
   {
    await u.socket.close();
     
      });

    chatbox.messages = [];

   chatBoxes.remove(chatBoxId);
    }
 }

 static ChatBox? getChatBox({required String chatBoxId}){
  return chatBoxes[chatBoxId];
 }
}