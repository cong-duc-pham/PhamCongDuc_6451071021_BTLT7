import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_product.dart';

class SearchController {
  Future<List<SearchProduct>> searchProducts(String keyword) async {
    final url = Uri.parse(
      'https://dummyjson.com/products/search?q=${Uri.encodeComponent(keyword)}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonBody['products'];
      return jsonList.map((json) => SearchProduct.fromJson(json)).toList();
    } else {
      throw Exception('Tìm kiếm thất bại (status: ${response.statusCode})');
    }
  }
}