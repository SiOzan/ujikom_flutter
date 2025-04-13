import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:ujikom_flutter/app/data/saran_response.dart';
import 'package:ujikom_flutter/app/utils/api.dart';

class IndexController extends GetxController {
  var isLoading = false.obs;
  var saranList = <Saran>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSaran(); // Ambil data saat controller diinisialisasi
  }

  Future<String?> getToken() async {
    final box = GetStorage();
    return box.read('token'); // Ambil token yang disimpan saat login
  }

  /// **🔹 Fungsi untuk Mengambil Data Saran dari API**
  Future<void> fetchSaran() async {
    try {
      isLoading.value = true;
      String fullUrl = '${BaseUrl.baseUrl}${BaseUrl.saran}';
      String? token = await getToken(); // Ambil token dari storage

      debugPrint("📡 Mengambil data dari API: $fullUrl");
      debugPrint("🔑 Token: $token");

      final response = await GetConnect().get(
        fullUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Tambahkan token di sini!
        },
      );

      debugPrint("📡 Response Status: ${response.statusCode}");
      debugPrint("📦 Response Body: ${response.body}");

      if (response.statusCode == 401) {
        debugPrint(
            "❌ Token tidak valid atau sesi berakhir. Harap login ulang.");
        // Bisa logout otomatis jika token invalid
        Get.offAllNamed('/login');
        return;
      }

      if (response.status.hasError || response.body == null) {
        debugPrint(
            "❌ Gagal mengambil data saran. Status: ${response.statusCode}");
        return;
      }

      final List<dynamic>? saranData = response.body['data'];
      debugPrint("📝 Data saran: $saranData");

      if (saranData == null) {
        debugPrint("⚠️ Tidak ada data saran yang dikembalikan API.");
        saranList.clear();
        return;
      }

      List<Saran> saranListParsed = saranData.map((saran) {
        return Saran.fromJson(saran);
      }).toList();

      saranList.assignAll(saranListParsed);
      debugPrint("✅ Data saran berhasil dimuat (${saranList.length} item).");
    } catch (e) {
      debugPrint("❌ Terjadi kesalahan saat mengambil data saran: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
