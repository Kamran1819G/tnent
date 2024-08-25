import 'package:get/get.dart';
import 'package:tnent/core/routes/app_routes.dart';
import 'package:tnent/presentation/pages/auth_gate.dart';
import 'package:tnent/presentation/pages/coming_soon.dart';
import 'package:tnent/presentation/pages/gallery_pages/contact.dart';
import 'package:tnent/presentation/pages/home_pages/community.dart';
import 'package:tnent/presentation/pages/home_screen.dart';
import 'package:tnent/presentation/pages/onboarding_screen.dart';
import 'package:tnent/presentation/pages/signin_screen.dart';
import 'package:tnent/presentation/pages/signup_screen.dart';
import 'package:tnent/presentation/pages/splash_screen.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.SPLASH, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.HOME_SCREEN, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.ONBOARDING, page: () => const OnboardingScreen()),
    GetPage(name: AppRoutes.SIGN_IN, page: () => const SignInScreen()),
    GetPage(name: AppRoutes.SIGN_UP, page: () => const SignUpScreen()),
    GetPage(name: AppRoutes.AUTH_GATE, page: () => const AuthGate()),
    GetPage(name: AppRoutes.COMING_SOON, page: () => const ComingSoon()),
    GetPage(name: AppRoutes.CONTACT, page: () => ContactScreen()),
  ];
}
