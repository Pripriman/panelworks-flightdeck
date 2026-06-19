import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DrillEntry {
  final String id;
  DateTime ranAt;
  String kind;
  String reference;
  String label;
  bool passed;

  DrillEntry({
    required this.id,
    required this.ranAt,
    required this.kind,
    required this.reference,
    required this.label,
    this.passed = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'ranAt': ranAt.toIso8601String(),
        'kind': kind,
        'reference': reference,
        'label': label,
        'passed': passed,
      };

  static DrillEntry fromJson(Map<String, dynamic> j) => DrillEntry(
        id: j['id'] as String,
        ranAt: DateTime.parse(j['ranAt'] as String),
        kind: j['kind'] as String? ?? '',
        reference: j['reference'] as String? ?? '',
        label: j['label'] as String? ?? '',
        passed: j['passed'] as bool? ?? true,
      );
}

class DrillLog extends ChangeNotifier {
  static const _STORE_KEY = 'fd.drills';
  static const _uuid = Uuid();

  final List<DrillEntry> _entries = [];
  bool _loaded = false;

  List<DrillEntry> get entries => List.unmodifiable(_entries);
  bool get isLoaded => _loaded;

  int get totalDrills => _entries.length;
  int get passedDrills => _entries.where((e) => e.passed).length;

  Set<String> get clearedReferences =>
      _entries.where((e) => e.passed).map((e) => e.reference).toSet();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_STORE_KEY);
    _entries.clear();
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List;
        for (final e in list) {
          _entries.add(DrillEntry.fromJson(e as Map<String, dynamic>));
        }
      } catch (_) {}
    }
    _entries.sort((a, b) => b.ranAt.compareTo(a.ranAt));
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_entries.map((e) => e.toJson()).toList());
    await prefs.setString(_STORE_KEY, encoded);
  }

  Future<DrillEntry> record({
    required String kind,
    required String reference,
    required String label,
    bool passed = true,
  }) async {
    final entry = DrillEntry(
      id: _uuid.v4(),
      ranAt: DateTime.now(),
      kind: kind,
      reference: reference,
      label: label,
      passed: passed,
    );
    _entries.insert(0, entry);
    await _persist();
    notifyListeners();
    return entry;
  }

  Future<void> remove(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await _persist();
    notifyListeners();
  }

  Map<String, int> byKind() {
    final map = <String, int>{};
    for (final e in _entries) {
      map[e.kind] = (map[e.kind] ?? 0) + 1;
    }
    return map;
  }
}
