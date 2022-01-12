import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class HiveService extends GetxService {
  bool isTestRunning = false;
  late Box _box;

  List<String> get addresses => _box.get("addresses", defaultValue: <String>[]);

  set addresses(List<String> value) => _box.put('addresses', value);

  HiveService({required this.isTestRunning});

  static Future<HiveService> init({required bool isTestRunning}) async {
    await Hive.initFlutter();
    var _hiveService = HiveService(isTestRunning: isTestRunning);
    await _hiveService._init();
    Get.put(_hiveService);
    return _hiveService;
  }

  Future<void> _init() async {
    if (isTestRunning) {
      await _initTestBox();
    } else {
      await _initDeviceBox();
    }
  }

  Future<void> _initTestBox() async {
    String boxName = "testBox";
    await Hive.deleteBoxFromDisk(boxName);
    _box = await Hive.openBox(boxName);
  }

  Future<void> _initDeviceBox() async {
    _box = await Hive.openBox("deviceBox");
  }
}
