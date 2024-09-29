import 'dart:convert';
import 'dart:io';

import 'package:chatserver/data/messages_repo.dart';
import 'package:chatserver/data/user_repository.dart';
import 'package:chatserver/models/chat_box.dart';
import 'package:chatserver/models/chat_box_manager.dart';

Future<void> addChatBox(HttpRequest request)async{

     final creatorId = request.response.headers.value('x-user');
      print(creatorId);

     // do db staff and check everything
     final chatbox = await ChatBoxManager.addChatBox(creatorId: int.parse(creatorId ?? ""));
     if(chatbox== null){
           request.response..statusCode = HttpStatus.badRequest..write(json.encode({'message':'cannotCreateRoom'}));
            return;
     }
     request.response..statusCode = HttpStatus.created..write(json.encode({"chatbox":chatbox.toPartialJson()}));
   

}



Future<void> loadMessages(HttpRequest request)async{
  final String chatboxId = request.uri.path.split('/').elementAt(1);
      if(chatboxId == ""){
        request.response
      ..statusCode = HttpStatus.badRequest
      ..write('Bad Request')
      ..close();
      }
      else{
      ChatBox? chatbox =   ChatBoxManager.getChatBox(chatBoxId: chatboxId);
      if(chatbox != null){
        final shunk = request.uri.pathSegments[3];
           List<Map<String,dynamic>> messages = [];
           
           final loadedMessages = await MessagesRepo.loadMessages(chatBoxId: int.parse(chatboxId),shunk: int.parse(shunk));
           loadedMessages.forEach((m){
            messages.add({'messageId':m.id,'senderId':m.senderId,'content':m.content,'type':m.type,'sentAt':m.sentAt});
           });
           request.response..statusCode =
            HttpStatus.ok..write(json.encode({"messages":messages}));

      }else{
        request.response
      ..statusCode = HttpStatus.notFound
      ..write('ChatBox Not Found')
      ..close();
      }
     
     }
     await request.response.close();
     return ;
}

Future<void> getChatBox(HttpRequest request)async{
  final String chatboxId = request.uri.path.split('/').elementAt(1);
      if(chatboxId == ""){
        request.response
      ..statusCode = HttpStatus.badRequest
      ..write('Bad Request')
      ..close();
      }
      else{
      ChatBox? chatbox =   ChatBoxManager.getChatBox(chatBoxId: chatboxId);
      if(chatbox != null){
           request.response..statusCode =
            HttpStatus.created..write(json.encode({"boxId":chatbox.id}));

      }else{
        request.response
      ..statusCode = HttpStatus.notFound
      ..write('ChatBox Not Found')
      ..close();
      }
     
     }
     await request.response.close();
     return ;
}


Future<void> getUserChatBoxes({required int userId,required HttpRequest request})async{

     final user = await UserRepository.getUserById(userId: userId);
     print(user);
     if(user == null){
      request.response
      ..statusCode = HttpStatus.notFound
      ..write('ChatBox Not Found')
      ..close();
      return;
     }
     final cbs = await UserRepository.getUserChatBoxes(userId: userId);
  
    final chatboxes = List.generate(cbs?.length ?? 0, (index){
      return {
        'id':cbs?.elementAt(index).id,
        'name':cbs?.elementAt(index).name
      };
    });

    request.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode({'chatboxesids':chatboxes}))
      ..close();
      return;
}
Future<void> getCreatorChatBoxes({required int userId,required HttpRequest request})async{

     final user = await UserRepository.getUserById(userId: userId);

     if(user == null){
      request.response
      ..statusCode = HttpStatus.notFound
      ..write('ChatBox Not Found')
      ..close();
      return;
     }
     final cbs = await UserRepository.getCreatorChatBoxes(userId: userId);
    final chatboxes = List.generate(cbs?.length ?? 0, (index){
      return {
        'id':cbs?.elementAt(index).id,
        'name':cbs?.elementAt(index).name
      };
    });

    request.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode({'chatboxesids':chatboxes}))
      ..close();
      return;
}