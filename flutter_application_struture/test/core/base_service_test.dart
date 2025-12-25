import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_struture/core/base/base_service.dart';

class DummyService extends BaseService {
  bool initialized = false;
  bool disposed = false;

  @override
  Future<void> init() async {
    initialized = true;
  }

  @override
  void dispose() {
    disposed = true;
  }
}

void main() {
  test('BaseService lifecycle methods', () async {
    final s = DummyService();
    expect(s.initialized, false);
    await s.init();
    expect(s.initialized, true);
    s.dispose();
    expect(s.disposed, true);
  });
}
