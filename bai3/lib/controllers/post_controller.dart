import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostController {
  Future<Post> createPost(Post post) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Post.fromJson(json);
    } else {
      throw Exception('Gửi bài viết thất bại (status: ${response.statusCode})');
    }
  }
}