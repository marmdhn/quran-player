import 'package:quran_player/presentation/screens/quran-player/quran_player_screen.dart';
import 'package:quran_player/presentation/screens/reciter/reciter_screen.dart';
import 'package:quran_player/presentation/screens/surah-list/surah_list_screen.dart';

import '../presentation/screens/splash/splash_screen.dart';
import 'route_config.dart';

class AppRoutes {
  static const splash = '/';

  static const reciterList = '/reciterList';
  static const surahList = '/surahList';
  static const quranPlayer = '/quranPlayer';

  static final Map<String, RouteConfig> routes = {
    splash: RouteConfig(
      page: const SplashScreen(),
      transition: AppTransition.fade,
    ),
    reciterList: RouteConfig(
      page: ReciterScreen(),
      transition: AppTransition.fade,
    ),
    surahList: RouteConfig(
      page: SurahListScreen(),
      transition: AppTransition.slideRight,
    ),
    quranPlayer: RouteConfig(
      page: QuranPlayerScreen(),
      transition: AppTransition.slideRight,
    ),
  };
}
