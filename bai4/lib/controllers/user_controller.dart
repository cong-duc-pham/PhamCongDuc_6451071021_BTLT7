import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserController {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com/users';

  Future<User> fetchUser(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Không thể tải thông tin user (status: ${response.statusCode})');
    }
  }

  Future<User> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Cập nhật thất bại (status: ${response.statusCode})');
    }
  }
}