import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/saran_response.dart';
import '../../../utils/api.dart';
import '../views/form_view.dart';
import '../views/index_view.dart';
import '../views/profile_view.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;
  final _getConnect = GetConnect();

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    IndexView(),
    FormView(),
    ProfileView(),
  ];

  @override
  void onInit() {
    getSaran();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  final token = GetStorage().read('token');

  Future<SaranResponse> getSaran() async {
    final response = await _getConnect.get(
      BaseUrl.sarans,
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    return SaranResponse.fromJson(response.body);
  }
}
