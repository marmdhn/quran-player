import 'package:flutter/material.dart';

import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generate(RouteSettings settings) {
    final config = AppRoutes.routes[settings.name];

    if (config != null) {
      return config.buildRoute();
    }

    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text('404 Page Not Found'))),
    );
  }
}
