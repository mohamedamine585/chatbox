

import 'dart:convert';
import 'dart:io';

import 'package:chatserver/data/chat_mate_repo.dart';

Future<void> sendJoinNotification(HttpRequest request) async {
     String body = await utf8.decoder.bind(request).join();
      final data = jsonDecode(body);
      await ChatMateRepo.joinChatbox(userId: data['userId'], chatboxId: data['chatboxId'], privilege: data['privilege']);
      request.response..statusCode = HttpStatus.ok..write(json.encode({'message':'joined chatbox'}));
   return;
  }

