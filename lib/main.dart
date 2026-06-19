import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'domain/drill_log.dart';
import 'runtime/backend_bus.dart';
import 'runtime/alert_relay.dart';
import 'runtime/pulse_beacon.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  try {
    await BackendBus.boot();
  } catch (_) {}

  await AlertRelay.boot();
  PulseBeacon.boot();

  final drills = DrillLog();
  await drills.load();

  await _markFirstOpen();

  runApp(FlightDeckApp(drills: drills));
}

Future<void> _markFirstOpen() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    const key = 'fd.firstOpenSent';
    if (!(prefs.getBool(key) ?? false)) {
      PulseBeacon.firstOpen();
      await prefs.setBool(key, true);
    }
  } catch (_) {}
}
