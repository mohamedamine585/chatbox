// lib/handlers/web_socket_handler.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chatserver/data/notification_data.dart';
import 'package:chatserver/data/user_repository.dart';




Future<void> notificationsPush(HttpRequest request) async {
  if(!WebSocketTransformer.isUpgradeRequest(request)){
      request.response
      ..statusCode = HttpStatus.badRequest
      ..write('Invalid request')
      ..close();
    return;
  }

  final userId = request.response.headers.value('x-user');
  final user = await UserRepository.getUserById(userId: int.parse(userId!));
  if(user == null){
     request.response
      ..statusCode = HttpStatus.notFound
      ..write('User Not Found')
      ..close();
    return;
  }
    final socket = await WebSocketTransformer.upgrade(request);
    NotificationData.notifications.putIfAbsent(int.parse(userId), ()=>{});
     
    final t = Timer.periodic(const Duration(seconds: 1), (t)async{
 

    final notifications = await NotificationData.getAllNotifications(userId: userId);
    notifications.forEach((not){
        if(!(NotificationData.notifications[int.parse(userId)]?.keys.contains(not['id']) ?? false)){
        NotificationData.notifications[int.parse(userId)]?.putIfAbsent(not['id'], ()=>not);
       
        socket.add(json.encode({'notification':not}));

                }

        });
        
       

     });
    socket.listen((d){},onDone: ()async{
    t.cancel();
      await request.response.close();
      NotificationData.notifications[int.parse(userId)] = {};
          return;
    });

 
}
