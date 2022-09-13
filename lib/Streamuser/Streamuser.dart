import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:chat/Useful-functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Streamuser {
  Future<int?> SendemailverificationUnknown(
      {required String email, required BuildContext context}) async {
    int code = Random().nextInt(200000) + 100000;
    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(url,
          headers: {
            'origin': 'https://localhost',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'service_id': 'service_h5nm2jq',
            'template_id': 'template_5r930ni',
            'user_id': 'fxzk1Srw703sRHZbY',
            'template_params': {
              'user_email': email,
              'message': code,
            }
          }));
    } catch (e) {
      await showerrordialog(
          context: context,
          title: "Error",
          text: e.toString(),
          keybutton: "Ok");
      return null;
    }
    return code;
  }

  Timer Timeout(BuildContext context, int? verif) =>
      Timer(const Duration(seconds: 60), (() async {
        verif = null;
        await showerrordialog(
            context: context,
            title: "Time out",
            text: "Please resend the code",
            keybutton: "Ok");
      }));
}
