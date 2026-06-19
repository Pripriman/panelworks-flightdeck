class AppEnv {
  static const String supabaseUrl = String.fromEnvironment('SB_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SB_ANON');
  static const String oneSignalAppId = String.fromEnvironment('OS_APP_ID');
  static const String affiseAppId = String.fromEnvironment('AFF_APP_ID');
  static const String affiseSecret = String.fromEnvironment('AFF_SECRET');

  static const int LINK_TIMEOUT_SEC = 8;
  static const int PROBE_TIMEOUT_SEC = 6;
  static const Duration ENDPOINT_TTL = Duration(hours: 24);

  static bool get hasBackend =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  static bool get hasAlerts => oneSignalAppId.isNotEmpty;
  static bool get hasBeacon =>
      affiseAppId.isNotEmpty && affiseSecret.isNotEmpty;
}
