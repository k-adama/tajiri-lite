import 'package:get/route_manager.dart';
import 'package:tajiri_waitress/presentation/controllers/auth/auth.binding.dart';
import 'package:tajiri_waitress/presentation/controllers/home/home.binding.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/cart/cart.binding.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.binding.dart';
import 'package:tajiri_waitress/presentation/controllers/order_history/order_history.binding.dart';
import 'package:tajiri_waitress/presentation/controllers/sales_reports/sales_reports.binding.dart';
import 'package:tajiri_waitress/presentation/controllers/splash/splash.binding.dart';
import 'package:tajiri_waitress/presentation/screens/auth/login.screen.dart';
import 'package:tajiri_waitress/presentation/screens/home/home.screen.dart';
import 'package:tajiri_waitress/presentation/screens/pos/cart/cart.screen.dart';
import 'package:tajiri_waitress/presentation/screens/pos/components/pos_search_product_screen.component.dart';
import 'package:tajiri_waitress/presentation/screens/pos/pos.screen.dart';
import 'package:tajiri_waitress/presentation/screens/order_history/order_history.screen.dart';
import 'package:tajiri_waitress/presentation/screens/sales_reports/sales_reports.screen.dart';
import 'package:tajiri_waitress/presentation/screens/sales_reports/sales_reports_result.screen.dart';
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
    GetPage(
      name: _Paths.ORDER_HISTORY,
      page: () => const OrderHistoryScreen(),
      binding: OrderHistoryBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartScreen(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_PRODUCT,
      page: () => const PosSearchProductScreen(),
      binding: PosBinding(),
    ),
    GetPage(
      name: _Paths.SALES_REPORT,
      page: () => const SalesReportScreen(),
      binding: SalesReportsBinding(),
    ),
    GetPage(
      name: _Paths.SALES_REPORT_RESULT,
      page: () => const SaleReportsResultScreen(),
    ),
  ];
}
