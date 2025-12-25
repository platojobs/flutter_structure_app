import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_application_struture/core/services/loading_service.dart';
import 'package:flutter_application_struture/core/config/loading_config.dart';

void main() {
  test('LoadingService registers preset and applies it', () {
    final svc = LoadingService();

    const preset = LoadingConfig(
      loadingStyle: EasyLoadingStyle.light,
    );

    svc.registerPreset('test_light', preset);
    expect(svc.presets.contains('test_light'), isTrue);

    // applyPreset will call LoadingConfig.apply() which configures EasyLoading.
    // We still assert that currentPreset changes.
    svc.applyPreset('test_light');
    expect(svc.currentPreset, 'test_light');
  });
}
