import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tnent/core/services/permission_handler_service.dart';

class PermissionController extends GetxController {
  final PermissionHandlerService _permissionHandlerService =
      PermissionHandlerService();

  var hasCameraPermission = false.obs;
  var hasNotificationPermission = false.obs;
  var hasLocationPermission = false.obs;
  var hasStoragePermission = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    hasCameraPermission.value = await _permissionHandlerService
        .checkPermissionStatus(Permission.camera);
    hasNotificationPermission.value = await _permissionHandlerService
        .checkPermissionStatus(Permission.notification);
    hasLocationPermission.value = await _permissionHandlerService
        .checkPermissionStatus(Permission.location);
    hasStoragePermission.value = await _permissionHandlerService
        .checkPermissionStatus(Permission.storage);
  }

  Future<void> requestPermissions() async {
    bool allGranted =
        await _permissionHandlerService.requestMultiplePermissions();
    if (allGranted) {
      checkPermissions();
    }
  }
}
