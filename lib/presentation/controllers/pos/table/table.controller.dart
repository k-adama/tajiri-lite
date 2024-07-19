import 'package:get/get.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/services/app_connectivity.service.dart';
import 'package:tajiri_sdk/src/models/table.model.dart' as taj_sdk;
import 'package:tajiri_sdk/tajiri_sdk.dart';

class TableController extends GetxController {
  RxList<taj_sdk.Table> tableListData = List<taj_sdk.Table>.empty().obs;
  bool isLoadingTable = false;
  bool isListView = true;
  String? tableId;
  Rx<taj_sdk.Table?> selectedTable = Rx<taj_sdk.Table?>(null);
  static final user = AppHelpersCommon.getUserInLocalStorage();
  final restaurantId = user?.restaurantId;
  final tajiriSdk = TajiriSDK.instance;

  @override
  void onReady() async {
    await fetchTables();
    super.onReady();
  }

  clearSelectTable() {
    selectedTable.value = null;
  }

  Future<void> fetchTables() async {
    if (restaurantId == null) {
      return;
    }
    final connected = await AppConnectivityService.connectivity();
    if (connected) {
      isLoadingTable = true;
      update();
      try {
        isLoadingTable = true;
        update();
        final result = await tajiriSdk.tablesService.getTables(restaurantId!);
        tableListData.assignAll(result);
        isLoadingTable = false;
        update();
      } catch (e) {
        isLoadingTable = false;
        update();
      }
    }
  }
}
