import 'package:provider/provider.dart';
import 'package:quran_player/presentation/view-models/audio_player_view_model.dart';
import 'package:quran_player/presentation/view-models/reciter_view_model.dart';
import 'package:quran_player/presentation/view-models/surah_view_model.dart';

List<ChangeNotifierProvider> buildAppProviders() {
  return [
    ChangeNotifierProvider<ReciterViewModel>(create: (_) => ReciterViewModel()),
    ChangeNotifierProvider<SurahViewModel>(create: (_) => SurahViewModel()),
    ChangeNotifierProvider<AudioPlayerViewModel>(
      create: (_) => AudioPlayerViewModel(),
    ),
  ];
}
