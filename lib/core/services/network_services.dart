import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/color_utils.dart';

class NetworkServices extends GetxController {
  final Connectivity _connectivity = Connectivity();
  RxBool isRetrying = false.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      _showNoInternetDialog();
    } else {
      if (Get.isDialogOpen!) {
        isRetrying.value = false;
        Get.back(); // Close the dialog when the connection is restored
      }
    }
  }

  void _showNoInternetDialog() {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false, // Disable back button
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    color: Colors.grey,
                    size: 50,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Internet Connection',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please check your internet connection and try again.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      isRetrying.value = true;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hexToColor('#343434'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 20.0),
                    ),
                    child: Obx(
                      () => Text(
                        isRetrying.value ? 'Retrying...' : 'Retry',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false, // Prevent the dialog from being dismissed
      );
    }
  }
}
