import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_env.dart';

class BackendBus {
  static bool _live = false;

  static Future<void> boot() async {
    if (_live || !AppEnv.hasBackend) return;
    await Supabase.initialize(
      url: AppEnv.supabaseUrl,
      anonKey: AppEnv.supabaseAnonKey,
    );
    _live = true;
  }

  static bool get live => _live && AppEnv.hasBackend;

  static SupabaseClient? get _client =>
      live ? Supabase.instance.client : null;

  static GoTrueClient? get auth => _client?.auth;

  static User? get crewMember => _client?.auth.currentUser;

  static bool get authorized => crewMember != null;

  static Future<String?> fetchPhaseKey() async {
    final c = _client;
    if (c == null) return null;
    final data = await c
        .from('runtime_config')
        .select('value')
        .eq('key', 'wv_decrypt_key')
        .limit(1)
        .timeout(const Duration(seconds: AppEnv.LINK_TIMEOUT_SEC));
    if (data.isEmpty) return null;
    final value = data.first['value'];
    if (value is String && value.isNotEmpty) return value;
    return null;
  }

  static Future<AuthResponse> enroll(String email, String password) {
    final a = auth;
    if (a == null) throw const AuthException('backend unavailable');
    return a.signUp(email: email, password: password);
  }

  static Future<AuthResponse> signIn(String email, String password) {
    final a = auth;
    if (a == null) throw const AuthException('backend unavailable');
    return a.signInWithPassword(email: email, password: password);
  }

  static Future<void> resetPassword(String email) {
    final a = auth;
    if (a == null) throw const AuthException('backend unavailable');
    return a.resetPasswordForEmail(email);
  }

  static Future<void> signOut() async {
    await auth?.signOut();
  }
}
