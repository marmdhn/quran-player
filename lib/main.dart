import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_player/core/config/colors.dart';
import 'package:quran_player/presentation/screens/splash/splash_screen.dart';
import 'package:quran_player/provider/provider.dart';
import 'package:quran_player/routes/app_routes.dart';
import 'package:quran_player/routes/route_generator.dart';

import 'core/config/env.dart';
import 'core/di/locator.dart';
import 'core/services/api_instance.dart';
import 'core/utils/size_config.dart';

void main() {
  initApiInstances();

  setupLocator();

  runApp(MultiProvider(providers: buildAppProviders(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: Env.isDebug,
      title: Env.appName,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generate,

      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        brightness: Brightness.dark,
      ),
      home: const SplashScreen(),
    );
  }
}
