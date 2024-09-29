// lib/server.dart
import 'dart:io';
import 'package:chatserver/data/init_db.dart';
import 'package:chatserver/middlewares/jwt_middleware.dart';
import 'package:chatserver/routers/http_router.dart';

import '/routers/ws_router.dart';

void main() async {
  await PgConnect().initConnection();
  final server = await HttpServer.bind(InternetAddress.tryParse('0.0.0.0'), 3000);
  print('Serving WebSocket server at ws://localhost:3000/');

  await for (var request in server) {

   JWTMiddleware.call(request, ()async{
     if(!WebSocketTransformer.isUpgradeRequest(request)){
    await routeHttpRequest(request);
    }
    else {
    await routeRequest(request);

    }

  });
   }
   
   
   
}