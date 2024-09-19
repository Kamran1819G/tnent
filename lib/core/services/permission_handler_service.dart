import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService {
  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  Future<bool> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      status = await Permission.notification.request();
    }
    return status.isGranted;
  }

  Future<bool> requestIgnoreBatteryOptimizationPermission() async {
    var status = await Permission.ignoreBatteryOptimizations.status;
    if (!status.isGranted) {
      status = await Permission.ignoreBatteryOptimizations.request();
    }
    return status.isGranted;
  }

  Future<bool> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }
    return status.isGranted;
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<bool> requestExternalStoragePermission() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
    }
    return status.isGranted;
  }

  Future<bool> requestMediaAccessPermission() async {
    var status = await Permission.accessMediaLocation.status;
    if (!status.isGranted) {
      status = await Permission.accessMediaLocation.request();
    }
    return status.isGranted;
  }

  Future<bool> requestMultiplePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.notification,
      Permission.camera,
      Permission.storage,
      Permission.accessMediaLocation,
    ].request();

    bool allGranted = true;
    statuses.forEach((permission, status) {
      if (!status.isGranted) {
        allGranted = false;
      }
    });

    return allGranted;
  }

  Future<bool> checkPermissionStatus(Permission permission) async {
    var status = await permission.status;
    return status.isGranted;
  }

  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
