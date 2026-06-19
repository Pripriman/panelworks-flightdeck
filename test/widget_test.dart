import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flightdeck/domain/checklist_models.dart';
import 'package:flightdeck/widgets/attitude_mark.dart';

void main() {
  testWidgets('AttitudeMark renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: AttitudeMark(size: 80)),
        ),
      ),
    );
    expect(find.byType(AttitudeMark), findsOneWidget);
  });

  test('checklist library covers core phases', () {
    expect(ChecklistLibrary.byId('engine_failure_to').memoryItem, true);
    expect(ChecklistLibrary.byId('approach').phase, 'ARRIVAL');
    expect(ChecklistLibrary.all.length, greaterThanOrEqualTo(5));
  });
}
