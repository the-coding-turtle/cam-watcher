import 'package:cam_watcher/src/services/hive_service.dart';
import 'package:get/get.dart';

class StreamObject {
  String url;
  RxBool enabled;

  StreamObject({required this.url, required this.enabled});
}

class HomeController extends GetxController {
  late HiveService _hiveService;

  RxList<StreamObject> streamObjects = <StreamObject>[].obs;

  HomeController({required HiveService hiveService}) {
    _hiveService = hiveService;
    load();
  }

  void onAddButtonPressed() {
    streamObjects.add(StreamObject(url: "", enabled: false.obs));
  }

  void save() {
    _hiveService.addresses = streamObjects.map((e) => e.url).toList();
  }

  void load() {
    streamObjects.value = _hiveService.addresses
        .map((e) => StreamObject(url: e, enabled: true.obs))
        .toList();
  }
}
