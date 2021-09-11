import 'package:http/http.dart' as http;

import 'package:chat/global/enviroments.dart';
import 'package:chat/models/user.dart';
import 'package:chat/models/users_response.dart';
import 'package:chat/services/auth_service.dart';

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final uri = Uri.parse('${Enviroment.apiUrl}/users/');

      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final usersResponse = usersResponseFromJson(response.body);

      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }
}
