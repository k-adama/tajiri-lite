part of 'presentation_screen.route.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const SPLASH = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const POS = _Paths.POS;
  static const SALE_HISTORY = _Paths.SALE_HISTORY;
  static const CART = _Paths.CART;
}

abstract class _Paths {
  _Paths._();

  static const LOGIN = '/login';
  static const SPLASH = "/splash";
  static const HOME = "/home";
  static const POS = "/pos";
  static const SALE_HISTORY = "/sale_history";
  static const CART = "/cart";
}
