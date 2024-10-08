import 'package:get/get.dart';
import 'package:red_voznje_novi_sad_flutter/shared/controllers/network_controller.dart';

class DependencyInjection {
  static void init(){
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}