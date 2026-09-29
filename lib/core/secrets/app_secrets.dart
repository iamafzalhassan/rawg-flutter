abstract final class AppSecrets {
  static const String oneSignalAppId = String.fromEnvironment('ONESIGNAL_APP_ID');
  static const String rawgApiKey = String.fromEnvironment('RAWG_API_KEY');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
}
