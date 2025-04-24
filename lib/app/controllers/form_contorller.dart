import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ujikom_flutter/app/data/add_saran_response.dart';
import 'package:ujikom_flutter/app/utils/api.dart';

class FormController extends GetxController {
  var isSubmitting = false.obs;

  Future<String?> getToken() async {
    final box = GetStorage();
    return box.read('token'); // Ambil token dari storage
  }

  /// 🔹 Fungsi untuk menyimpan saran baru ke API
  Future<void> submitSaran({
    required String nama,
    required String email,
    required String judul,
    required String deskripsi,
  }) async {
    try {
      isSubmitting.value = true;

      // Gunakan endpoint yang benar dari BaseUrl
      final String url = '${BaseUrl.baseUrl}${BaseUrl.saranStore}';
      final String? token = await getToken();

      debugPrint("📤 Mengirim data ke API: $url");
      debugPrint("📝 Data: $nama, $email, $judul, $deskripsi");
      debugPrint("🔑 Token: $token");

      final response = await GetConnect().post(
        url,
        {
          "nama": nama,
          "email": email,
          "judul": judul,
          "deskripsi": deskripsi,
        },
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint("📨 Response Status: ${response.statusCode}");
      debugPrint("📨 Response Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final res = AddSaranResponse.fromJson(response.body);

        Get.snackbar(
          "✅ Berhasil",
          res.message ?? "Saran berhasil dikirim",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.back(); // Kembali ke halaman sebelumnya jika berhasil
      } else if (response.statusCode == 401) {
        Get.offAllNamed('/login');
        Get.snackbar(
          "⚠️ Sesi berakhir",
          "Silakan login ulang",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        final msg = response.body['message'] ?? 'Gagal menyimpan saran';
        Get.snackbar(
          "❌ Gagal",
          msg.toString(),
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("❌ Exception saat mengirim saran: $e");
      Get.snackbar(
        "❌ Error",
        "Terjadi kesalahan saat menyimpan data",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
