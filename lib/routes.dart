import 'package:get/get.dart';

import 'views/exports.dart';

class Routes {
  static const String home = '/home';
  static const String ledDetail = '/led-detail';
  static const String debug = '/debug';

  static List<GetPage> pages = [
    GetPage(name: home, page: () => HomePage()),
    GetPage(
      name: ledDetail,
      page: () => LedDetailPage(),
    ),
    GetPage(name: debug, page: () => DebugPage())
  ];
}