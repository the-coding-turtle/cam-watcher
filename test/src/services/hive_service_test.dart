import 'package:cam_watcher/src/services/hive_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

main() {
  late HiveService hiveService;
  setUp(() async {
    hiveService = await HiveService.init(isTestRunning: true);
  });

  tearDown(() {
    Get.reset();
  });

  group('hive storage service', () {
    test('test init() returns hive storage service object', () async {
      HiveService _hiveService = Get.find();

      expect(hiveService, _hiveService);
    });

    test('test get addresses returns empty list', () async {
      expect(hiveService.addresses, <String>[]);
    });

    test('test set addresses returns ["abc", "def"]', () async {
      const List<String> addresses = <String>["abc", "def"];

      hiveService.addresses = addresses;

      expect(hiveService.addresses, addresses);
    });
  });
}
