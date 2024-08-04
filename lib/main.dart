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
import 'package:tnent/services/notification_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final PermissionHandlerService permissionHandler = PermissionHandlerService();
  await permissionHandler.requestMultiplePermissions();

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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ScreenUtilInit(
      designSize: const Size(642, 1376),
      builder: (_, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: hexToColor('#094446'),
          fontFamily: 'Gotham Black',
        ),
        home:
            widget.onboarding! ? const WidgetTree() : const OnboardingScreen(),
      ),
    );
  }
}
