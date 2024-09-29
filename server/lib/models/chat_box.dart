// lib/models/chat_box.dart

import 'dart:convert';

import 'package:chatserver/models/message.dart';
import 'package:chatserver/models/user.dart';
import 'package:chatserver/models/user_socket.dart';

class ChatBox {
  String? superId  ;
  final int id;
  final String secretPass;
  int? creatorId;
  final String name;
  final Set<int> admins;
  final Set<String> bannedUsers = {};
  List<Message> messages = [];
  final Set<UserScoket> usersSockets = {};
    final Set<User> users = {};

  int maxInMemoryMessages = 10000;

  // whether to keep the discussion inside the box
  bool closedBox = false;

  bool dieWithAdmin = false;


  bool hasEndToEndEncryption = false;

  ChatBox({required this.id,required this.name,required this.creatorId,required this.admins,required this.secretPass,required this.messages,this.superId});

  void shareAuthority(List<int> newAdmins){
    this.admins.addAll(newAdmins);

  }
  void transferAuthority(List<int> newAdmins){
    this.admins.addAll(newAdmins);
    this.admins.remove(this.creatorId);
    this.creatorId = newAdmins.first;
  }

  
  void addMessage( Message message) {
    if(this.messages.length == maxInMemoryMessages){
      this.messages.removeAt(0);
    }
    messages.add(message);
    broadcastEvent("BROADCAT_MESSAGE", message.id.toString());
    broadcastMessage(message);
  
    /* 
    if(!this.closedBox){
     // store new state in postgres db
    }
    
    */
  }

  broadcastMessage(Message message){
    this.usersSockets.forEach((userSocket){
    
      userSocket.socket.add(json.encode({
        "senderId":message.senderId,
        "content":message.content,
        "type":message.type.toString(),
        "timestamp":message.sentAt.toIso8601String()
      }));
    });
  }
  
  broadcastEvent(String event,String data){
    this.usersSockets.forEach((userSocket){
      userSocket.socket.add(json.encode({
        "event":event,
        "data":data
      }));
    });
  }
// Convert ChatBox to JSON
 Map<String, dynamic> toPartialJson() {
    return {
      'id': id,
      'creatorId': creatorId,
      'name': name,
      
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'superId': superId,
      'id': id,
      'secretPass': secretPass,
      'creatorId': creatorId,
      'name': name,
      'admins': admins.toList(),
      'bannedUsers': bannedUsers.toList(),
      'messages': messages.map((message) => message.toJson()).toList(),
      'usersSockets': usersSockets.map((userSocket) => userSocket.toJson()).toList(),
      'users': users.map((user) => user.toJson()).toList(),
      'maxInMemoryMessages': maxInMemoryMessages,
      'closedBox': closedBox,
      'dieWithAdmin': dieWithAdmin,
      'hasEndToEndEncryption': hasEndToEndEncryption,
    };
  }



  void addUser(UserScoket user) {
    if(this.bannedUsers.contains(user.id)){
      // throw Cannot Access chatBox
      return;
    }
    usersSockets.add(user);
    this.broadcastEvent('CONNECT_USER', user.id.toString());
    this.messages.forEach((message){

      user.socket.add(json.encode({
        "senderId":message.senderId,
        "content":message.content,
        "type":message.type.toString(),
        "timestamp":message.sentAt.toIso8601String()
      }));
    });
  }

  Future<void> removeUserBySystem(UserScoket user)async{
    this.users.remove(user);

    this.broadcastEvent('DISCONNECT_USER', user.id.toString());

    try {

      await user.socket.close();

    } catch (e) {
      print(e);
    }
    }
  

  Future<void> removeUser(String actorId,UserScoket user) async{
    if(this.admins.contains(actorId)){
    
    this.users.remove(user);
    this.bannedUsers.add(user.id.toString());
    try {

      this.broadcastEvent('REMOVE_USER', user.id.toString());
      await user.socket.close();

    } catch (e) {
      print(e);
    }
    broadcastEvent("REMOVE_USER", user.id.toString());
    }else{
      // Throw exception
    }

  }

  void deleteMessage(String messageId){
    messages.removeWhere((m)=>m.id == messageId);
    broadcastEvent("DELETE_MESSAGE", messageId);
    
  }

  void banUser(String actorId , String userId){
    if(this.admins.contains(actorId) && this.users.where((u)=>u.id == userId).isNotEmpty && !this.bannedUsers.contains(userId)){
      this.bannedUsers.add(userId);
      broadcastEvent("BAN_USER", userId);
      // store new state in postgres db


      
    }
    else{
      // throw an exception
    }
  }
  
 
}
