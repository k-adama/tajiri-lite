import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_sdk/tajiri_sdk.dart';

class AppConstants {
  AppConstants._();

  /// shared preferences keys
  static const String keyAppThemeMode = 'keyAppThemeMode';
  static const TYPE_QUERY_ONLY_PRODUCT = 'ONLY_PRODUCT';
  static const String clientTypeRestaurant = 'RESTAURANT';

  static const String orderPaid = 'PAID';
  static const String orderCancelled = 'CANCELLED';
  static const String orderReady = 'READY';

  //..........................
  static const String orderOnPLace = 'ON_PLACE';
  static const String orderTakeAway = 'TAKE_AWAY';
  static const String orderDelivered = 'DELIVERED';

  //Status orders
  static const String ORDER_NEW = 'NEW';
  static const String ORDER_MODIFIED = 'MODIFIED';
  static const String ORDER_READY = 'READY';
  static const String ORDER_ACCEPTED_BY_RESTAURANT = 'ACCEPTED_BY_RESTAURANT';
  static const String ORDER_COOKING = 'COOKING';
  static const String ORDER_CANCELED = 'CANCELLED';
  static const String ORDER_DELIVRED = 'DELIVERED';
  static const String ORDER_TAKEN_BY_COURIER = 'TAKEN_BY_COURIER';
  static const String ORDER_DELIVERED = 'DELIVERED';
  static const String ORDER_PAID = 'PAID';

  //Permissions
  static const String CANCEL_ORDER = 'CANCEL_ORDER';
  static const String UPDATE_ORDER_PRODUCTS = 'UPDATE_ORDER_PRODUCTS';
  static const String VIEW_ORDERS_FULL = 'VIEW_ORDERS_FULL';
  static const String VIEW_INVENTORY = "VIEW_INVENTORY";
  static const String MANAGE_INVENTORY = "MANAGE_INVENTORY";

  static bool getStatusOrderInProgressOrDone(Order order, String status) {
    bool checking = false;
    switch (status) {
      case "IN_PROGRESS":
        if (order.status != ORDER_PAID && order.status != ORDER_CANCELED) {
          checking = true;
        }
        break;
      case "DONE":
        if (order.status == ORDER_READY) checking = true;
        break;
    }

    return checking;
  }

  static const List<Color> linearGradientBlue = [
    Color(0xff0000DD),
    Color(0xff6666FF),
  ];

  static String getStatusInFrench(Order order) {
    String status = "";
    switch (order.status) {
      case ORDER_COOKING:
        status = "En Cuisine";
        break;
      case ORDER_CANCELED:
        status = "Annulée";
        break;
      case ORDER_READY:
        status = "Prête";
        break;
      case ORDER_NEW:
        status = "Nouvelle";
        break;
      case ORDER_ACCEPTED_BY_RESTAURANT:
        status = "Acceptée";
        break;
      case ORDER_PAID:
        status = "Payée";
        break;
      case orderDelivered:
        status = "Livrée";
        break;
      case ORDER_TAKEN_BY_COURIER:
        status = "En livraison";
        break;
    }

    return status;
  }

  static String getOrderTypeInFrench(Order order) {
    String orderType = "";
    switch (order.orderType) {
      case orderOnPLace:
        orderType = "Sur place";
        break;
      case orderTakeAway:
        orderType = "A emporter";
      case orderDelivered:
        orderType = "A livrer";
        break;
    }

    return orderType;
  }
}

final tabs = [
  const Tab(text: "Tout"),
  const Tab(text: "En cours"),
  const Tab(text: "Prête"),
];

String? getNamePaiementById(String? id) {
  final payment = PAIEMENTS.firstWhereOrNull((element) => element['id'] == id);
  return payment != null ? payment['name'] : null;
}

const onPlaceSvg = "assets/svgs/onplace.svg";
const takeAwaySvg = "assets/svgs/take_away_icon.svg";
const deliveredSvg = "assets/svgs/ic_round-delivery-dining.svg";

const urlSound =
    'https://xuyfavsmxnbbaefzkdam.supabase.co/storage/v1/object/public/tajiri-foods/core/mixkit-arabian-mystery-harp-notification-2489.wav';

const List<Map<String, dynamic>> SETTLE_ORDERS = [
  {
    'name': 'Sur place',
    'id': 'ON_PLACE',
    'icon':
        onPlaceSvg, // Assuming OnPlace is a Dart class or a variable holding an icon
  },
  {
    'name': 'À emporter',
    'id': 'TAKE_AWAY',
    'icon':
        takeAwaySvg, // Assuming TakeAway is a Dart class or a variable holding an icon
  },
  {
    'name': 'À livrer',
    'id': 'DELIVERED',
    'icon': deliveredSvg,
  },
];

const cashAsset = "assets/svgs/cashpayment.svg";
const omAsset = "assets/svgs/orangepayment.svg";
const mtnAsset = "assets/svgs/mtnpayment.svg";
const waveAsset = "assets/images/wave_payment.png";
const tpeAsset = "assets/images/tpe24.png";
const autreAsset = "assets/images/card24.png";

List<Map<String, dynamic>> PAIEMENTS = [
  {
    'name': "Cash",
    'id': "d8b8d45d-da79-478f-9d5f-693b33d654e6",
    'icon': cashAsset,
  },
  {
    'name': "OM",
    'id': "7be4b57e-02a6-4c4f-b3a0-13597554fb5d",
    'icon': omAsset,
  },
  {
    'name': "MTN M",
    'id': "7af1ade3-8079-48ea-90bf-23cc06ea66ca",
    'icon': mtnAsset,
  },
  {
    'name': "Wave",
    'id': "6efbbe2d-3066-4a03-b52c-cb28f1990f44",
    'icon': waveAsset,
  },
  {
    'name': "TPE",
    'id': "5b5a6cc7-dd4f-4b9f-aef1-3cc5ccac30bf",
    'icon': tpeAsset,
  },
  {
    'name': "Autre",
    'id': "0017bf5f-4530-42dd-9dcd-7bd5067c757a",
    'icon': autreAsset,
  },
];

const DISHESID = "da1b8165-fd18-47bd-adb0-796b6b8e9415";
const DRINKSID = "25a48e57-211a-406c-bdbc-f76903551def";
const DIVERSID = "83f141d7-0dc6-4312-be63-116a3a309519";
