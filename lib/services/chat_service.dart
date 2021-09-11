import 'package:chat/models/chat_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat/global/enviroments.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/auth_service.dart';

class ChatService with ChangeNotifier {
  late User forUser;

  Future getChat(String userID) async {
    try {
      final uri = Uri.parse('${Enviroment.apiUrl}/messages/$userID');

      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final chatResponse = chatResponseFromJson(response.body);

      return chatResponse.messages;
    } catch (e) {
      return [];
    }
  }
}
