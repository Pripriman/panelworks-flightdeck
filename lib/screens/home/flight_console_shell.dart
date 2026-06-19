import 'package:flutter/material.dart';

import '../../runtime/backend_bus.dart';
import '../../runtime/alert_relay.dart';
import '../../theme/panel_palette.dart';
import '../../theme/panel_type.dart';
import '../access/crew_access_screen.dart';
import 'flight_mode_view.dart';
import 'failure_drill_view.dart';
import 'casebook_view.dart';
import 'cabin_guide_view.dart';
import 'checklist_bay_view.dart';

class FlightConsoleShell extends StatefulWidget {
  const FlightConsoleShell({super.key});

  @override
  State<FlightConsoleShell> createState() => _FlightConsoleShellState();
}

class _FlightConsoleShellState extends State<FlightConsoleShell> {
  int _tab = 0;

  static const _titles = [
    'FLIGHT MODE',
    'FAILURE DRILL',
    'CASEBOOK',
    'CABIN GUIDE',
    'CHECKLIST BAY',
  ];

  void _openProfile() {
    final authorized = BackendBus.authorized;
    showModalBottomSheet(
      context: context,
      backgroundColor: PanelPalette.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CREW PROFILE', style: PanelType.heading()),
                const SizedBox(height: 6),
                Text(
                  authorized
                      ? (BackendBus.crewMember?.email ?? 'Signed in')
                      : 'Flying as an unlisted crew member.',
                  style: PanelType.body(),
                ),
                const SizedBox(height: 14),
                if (authorized)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout_rounded,
                        color: PanelPalette.alert),
                    title: Text('Sign out',
                        style:
                            PanelType.bodyStrong(color: PanelPalette.alert)),
                    onTap: () async {
                      await AlertRelay.releaseCrew();
                      await BackendBus.signOut();
                      if (sheetCtx.mounted) Navigator.pop(sheetCtx);
                      if (mounted) setState(() {});
                    },
                  )
                else
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.login_rounded,
                        color: PanelPalette.amber),
                    title: Text('Sign in or create profile',
                        style:
                            PanelType.bodyStrong(color: PanelPalette.amber)),
                    onTap: () {
                      Navigator.pop(sheetCtx);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CrewAccessScreen(
                            onDone: () {
                              Navigator.of(context).maybePop();
                              if (mounted) setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;
    switch (_tab) {
      case 0:
        body = const FlightModeView();
        break;
      case 1:
        body = const FailureDrillView();
        break;
      case 2:
        body = const CasebookView();
        break;
      case 3:
        body = const CabinGuideView();
        break;
      case 4:
        body = const ChecklistBayView();
        break;
      default:
        body = const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: PanelPalette.voidBlack,
      appBar: AppBar(
        titleSpacing: 20,
        title: Text(_titles[_tab],
            style: PanelType.title(color: PanelPalette.readout)),
        actions: [
          IconButton(
            icon: const Icon(Icons.badge_outlined),
            color: PanelPalette.readoutSoft,
            onPressed: _openProfile,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: body,
      bottomNavigationBar: _ConsoleBar(
        index: _tab,
        onChanged: (i) => setState(() => _tab = i),
      ),
    );
  }
}

class _ConsoleBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _ConsoleBar({required this.index, required this.onChanged});

  static const _items = [
    (Icons.flight_rounded, 'FLT'),
    (Icons.warning_amber_rounded, 'EMER'),
    (Icons.menu_book_rounded, 'CASE'),
    (Icons.airline_seat_recline_normal_rounded, 'CABIN'),
    (Icons.checklist_rounded, 'CHK'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: PanelPalette.panel,
        border: Border(top: BorderSide(color: PanelPalette.hairline)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_items.length, (i) {
              final selected = i == index;
              final item = _items[i];
              return Expanded(
                child: InkResponse(
                  onTap: () => onChanged(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.$1,
                        size: 22,
                        color: selected
                            ? PanelPalette.amber
                            : PanelPalette.readoutFaint,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.$2,
                        style: PanelType.caption(
                          color: selected
                              ? PanelPalette.amber
                              : PanelPalette.readoutFaint,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
