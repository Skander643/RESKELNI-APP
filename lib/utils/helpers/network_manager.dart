import 'dart:async';

import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:e_commerce_app/common/widgets/loaders/loaders.dart';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  late StreamSubscription<InternetConnectionStatus> _connectivitySubscription;
  final RxBool _isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = InternetConnectionChecker()
        .onStatusChange
        .listen(_updateConnectionStatus);

        
  }

  void _updateConnectionStatus(InternetConnectionStatus status) {
    _isConnected.value = status == InternetConnectionStatus.connected;
    if (status != InternetConnectionStatus.connected) {
      TLoaders.warningSnackBar(title: 'Pas de connexion internet');
    }
  }

  Future<bool> isConnected() async {
    return await InternetConnectionChecker().hasConnection;
  }

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }
}
