import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInitialConnectivity() async {
    List<ConnectivityResult> connectivityResults = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResults);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      isConnected.value = false;
    } else {
      isConnected.value = true;
    }
  }
}
