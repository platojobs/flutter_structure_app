import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_struture/core/base/base_repository.dart';

class DummyRepo extends BaseRepository {
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
  test('BaseRepository lifecycle methods', () async {
    final r = DummyRepo();
    expect(r.initialized, false);
    await r.init();
    expect(r.initialized, true);
    r.dispose();
    expect(r.disposed, true);
  });
}
