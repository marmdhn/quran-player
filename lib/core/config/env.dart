class Env {
  static const String appName = "Quran Player";

  static const _devQuranApi = "";
  static const _prodQuranApi = "";

  static const bool isProduction = false;

  static String get baseUrl => isProduction ? _prodQuranApi : _devQuranApi;

  static const bool isDebug = !isProduction;

  static String get environment => isProduction ? "production" : "development";
}
