import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tnennt/helpers/color_utils.dart';
import 'package:tnennt/screens/onboarding_screen.dart';
import 'package:tnennt/services/permission_handler_service.dart';
import 'package:tnennt/widget_tree.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final PermissionHandlerService _permissionHandler = PermissionHandlerService();
  await _permissionHandler.requestMultiplePermissions();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool('onboarding') ?? false;
  runApp(MyApp(onboarding: onboarding));
}

class MyApp extends StatelessWidget {
  final bool onboarding;

  const MyApp({super.key, this.onboarding = false});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ScreenUtilInit(
      designSize: Size(642, 1376),
      builder: (_ , child) => MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: hexToColor('#094446'),
          fontFamily: 'Gotham Black',
        ),
        home: onboarding ? WidgetTree() : OnboardingScreen(),
      ),
    );
  }
}
