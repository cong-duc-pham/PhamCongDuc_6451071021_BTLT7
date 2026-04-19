import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsController {
  Future<List<Article>> fetchNews() async {
    // Random page để mỗi lần pull to refresh ra dữ liệu khác nhau
    final skip = Random().nextInt(90);
    final url = Uri.parse(
      'https://dummyjson.com/posts?limit=10&skip=$skip',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonBody['posts'];
      return jsonList.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Không thể tải tin tức (status: ${response.statusCode})');
    }
  }
}