import '../config/env.dart';
import 'api_service.dart';

late ApiService apiAlQuran;

Future<void> initApiInstances() async {
  apiAlQuran = ApiService(baseUrl: Env.baseUrl);
}
