import 'package:cam_watcher/src/views/home/home_controller.dart';
import 'package:cam_watcher/src/views/home/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_view_test.mocks.dart';

@GenerateMocks([HomeController])
void main() {
  late MockHomeController homeController;
  late GetMaterialApp testWidget;

  var stream1 = StreamObject(url: "abc", enabled: true.obs);
  var stream2 = StreamObject(url: "def", enabled: false.obs);
  setUp(() {
    homeController = MockHomeController();
    testWidget = GetMaterialApp(
      home: HomeView(controller: homeController),
    );
  });

  tearDown(() {
    reset(homeController);
    Get.reset();
  });

  group("HomeView", () {
    testWidgets("test should display only save and load button",
        (WidgetTester tester) async {
      when(homeController.streamObjects).thenReturn(<StreamObject>[].obs);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byKey(Key("button_save")), findsOneWidget);
      expect(find.byKey(Key("button_load")), findsOneWidget);
      expect(find.byKey(Key("text_field_0")), findsNothing);
      expect(find.byKey(Key("button_delete_0")), findsNothing);
      expect(find.byKey(Key("button_start_0")), findsNothing);
      expect(find.byKey(Key("stream_0")), findsNothing);
    });

    testWidgets("test should display one running and one stoped stream",
        (WidgetTester tester) async {
      when(homeController.streamObjects)
          .thenReturn(<StreamObject>[stream1, stream2].obs);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byKey(Key("text_field_0")), findsOneWidget);
      expect(find.byKey(Key("button_delete_0")), findsOneWidget);
      expect(find.byKey(Key("button_start-stop_0")), findsOneWidget);
      expect(find.byKey(Key("stream_0")), findsOneWidget);

      expect(find.byKey(Key("text_field_1")), findsOneWidget);
      expect(find.byKey(Key("button_delete_1")), findsOneWidget);
      expect(find.byKey(Key("button_start-stop_1")), findsOneWidget);
      expect(find.byKey(Key("stream_1")), findsNothing);

      expect(find.text("Start"), findsOneWidget);
      expect(find.text("Stop"), findsOneWidget);
    });

    testWidgets("test adds first stream", (WidgetTester tester) async {
      when(homeController.streamObjects).thenReturn(<StreamObject>[].obs);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key("button_add")));

      verify(homeController.onAddButtonPressed()).called(1);
    });

    testWidgets("test press stop/start/stop on stream1", (WidgetTester tester) async {
      when(homeController.streamObjects).thenReturn(<StreamObject>[stream1].obs);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text("Stop"), findsOneWidget);
      await tester.tap(find.byKey(Key("button_start-stop_0")));
      await tester.pumpAndSettle();
      expect(find.text("Start"), findsOneWidget);
      await tester.tap(find.byKey(Key("button_start-stop_0")));
      await tester.pumpAndSettle();
      expect(find.text("Stop"), findsOneWidget);
    });

    testWidgets("test press save/load", (WidgetTester tester) async {
      when(homeController.streamObjects).thenReturn(<StreamObject>[].obs);
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key("button_save")));
      await tester.tap(find.byKey(Key("button_load")));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      verify(homeController.save()).called(1);
      verify(homeController.load()).called(1);
    });
  });
}
