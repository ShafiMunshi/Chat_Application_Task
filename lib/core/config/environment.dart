enum Environment {
  dev,
  staging,
  prod,
}

class Env {
  static const String _env =
      String.fromEnvironment('ENV', defaultValue: 'dev');

  static Environment get environment {
    switch (_env) {
      case 'staging':
        return Environment.staging;
      case 'prod':
        return Environment.prod;
      default:
        return Environment.dev;
    }
  }

  static bool get isDev => environment == Environment.dev;
  static bool get isProd => environment == Environment.prod;
}