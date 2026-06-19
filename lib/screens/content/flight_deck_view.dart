import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/panel_palette.dart';

class FlightDeckView extends StatefulWidget {
  final String endpoint;
  const FlightDeckView({super.key, required this.endpoint});

  @override
  State<FlightDeckView> createState() => _FlightDeckViewState();
}

class _FlightDeckViewState extends State<FlightDeckView> {
  static const _LAST_URL_KEY = 'fd.lastUrl';

  InAppWebViewController? _controller;
  bool _loading = true;
  String? _entryUrl;

  @override
  void initState() {
    super.initState();
    _resolveEntry();
  }

  Future<void> _resolveEntry() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_LAST_URL_KEY);
    setState(() {
      _entryUrl = (saved != null && saved.startsWith('http'))
          ? saved
          : widget.endpoint;
    });
  }

  Future<void> _remember(WebUri? uri) async {
    if (uri == null) return;
    final s = uri.toString();
    if (!s.startsWith('http')) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_LAST_URL_KEY, s);
  }

  Future<void> _handleBack() async {
    final controller = _controller;
    if (controller != null && await controller.canGoBack()) {
      controller.goBack();
    } else {
      await SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_entryUrl == null) {
      return const Scaffold(
        backgroundColor: PanelPalette.voidBlack,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        backgroundColor: PanelPalette.voidBlack,
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(_entryUrl!)),
                initialSettings: InAppWebViewSettings(
                  transparentBackground: true,
                  mediaPlaybackRequiresUserGesture: false,
                  javaScriptEnabled: true,
                  useHybridComposition: true,
                  allowsInlineMediaPlayback: true,
                  supportZoom: false,
                ),
                onWebViewCreated: (c) => _controller = c,
                onLoadStart: (c, uri) {
                  if (mounted) setState(() => _loading = true);
                },
                onLoadStop: (c, uri) async {
                  await _remember(uri);
                  if (mounted) setState(() => _loading = false);
                },
                onReceivedError: (c, req, err) {
                  if (mounted) setState(() => _loading = false);
                },
                onUpdateVisitedHistory: (c, uri, isReload) {
                  _remember(uri);
                },
              ),
              if (_loading)
                const Center(
                  child: CircularProgressIndicator(
                    color: PanelPalette.amber,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
