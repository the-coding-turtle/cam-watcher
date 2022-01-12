import 'package:cam_watcher/app_routes.dart';
import 'package:cam_watcher/src/services/hive_service.dart';
import 'package:cam_watcher/src/views/home/home_controller.dart';
import 'package:cam_watcher/src/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  await HiveService.init(isTestRunning: false);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HiveService _hiveService = Get.find();
    return GetMaterialApp(
      title: 'Cam Watcher',
      initialRoute: Routes.HOME,
      getPages: [
        GetPage(
          name: Routes.HOME,
          page: () {
            var _homeController =
                Get.put(HomeController(hiveService: _hiveService));
            return HomeView(controller: _homeController);
          },
        ),
      ],
    );
  }
}
