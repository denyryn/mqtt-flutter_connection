import 'package:get/get.dart';

import 'views/exports.dart';

class Routes {
  static const String home = '/home';
  static const String ledDetail = '/led-detail';

  static List<GetPage> pages = [
    GetPage(name: home, page: () => HomePage()),
    GetPage(
      name: ledDetail,
      page: () => LedDetailPage(),
    ),
  ];
}
