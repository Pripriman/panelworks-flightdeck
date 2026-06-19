import 'package:flutter/material.dart';

import '../../config/app_env.dart';
import '../../runtime/backend_bus.dart';
import '../../runtime/alert_relay.dart';
import '../../runtime/pulse_beacon.dart';
import '../../theme/panel_palette.dart';
import '../../theme/panel_type.dart';
import '../../widgets/hud_frame.dart';
import '../../widgets/panel_card.dart';
import '../../widgets/throttle_button.dart';

class CrewAccessScreen extends StatefulWidget {
  final VoidCallback onDone;
  const CrewAccessScreen({super.key, required this.onDone});

  @override
  State<CrewAccessScreen> createState() => _CrewAccessScreenState();
}

class _CrewAccessScreenState extends State<CrewAccessScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _enrollMode = false;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _submit() async {
    if (!AppEnv.hasBackend) {
      _toast('Crew accounts are offline right now.');
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      if (_enrollMode) {
        final res = await BackendBus.enroll(_email.text.trim(), _pass.text);
        PulseBeacon.registration();
        final uid = res.user?.id;
        if (uid != null) await AlertRelay.bindCrew(uid);
        _toast('Crew profile created. Confirm via the email we sent.');
      } else {
        final res = await BackendBus.signIn(_email.text.trim(), _pass.text);
        PulseBeacon.login();
        final uid = res.user?.id;
        if (uid != null) await AlertRelay.bindCrew(uid);
      }
      if (!mounted) return;
      widget.onDone();
    } catch (e) {
      _toast(_humanError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _humanError(Object e) {
    final s = e.toString();
    if (s.contains('Invalid login')) return 'Wrong email or password.';
    if (s.contains('already registered')) {
      return 'This email is already on the crew roster.';
    }
    return 'Something went wrong. Try again.';
  }

  Future<void> _forgot() async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      _toast('Enter your email first, then request a reset.');
      return;
    }
    try {
      await BackendBus.resetPassword(email);
      _toast('Password reset link sent.');
    } catch (_) {
      _toast('Could not send the reset link.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: PanelPalette.cockpitGlow),
        child: Stack(
          children: [
            const HudGrid(),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: PanelLink(
                        label: 'Skip',
                        onPressed: _busy ? null : widget.onDone,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Icon(Icons.badge_outlined,
                        size: 42, color: PanelPalette.amber),
                    const SizedBox(height: 14),
                    Text(_enrollMode ? 'NEW CREW PROFILE' : 'CREW SIGN-IN',
                        style: PanelType.title()),
                    const SizedBox(height: 8),
                    Text(
                      'A crew profile syncs your drill log across devices and arms flight alerts. It is optional — the deck runs fully offline.',
                      style: PanelType.body(),
                    ),
                    const SizedBox(height: 22),
                    PanelCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              style: PanelType.bodyStrong(),
                              autofillHints: const [AutofillHints.email],
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.mail_outline_rounded),
                              ),
                              validator: (v) {
                                final t = (v ?? '').trim();
                                if (t.isEmpty || !t.contains('@')) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _pass,
                              obscureText: true,
                              style: PanelType.bodyStrong(),
                              autofillHints: const [AutofillHints.password],
                              decoration: const InputDecoration(
                                hintText: 'Password',
                                prefixIcon: Icon(Icons.lock_outline_rounded),
                              ),
                              validator: (v) {
                                if ((v ?? '').length < 6) {
                                  return 'At least 6 characters';
                                }
                                return null;
                              },
                            ),
                            if (!_enrollMode)
                              Align(
                                alignment: Alignment.centerRight,
                                child: PanelLink(
                                  label: 'Forgot?',
                                  onPressed: _busy ? null : _forgot,
                                ),
                              ),
                            const SizedBox(height: 8),
                            ThrottleButton(
                              label: _enrollMode ? 'Create profile' : 'Sign in',
                              busy: _busy,
                              onPressed: _busy ? null : _submit,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: _busy
                          ? null
                          : () => setState(() => _enrollMode = !_enrollMode),
                      child: Text(
                        _enrollMode
                            ? 'I already have a profile'
                            : 'New crew? Create a profile',
                        style: PanelType.label(color: PanelPalette.amber),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
