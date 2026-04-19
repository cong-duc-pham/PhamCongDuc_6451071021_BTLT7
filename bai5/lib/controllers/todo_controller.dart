import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class TodoController {
  final String _baseUrl = 'https://dummyjson.com/todos';

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse('$_baseUrl?limit=10'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonBody['todos'];
      return jsonList.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Không thể tải danh sách task (status: ${response.statusCode})');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Xóa task thất bại (status: ${response.statusCode})');
    }
  }
}