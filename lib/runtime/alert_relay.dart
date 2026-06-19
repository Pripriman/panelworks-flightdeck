import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../config/app_env.dart';

class AlertRelay {
  static bool _armed = false;

  static Future<void> boot() async {
    if (_armed || !AppEnv.hasAlerts) return;
    try {
      OneSignal.initialize(AppEnv.oneSignalAppId);
      _armed = true;
    } catch (_) {}
  }

  static Future<void> requestClearance() async {
    if (!_armed) return;
    try {
      await OneSignal.Notifications.requestPermission(true);
    } catch (_) {}
  }

  static Future<void> bindCrew(String externalId) async {
    if (!_armed) return;
    try {
      await OneSignal.login(externalId);
    } catch (_) {}
  }

  static Future<void> releaseCrew() async {
    if (!_armed) return;
    try {
      await OneSignal.logout();
    } catch (_) {}
  }
}
