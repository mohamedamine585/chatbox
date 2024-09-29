// lib/handlers/web_socket_handler.dart
import 'dart:io';
import 'dart:convert';
import 'package:chatserver/data/chat_box_repo.dart';
import 'package:chatserver/data/user_repository.dart';
import 'package:chatserver/models/chat_box.dart';
import 'package:chatserver/models/chat_box_manager.dart';
import 'package:chatserver/models/message.dart';
import 'package:chatserver/models/user_socket.dart';



Future<void> handleWebSocket(HttpRequest request) async {
  if(!WebSocketTransformer.isUpgradeRequest(request)){
      request.response
      ..statusCode = HttpStatus.badRequest
      ..write('Invalid request')
      ..close();
    return;
  }
  if (request.uri.pathSegments.length != 2) {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write('Invalid path')
      ..close();
    return;
  }
  final boxId = request.uri.pathSegments[1];
  ChatBox? chatBox = ChatBoxManager.chatBoxes[boxId];
  if(chatBox == null){
    
     chatBox = await ChatBoxRepo.rebuildChatBox(id: int.parse(boxId));
    if(chatBox == null){
    request.response
      ..statusCode = HttpStatus.notFound
      ..write('Chatbox not found')
      ..close();
    return;
    }else{
      ChatBoxManager.chatBoxes.putIfAbsent(boxId, ()=>chatBox!);
    }
   
  }


  // fetch if user has secret
  final socket = await WebSocketTransformer.upgrade(request);
    final user = await UserRepository.getUserById(userId:int.parse( request.response.headers.value('x-user') ?? ''));
  if(user == null)
    {
       request.response
      ..statusCode = HttpStatus.notFound
      ..write('User not found')
      ..close();
    return;
    }
  final newUser = UserScoket(id: user.id,email: user.email, socket: socket, name: user.name, joinedAt: user.joinedAt);
  chatBox.addUser(newUser);
  socket.listen(
    (jdata) {
   
       final data = json.decode(jdata);
    
       Message message = Message(id: chatBox!.messages.length, senderId: data["senderId"],
        content: data["content"], type: messageTypeFromString(data["type"]), sentAt: DateTime.now());
      chatBox.addMessage( message);
    },
    onDone: () async{
     chatBox!.removeUserBySystem(newUser);
     if(chatBox.admins.contains(newUser.id) && chatBox.dieWithAdmin){
        ChatBoxManager.chatBoxes.remove(chatBox.id);
     }else{
        chatBox.broadcastEvent('DISCONNECTED_ADMIN', newUser.id.toString());
     }
     try {
        await request.response.close();

     } catch (e) {
       print(e.toString());
     }
    },
    onError: (error) {
     print(error);
    },
  );
}
