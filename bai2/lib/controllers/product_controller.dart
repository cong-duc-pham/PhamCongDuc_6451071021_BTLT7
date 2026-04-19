import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductController {
  Future<Product> fetchProduct(int id) async {
    final url = Uri.parse('https://fakestoreapi.com/products/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Product.fromJson(json);
    } else {
      throw Exception('Không thể tải dữ liệu sản phẩm (status: ${response.statusCode})');
    }
  }
}