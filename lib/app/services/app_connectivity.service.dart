import 'package:connectivity_plus/connectivity_plus.dart';

abstract class AppConnectivityService {
  AppConnectivityService._();

  static Future<bool> connectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
