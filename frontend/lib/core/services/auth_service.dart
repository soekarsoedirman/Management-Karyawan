import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  Future<void> logout() async {
    await _api.logout();
    await _storage.deleteUserJson();
  }
}
