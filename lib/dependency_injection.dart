import 'package:get/get.dart';
import 'package:tnent/core/services/network_services.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkServices>(NetworkServices(),
        permanent: true, tag: 'network-services');
  }
}
