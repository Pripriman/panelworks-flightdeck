import 'package:flutter/widgets.dart';
import '../domain/drill_log.dart';

class DeckScope extends InheritedNotifier<DrillLog> {
  const DeckScope({
    super.key,
    required DrillLog drills,
    required super.child,
  }) : super(notifier: drills);

  static DrillLog of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DeckScope>();
    assert(scope != null, 'DeckScope not found in context');
    return scope!.notifier!;
  }

  static DrillLog read(BuildContext context) {
    final scope = context
        .getElementForInheritedWidgetOfExactType<DeckScope>()
        ?.widget as DeckScope?;
    return scope!.notifier!;
  }
}
