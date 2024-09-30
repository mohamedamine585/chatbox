// lib/routers/web_socket_router.dart
import 'dart:io';
import 'package:chatserver/handlers/notification_ws_handler.dart';

import '../handlers/ws_handler.dart';

Future<void> routeRequest(HttpRequest request) async {
  if (request.uri.path.startsWith('/chatbox')) {
    await handleWebSocket(request);
  
  }
  else if(request.uri.path == '/notifications'){
    await notificationsPush(request);
  }
   else {
    request.response
      ..statusCode = HttpStatus.notFound
      ..write('Not found')
      ..close();
  }
}
