import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'access/crew_access_screen.dart';
import 'home/flight_console_shell.dart';
import 'intro/brief_deck.dart';

enum _Stage { boot, brief, access, console }

class NativeRoot extends StatefulWidget {
  const NativeRoot({super.key});

  @override
  State<NativeRoot> createState() => _NativeRootState();
}

class _NativeRootState extends State<NativeRoot> {
  static const _BRIEF_KEY = 'fd.briefDone';
  _Stage _stage = _Stage.boot;

  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    final prefs = await SharedPreferences.getInstance();
    final briefDone = prefs.getBool(_BRIEF_KEY) ?? false;
    if (!mounted) return;
    setState(() => _stage = briefDone ? _Stage.console : _Stage.brief);
  }

  Future<void> _finishBrief() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_BRIEF_KEY, true);
    if (!mounted) return;
    setState(() => _stage = _Stage.access);
  }

  void _finishAccess() => setState(() => _stage = _Stage.console);

  @override
  Widget build(BuildContext context) {
    switch (_stage) {
      case _Stage.boot:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      case _Stage.brief:
        return BriefDeck(onDone: _finishBrief);
      case _Stage.access:
        return CrewAccessScreen(onDone: _finishAccess);
      case _Stage.console:
        return const FlightConsoleShell();
    }
  }
}
