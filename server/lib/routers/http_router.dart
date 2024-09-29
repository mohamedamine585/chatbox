// lib/routers/web_socket_router.dart
import 'dart:convert';
import 'dart:io';
import 'package:chatserver/data/auth.dart';
import 'package:chatserver/handlers/chatbox_handler.dart';
import 'package:chatserver/handlers/user_handler.dart';


Future<void> routeHttpRequest(HttpRequest request) async {
  try {
    final path =  request.uri.path;
  if(path.startsWith('/join-chatbox')){
    if(request.method == 'POST'){
     await handleJoinChatBox(request);
      
    }
  }  
  if (path.startsWith('/chatbox')) {
    if( request.method == 'POST'){
    await addChatBox(request);
  }
  else if(request.method == 'GET'){
    if(request.uri.pathSegments.length == 4){
      if(request.uri.pathSegments[2] == 'messages'){
      await  loadMessages(request);
      }
    }else{
    await getChatBox(request);

    }
      }
      else {
    request.response
      ..statusCode = HttpStatus.methodNotAllowed
      ..write('Method Not Allowed')
      ..close();
      }
  }
  else if(path.startsWith('/user')){
    print(request.uri.pathSegments);
     if(request.uri.pathSegments.length == 3){
     final userId = request.uri.pathSegments[1];

      if(request.uri.pathSegments[2] == 'chatboxes'){
         if(request.method == 'GET'){
              getUserChatBoxes(userId: int.parse(userId), request: request);
              return;
         }
      }else if(request.uri.pathSegments[2] == 'created-chatboxes'){
         if(request.method == 'GET'){
              getCreatorChatBoxes(userId: int.parse(userId), request: request);
              return;
         }
     }
     }
  }
  else if(path.startsWith('/auth')){
     String body = await utf8.decoder.bind(request).join();
    final json = jsonDecode(body);
    if(path.startsWith('/auth/signin')){
   
    final jwt =   await AuthRepository.signin(email: json["email"], password: json["password"]);
     if(jwt == null){
            request.response
      ..statusCode = HttpStatus.unauthorized
      ..write('Cannot signin user')
      ..close();
           }else{
            request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonEncode({'token':jwt.toString()}))
      ..close();
           
           }
    }else if(path.startsWith("/auth/signup")){
           final jwt = await AuthRepository.signup(email: json["email"],name: json["name"], password: json["password"]);
           if(jwt == null){
            request.response
      ..statusCode = HttpStatus.badRequest
      ..write('Cannot signup user')
      ..close();
           }else{
               request.response
      ..statusCode = HttpStatus.badRequest
      ..write(jsonEncode({'token':jwt}))
      ..close();
           }

    }
  }
   else {
    request.response
      ..statusCode = HttpStatus.notFound
      ..write('Not found')
      ..close();
  }
  } catch (e) {
    print(e);
    request.response
      ..statusCode = HttpStatus.internalServerError
      ..write('Error')
      ..close();
  }
  
    await request.response.close();
     return ;
   
  }

