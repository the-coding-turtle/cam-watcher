import 'package:cam_watcher/src/views/home/home_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/hive_service_mock.dart';

main() async {
  late MockHiveService mockHiveService;
  late HomeController homeController;

  setUp(() {
    mockHiveService = MockHiveService();
  });

  tearDown(() {
    reset(mockHiveService);
  });

  group('HomeController', () {
    test('test has 0 streamobjects ', () async {
      homeController = HomeController(hiveService: mockHiveService);

      verify(mockHiveService.addresses).called(1);
      expect(homeController.streamObjects.length, 0);
    });

    test('test has 2 enabled streamobjects ', () async {
      when(mockHiveService.addresses).thenReturn(<String>["abc", "def"]);

      homeController = HomeController(hiveService: mockHiveService);

      expect(homeController.streamObjects.length, 2);
      expect(homeController.streamObjects[0].url, "abc");
      expect(homeController.streamObjects[0].enabled.value, true);
      expect(homeController.streamObjects[1].url, "def");
      expect(homeController.streamObjects[1].enabled.value, true);
    });

    test('test adds new stream', () async {
      when(mockHiveService.addresses).thenReturn(<String>[]);

      homeController = HomeController(hiveService: mockHiveService);
      homeController.onAddButtonPressed();

      expect(homeController.streamObjects.length, 1);
      expect(homeController.streamObjects[0].enabled.value, false);
    });
  });
}
