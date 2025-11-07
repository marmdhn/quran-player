class Env {
  static const String appName = "Quran Player";

  static const _devQuranApi = "https://api.alquran.cloud/v1/";
  static const _prodQuranApi = "https://api.alquran.cloud/v1/";

  static const bool isProduction = false;

  static String get baseUrl => isProduction ? _prodQuranApi : _devQuranApi;

  static const bool isDebug = !isProduction;

  static String get environment => isProduction ? "production" : "development";
}
