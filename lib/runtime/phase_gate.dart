import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/app_env.dart';
import '../config/route_blob.dart';
import 'backend_bus.dart';
import 'payload_unsealer.dart';

enum GateState { content, native, lostLink }

class GateVerdict {
  final GateState state;
  final String? endpoint;
  const GateVerdict(this.state, [this.endpoint]);
}

class PhaseGate {
  static const _ENDPOINT_KEY = 'fd.endpoint';
  static const _storage = FlutterSecureStorage();

  static Future<GateVerdict> resolve() async {
    final cached = await _freshEndpoint();
    if (cached != null) {
      return GateVerdict(GateState.content, cached);
    }

    if (!AppEnv.hasBackend) {
      return const GateVerdict(GateState.native);
    }

    String? key;
    try {
      key = await BackendBus.fetchPhaseKey();
    } catch (_) {
      return const GateVerdict(GateState.lostLink);
    }

    if (key == null || key.isEmpty) {
      return const GateVerdict(GateState.native);
    }

    final route = await PayloadUnsealer.reveal(RouteBlob.forPlatform(), key);
    if (route == null || route.isEmpty) {
      return const GateVerdict(GateState.native);
    }

    final reachable = await _probe(route);
    if (!reachable) {
      return const GateVerdict(GateState.native);
    }

    await _storeEndpoint(route);
    return GateVerdict(GateState.content, route);
  }

  static Future<bool> _probe(String route) async {
    try {
      final resp = await http
          .get(Uri.parse(route))
          .timeout(const Duration(seconds: AppEnv.PROBE_TIMEOUT_SEC));
      if (resp.statusCode != 200) return false;
      return resp.bodyBytes.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<String?> _freshEndpoint() async {
    try {
      final raw = await _storage.read(key: _ENDPOINT_KEY);
      if (raw == null) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final route = map['route'] as String?;
      final ts = map['ts'] as int?;
      if (route == null || ts == null) return null;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (age > AppEnv.ENDPOINT_TTL.inMilliseconds) return null;
      return route;
    } catch (_) {
      return null;
    }
  }

  static Future<void> _storeEndpoint(String route) async {
    try {
      final payload = jsonEncode({
        'route': route,
        'ts': DateTime.now().millisecondsSinceEpoch,
      });
      await _storage.write(key: _ENDPOINT_KEY, value: payload);
    } catch (_) {}
  }

  static Future<void> clearEndpoint() async {
    try {
      await _storage.delete(key: _ENDPOINT_KEY);
    } catch (_) {}
  }
}
