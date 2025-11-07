import 'package:provider/provider.dart';
import 'package:quran_player/presentation/view-models/quran_player_view_model.dart';

List<ChangeNotifierProvider> buildAppProviders() {
  return [
    ChangeNotifierProvider<QuranPlayerViewModel>(
      create: (_) => QuranPlayerViewModel(),
    ),
  ];
}
