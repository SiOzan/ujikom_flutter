import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujikom_flutter/app/modules/profile/controllers/profile_controller.dart';
import 'package:ujikom_flutter/app/utils/api.dart';

class LoginController extends GetxController {
  final GetConnect _getConnect = GetConnect();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GetStorage authToken = GetStorage();
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApi();
  }

  void _initializeApi() {
    _getConnect.timeout = const Duration(seconds: 30);
    _getConnect.baseUrl = BaseUrl.baseUrl;
  }

  Future<void> loginNow() async {
    try {
      // **Validasi Input**
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        throw Exception('⚠️ Email dan password harus diisi');
      }

      isLoading.value = true;
      update();

      // **Debug logs**
      debugPrint('🔐 Attempting login with:');
      debugPrint('📧 Email: ${emailController.text}');
      debugPrint('🔑 Password: ${passwordController.text}');
      debugPrint('🌐 URL: ${BaseUrl.baseUrl}${BaseUrl.login}');

      final response = await _getConnect.post(
        BaseUrl.login,
        {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      // **Debug response**
      debugPrint('📡 Response Status: ${response.statusCode}');
      debugPrint('📦 Response Body: ${response.body}');

      if (response.status.hasError) {
        final message = response.body?['message'] ??
            response.body?['error'] ??
            '❌ Login gagal, coba lagi';
        throw Exception(message);
      }

      // **Ambil token dari response**
      final token = response.body['access_token'] ?? response.body['token'];
      if (token == null) {
        throw Exception('⚠️ Token tidak ditemukan dalam response');
      }

      // **Simpan token**
      await authToken.write('token', token);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      debugPrint('✅ Login sukses! Token baru: $token');

      // **Muat ulang data user baru**
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        await profileController.getProfile();
        profileController.update();
      } else {
        Get.put(ProfileController()).getProfile();
      }

      // **Clear form setelah login sukses**
      emailController.clear();
      passwordController.clear();

      // **Arahkan ke halaman utama**
      Get.offAllNamed('/dashboard');
    } catch (e) {
      debugPrint('❌ Login error: $e');
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception:', '').trim(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
