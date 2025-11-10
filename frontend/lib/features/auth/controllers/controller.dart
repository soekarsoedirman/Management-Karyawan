import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/config/routes.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/models/user.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService();

  //state loading
  var isLoading = false.obs;
  //state role
  var userRole = ''.obs;
  //state user
  final currentUser = Rxn<User>();

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final data = await _apiService.login(email, password);
      debugPrint('AuthController.login: raw login response: $data');
      final token = data['token'] as String?;
      debugPrint('AuthController.login: token: $token');
      if (token == null) {
        Get.snackbar('Login gagal', 'Token tidak diterima');
        return;
      }

      //fitur decode token
      final payload = _apiService.decodeJwtPayload(token);
      debugPrint('AuthController.login: decoded token payload: $payload');
      final roleId = payload?['roleId'] ?? payload?['role_id'];

      //fitur simpan user
      await _storage.saveUserJson(jsonEncode(payload ?? {}));
      final u = payload != null ? User.fromJwtPayload(payload) : null;
      currentUser.value = u;

      //fitur ambil role
      String roleName = '';
      if (roleId != null) {
        final roleResp = await _apiService.getRoleById(
          int.parse(roleId.toString()),
        );
        debugPrint('AuthController.login: roleResp: $roleResp');
        if (roleResp != null) {
          final roleData = roleResp['data'] ?? roleResp;
          roleName =
              roleData['nama']?.toString() ??
              roleData['name']?.toString() ??
              '';
        }
      }

      //fitur simpan role dan navigasi
      userRole.value = roleName;

      final rn = roleName.toLowerCase();
      if (rn == 'admin') {
        Get.offAllNamed(Routes.adminDashboard);
      } else if (rn == 'cashier' || rn == 'kasir') {
        Get.offAllNamed(Routes.employeeDashboard); 
      } else {
        Get.offAllNamed(Routes.employeeDashboard);
      }
    } catch (e) {
      final msg = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Login gagal';
      Get.snackbar('Login error', msg);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    await _storage.deleteUserJson();
    Get.offAllNamed(Routes.auth);
  }
}
