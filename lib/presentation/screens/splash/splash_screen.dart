import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/config/colors.dart';
import '../../../core/config/constant.dart';
import '../../../core/utils/size_config.dart';
import '../../shared/widgets/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: AppConstants.kSplashDelay), () {
      if (!mounted) return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/Boy Reading Al Qur an.json',
                width: SizeConfig.screenWidth * 0.5,
                height: SizeConfig.screenHeight * 0.2,
                fit: BoxFit.contain,
              ),
              const Text(
                "Quran Player",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
              const Text(
                "Empowering Praying with Technology",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.lightDark,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const Spacer(),
          LoadingIndicator(),
          const SizedBox(height: 24),
          const Text(
            "Powered by Flutter",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
