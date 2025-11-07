import 'package:get_it/get_it.dart';

import '../../data/repository/quran_repository.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<QuranRepository>(() => QuranRepository());
}
