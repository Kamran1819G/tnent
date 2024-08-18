import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnent/core/helpers/color_utils.dart';
import 'package:tnent/core/helpers/snackbar_utils.dart';
import 'package:tnent/core/routes/app_pages.dart';
import 'package:tnent/core/routes/app_routes.dart';
import 'package:tnent/presentation/controllers/permission_controller.dart';
import 'package:tnent/services/notification_service.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final PermissionController permissionController =
      Get.put(PermissionController());

  await permissionController.requestPermissions();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.initialize();

  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool('onboarding') ?? false;
  runApp(MyApp(onboarding: onboarding));
}

class MyApp extends StatefulWidget {
  final bool? onboarding;

  const MyApp({Key? key, this.onboarding}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    checkForUpdates();

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationService.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationService.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationService.onDismissActionReceivedMethod,
    );

    super.initState();
  }

  Future<void> checkForUpdates() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          update();
        }
        if (info.updateAvailability == UpdateAvailability.updateNotAvailable) {
          showSnackBar(context, "Your app is up-to-date!",
              bgColor: Colors.green);
        }
      });
    }).catchError((e) {
      showSnackBar(context, "Failed to check for new releases: $e");
    });
  }

  void update() async {
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      showSnackBar(context, "Failed to auto-update: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ScreenUtilInit(
      designSize: const Size(642, 1376),
      builder: (_, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: hexToColor('#094446'),
          fontFamily: 'Gotham Black',
        ),
        initialRoute:
            widget.onboarding! ? AppRoutes.AUTH_GATE : AppRoutes.ONBOARDING,
        getPages: AppPages.pages,
      ),
    );
  }
}
