import '../models/user_model.dart';
import '../services/user_api_service.dart';
import '../../utils/logger.dart';

class UserRepository {
  final UserApiService _apiService;

  UserRepository({UserApiService? apiService})
      : _apiService = apiService ?? UserApiService();

  Future<List<UserModel>> fetchUsers() async {
    try {
      final jsonList = await _apiService.getUsers();
      final users = jsonList.map((e) => UserModel.fromJson(e)).toList();
      AppLogger.info('Fetched ${users.length} users');
      return users;
    } catch (e) {
      AppLogger.error('fetchUsers failed', e);
      rethrow;
    }
  }
}
