class ChecklistStep {
  final String call;
  final String response;
  const ChecklistStep(this.call, this.response);
}

class Checklist {
  final String id;
  final String title;
  final String phase;
  final bool memoryItem;
  final List<ChecklistStep> steps;

  const Checklist({
    required this.id,
    required this.title,
    required this.phase,
    required this.steps,
    this.memoryItem = false,
  });
}

class ChecklistLibrary {
  static const List<Checklist> all = [
    Checklist(
      id: 'before_start',
      title: 'BEFORE START',
      phase: 'GROUND',
      steps: [
        ChecklistStep('PARKING BRAKE', 'SET'),
        ChecklistStep('FUEL QUANTITY', 'CHECKED'),
        ChecklistStep('FLIGHT CONTROLS', 'FREE'),
        ChecklistStep('TRIM', 'SET FOR TAKEOFF'),
        ChecklistStep('BEACON', 'ON'),
      ],
    ),
    Checklist(
      id: 'before_takeoff',
      title: 'BEFORE TAKEOFF',
      phase: 'DEPARTURE',
      steps: [
        ChecklistStep('FLAPS', 'SET T/O'),
        ChecklistStep('TRANSPONDER', 'TA/RA'),
        ChecklistStep('CABIN', 'SECURE'),
        ChecklistStep('STROBES', 'ON'),
        ChecklistStep('RUNWAY', 'CLEAR & LINED UP'),
      ],
    ),
    Checklist(
      id: 'engine_failure_to',
      title: 'ENGINE FAILURE AT TAKEOFF',
      phase: 'EMERGENCY',
      memoryItem: true,
      steps: [
        ChecklistStep('BELOW V1', 'REJECT — IDLE / BRAKES MAX'),
        ChecklistStep('ABOVE V1', 'CONTINUE — ROTATE'),
        ChecklistStep('GEAR', 'UP (POSITIVE CLIMB)'),
        ChecklistStep('PITCH', 'V2 + 10'),
        ChecklistStep('AUTOTHRUST', 'AS REQUIRED'),
      ],
    ),
    Checklist(
      id: 'cabin_decompression',
      title: 'RAPID DEPRESSURIZATION',
      phase: 'EMERGENCY',
      memoryItem: true,
      steps: [
        ChecklistStep('OXYGEN MASKS', 'ON / 100%'),
        ChecklistStep('CREW COMMS', 'ESTABLISH'),
        ChecklistStep('DESCENT', 'INITIATE — MAX'),
        ChecklistStep('TARGET ALT', 'FL100 / MSA'),
        ChecklistStep('SIGNS', 'ON'),
      ],
    ),
    Checklist(
      id: 'approach',
      title: 'APPROACH',
      phase: 'ARRIVAL',
      steps: [
        ChecklistStep('ALTIMETERS', 'SET QNH'),
        ChecklistStep('SPEED BRAKE', 'ARMED'),
        ChecklistStep('FLAPS', 'CONFIG'),
        ChecklistStep('GEAR', 'DOWN — 3 GREEN'),
        ChecklistStep('LANDING CLEARANCE', 'OBTAINED'),
      ],
    ),
    Checklist(
      id: 'after_landing',
      title: 'AFTER LANDING',
      phase: 'GROUND',
      steps: [
        ChecklistStep('SPEED BRAKE', 'RETRACT'),
        ChecklistStep('FLAPS', 'UP'),
        ChecklistStep('TRANSPONDER', 'STBY'),
        ChecklistStep('APU', 'AS REQUIRED'),
        ChecklistStep('TAXI LIGHTS', 'ON'),
      ],
    ),
  ];

  static Checklist byId(String id) =>
      all.firstWhere((c) => c.id == id, orElse: () => all.first);
}
