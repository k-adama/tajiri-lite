import 'package:get/route_manager.dart';
import 'package:tajiri_waitress/presentation/controllers/auth/auth.binding.dart';
import 'package:tajiri_waitress/presentation/controllers/navigation/navigation.binding.dart';
import 'package:tajiri_waitress/presentation/controllers/splash/splash.binding.dart';
import 'package:tajiri_waitress/presentation/screens/auth/login.screen.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/navigation.screen.dart';
import 'package:tajiri_waitress/presentation/screens/splash/splash.screen.dart';
part 'presentation_path.route.dart';

class PresentationScreenRoute {
  PresentationScreenRoute._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
        name: _Paths.LOGIN,
        page: () => const LoginScreen(),
        binding: AuthBinding()),
    GetPage(
      name: _Paths.NAVIGATION,
      page: () => const NavigationScreen(),
      binding: NavigationBiding(),
    ),
  ];
}
