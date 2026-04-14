import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';
import '../../utils/logger.dart';

class UserApiService {
  /// GET /users → raw JSON list
  Future<List<dynamic>> getUsers() async {
    final url = Uri.parse('${AppConstants.baseUrl}${AppConstants.usersEndpoint}');
    AppLogger.info('GET $url');

    final response = await http.get(url);
    AppLogger.info('Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('HTTP ${response.statusCode}');
    }
  }
}