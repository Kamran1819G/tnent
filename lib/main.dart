import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnent/helpers/color_utils.dart';
import 'package:tnent/screens/onboarding_screen.dart';
import 'package:tnent/services/permission_handler_service.dart';
import 'package:tnent/widget_tree.dart';

import 'controllers/notfication_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final PermissionHandlerService _permissionHandler =
  PermissionHandlerService();
  await _permissionHandler.requestMultiplePermissions();

  await AwesomeNotifications().initialize(
    null, // null means it will use the default app icon
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Color(0xFF9D50DD),
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'order_channel',
        channelName: 'Order Notifications',
        channelDescription: 'Notification channel for order notifications',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Color(0xFF9D50DD),
        importance: NotificationImportance.High,
        channelShowBadge: true,
      )
    ],
  );

  bool isNotificationAllowed =
  await AwesomeNotifications().isNotificationAllowed();
  if (!isNotificationAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
      NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
      NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
      NotificationController.onDismissActionReceivedMethod,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ScreenUtilInit(
      designSize: Size(642, 1376),
      builder: (_, child) => MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: hexToColor('#094446'),
          fontFamily: 'Gotham Black',
        ),
        home: widget.onboarding! ? WidgetTree() : OnboardingScreen(),
      ),
    );
  }
}