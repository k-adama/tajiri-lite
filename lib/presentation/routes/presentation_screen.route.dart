import 'package:get/route_manager.dart';
import 'package:tajiri_waitress/presentation/controllers/auth/auth.binding.dart';
import 'package:tajiri_waitress/presentation/controllers/home/home.binding.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.binding.dart';
import 'package:tajiri_waitress/presentation/controllers/splash/splash.binding.dart';
import 'package:tajiri_waitress/presentation/screens/auth/login.screen.dart';
import 'package:tajiri_waitress/presentation/screens/home/home.screen.dart';
import 'package:tajiri_waitress/presentation/screens/navigation/pos/pos.screen.dart';
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
      name: _Paths.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.POS,
      page: () => const PosScreen(),
      binding: PosBinding(),
    ),
  ];
}
