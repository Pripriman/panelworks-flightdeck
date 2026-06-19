import 'package:affise_attribution_lib/affise.dart';
import '../config/app_env.dart';

class PulseBeacon {
  static bool _running = false;

  static void boot() {
    if (_running || !AppEnv.hasBeacon) return;
    try {
      Affise
          .settings(
            affiseAppId: AppEnv.affiseAppId,
            secretKey: AppEnv.affiseSecret,
          )
          .setProduction(true)
          .start();
      _running = true;
    } catch (_) {}
  }

  static void _emit(String name) {
    if (!_running) return;
    try {
      Affise.sendEvent(UserCustomEvent(eventName: name));
    } catch (_) {}
  }

  static void firstOpen() => _emit('first_open');
  static void registration() => _emit('registration');
  static void login() => _emit('login');
  static void contentOpen() => _emit('content_open');
}
