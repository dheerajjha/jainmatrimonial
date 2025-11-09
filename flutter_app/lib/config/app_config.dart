class AppConfig {
  // Backend API URL - Can be overridden at build time with:
  // flutter run --dart-define=API_URL=http://your-server:5000/api
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:5000/api',
  );

  // App environment (development, staging, production)
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  // Enable debug logging
  static const bool enableDebugLogs = String.fromEnvironment(
    'DEBUG_LOGS',
    defaultValue: 'true',
  ) == 'true';

  // Helper methods
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
  static bool get isStaging => environment == 'staging';
}
