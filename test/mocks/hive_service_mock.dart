import 'package:cam_watcher/src/services/hive_service.dart';
import 'package:mockito/mockito.dart';

class MockHiveService extends Mock implements HiveService {
  MockHiveStorageService() {
    throwOnMissingStub(this);
  }

  @override
  List<String> get addresses => (super.noSuchMethod(Invocation.getter(#addresses),
      returnValue: <String>[],
      returnValueForMissingStub: <String>[]));

  @override
  set addresses(List<String> _addresses) =>
      super.noSuchMethod(Invocation.setter(#addresses, _addresses),
          returnValueForMissingStub: null);
}
