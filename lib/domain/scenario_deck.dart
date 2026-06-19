class ScenarioOption {
  final String label;
  final bool correct;
  final String debrief;
  const ScenarioOption(this.label, this.correct, this.debrief);
}

class Scenario {
  final String id;
  final String phase;
  final String callout;
  final String situation;
  final List<ScenarioOption> options;

  const Scenario({
    required this.id,
    required this.phase,
    required this.callout,
    required this.situation,
    required this.options,
  });
}

class HistoricalCase {
  final String id;
  final String name;
  final String year;
  final String summary;
  final String decision;

  const HistoricalCase({
    required this.id,
    required this.name,
    required this.year,
    required this.summary,
    required this.decision,
  });
}

class PassengerCue {
  final String phase;
  final String feeling;
  final String deck;
  const PassengerCue(this.phase, this.feeling, this.deck);
}

class ScenarioDeck {
  static const List<Scenario> drills = [
    Scenario(
      id: 'eng2_140',
      phase: 'TAKEOFF',
      callout: 'ENGINE 2 FAILURE — 140 KTS',
      situation:
          'Rolling down the runway, just below V1, a loud bang and a yaw to the right. The right engine has failed.',
      options: [
        ScenarioOption('Reject the takeoff', true,
            'Below V1 the correct action is to reject: throttles idle, max braking, spoilers and reverse. Stopping is assured.'),
        ScenarioOption('Continue and rotate', false,
            'Above V1 you would continue, but here you are still below decision speed — rejecting is the safe call.'),
        ScenarioOption('Serve coffee', false,
            'Not now. A failure at takeoff demands an immediate reject-or-continue decision.'),
      ],
    ),
    Scenario(
      id: 'bird_climb',
      phase: 'CLIMB',
      callout: 'BIRD STRIKE — BOTH ENGINES',
      situation:
          'Shortly after liftoff a flock of geese is ingested. Both engines lose thrust. You are low and slow.',
      options: [
        ScenarioOption('Establish best glide, pick a landing site', true,
            'With no thrust, fly the aircraft: best glide speed, find the nearest survivable surface. This is the Hudson decision.'),
        ScenarioOption('Try to climb back to the airport', false,
            'Without thrust you cannot stretch the glide to the field. Energy management toward a reachable site wins.'),
        ScenarioOption('Restart engines and wait', false,
            'Relight is attempted, but you must simultaneously commit to a forced landing — waiting wastes altitude.'),
      ],
    ),
    Scenario(
      id: 'smoke_cruise',
      phase: 'CRUISE',
      callout: 'SMOKE IN THE CABIN',
      situation:
          'At cruise, smoke begins filling the cabin. Source is unknown but worsening.',
      options: [
        ScenarioOption('Don oxygen, divert immediately', true,
            'Smoke/fire is a land-ASAP item. Crew oxygen on, declare emergency, divert to the nearest suitable airport now.'),
        ScenarioOption('Continue to destination', false,
            'Fire and smoke do not wait. Time is the enemy — the nearest runway, not the planned one.'),
        ScenarioOption('Open a window', false,
            'Cabin windows do not open in flight. Isolate the source and get on the ground.'),
      ],
    ),
    Scenario(
      id: 'gear_unsafe',
      phase: 'APPROACH',
      callout: 'GEAR UNSAFE — NOSE',
      situation:
          'On approach the nose gear shows unsafe. Mains are down and locked.',
      options: [
        ScenarioOption('Run the gear malfunction checklist, hold', true,
            'Do not rush. Hold, burn fuel, work the alternate-extension procedure and brief the cabin before a precautionary landing.'),
        ScenarioOption('Force it down hard', false,
            'A hard landing will not lock a failed gear and risks collapse. Work the procedure methodically.'),
        ScenarioOption('Go around forever', false,
            'Holding is fine to prepare, but you must plan a landing — fuel is finite.'),
      ],
    ),
  ];

  static const List<HistoricalCase> casebook = [
    HistoricalCase(
      id: 'gimli',
      name: 'Gimli Glider',
      year: '1983',
      summary:
          'A 767 ran out of fuel at altitude due to a unit-conversion error. Both engines flamed out over Canada.',
      decision:
          'The captain, a glider pilot, dead-sticked the jet onto a former airstrip at Gimli using a forward slip to lose height.',
    ),
    HistoricalCase(
      id: 'hudson',
      name: 'Miracle on the Hudson',
      year: '2009',
      summary:
          'An A320 lost both engines to a bird strike just after departure from LaGuardia.',
      decision:
          'Unable to reach any runway, the crew ditched on the Hudson River. All 155 aboard survived.',
    ),
    HistoricalCase(
      id: 'qf32',
      name: 'Qantas Flight 32',
      year: '2010',
      summary:
          'An A380 suffered an uncontained engine failure that severed dozens of systems shortly after takeoff.',
      decision:
          'The augmented crew triaged a cascade of ECAM alerts, recomputed landing performance, and returned safely to Singapore.',
    ),
    HistoricalCase(
      id: 'sioux',
      name: 'United 232',
      year: '1989',
      summary:
          'A DC-10 lost all three hydraulic systems after a tail engine disk failure — no conventional flight controls.',
      decision:
          'The crew steered using differential thrust alone and reached Sioux City; many aboard survived a near-impossible landing.',
    ),
  ];

  static const List<PassengerCue> cabinGuide = [
    PassengerCue(
      'PUSHBACK & TAXI',
      'Clunks, whines and a tug nudging you back',
      'The tug pushes off the gate; crew run BEFORE START and arm systems. The whine is the hydraulic and electric pumps spinning up.',
    ),
    PassengerCue(
      'TAKEOFF ROLL',
      'Pressed into the seat, engines roar',
      'Thrust set, the crew call V1, then ROTATE. Below V1 they can stop; above it they are committed to fly.',
    ),
    PassengerCue(
      'INITIAL CLIMB',
      'A soft thud under the floor, nose-up',
      'Positive climb confirmed: gear comes UP. The thud is the landing gear retracting and the doors closing.',
    ),
    PassengerCue(
      'CRUISE & TURBULENCE',
      'Bumps, the odd drop in your stomach',
      'You are riding moving air, not falling. Crew adjust altitude or speed; the wings flex by design to absorb the load.',
    ),
    PassengerCue(
      'DESCENT',
      'Engines quieten, ears pop, a rumble',
      'Power back for descent, cabin re-pressurising as you come down. The rumble is the speedbrake managing your energy.',
    ),
    PassengerCue(
      'APPROACH & LANDING',
      'Grinding gear, a firm touchdown, roar',
      'Gear DOWN and three greens, flaps extending. The post-touchdown roar is reverse thrust and spoilers slowing you down.',
    ),
  ];
}
