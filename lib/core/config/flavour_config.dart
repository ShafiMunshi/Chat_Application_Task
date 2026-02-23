class FlavorConfig {
  final String environment;
  final String appName;
  final String baseUrl;
  final bool enableLogs;

  const FlavorConfig({
    required this.environment,
    required this.appName,
    required this.baseUrl,
    required this.enableLogs,
  });

  /// Factory from dart-define
  factory FlavorConfig.fromEnvironment() {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    const appName = String.fromEnvironment('APP_NAME', defaultValue: 'MyApp');
    const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    const enableLogs = bool.fromEnvironment('ENABLE_LOG', defaultValue: true);

    return const FlavorConfig(
      environment: env,
      appName: appName,
      baseUrl: baseUrl,
      enableLogs: enableLogs,
    );
  }
}
