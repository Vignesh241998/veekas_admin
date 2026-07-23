import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veekas_ecommerce_app/routes/app_router.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/app_strings.dart';
import 'features/auth/view/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );

    // return MaterialApp(
    //
    //   title: AppStrings.appName,
    //
    //   debugShowCheckedModeBanner: false,
    //
    //   theme: AppTheme.lightTheme,
    //
    //   home: const SplashScreen(),
    // );
  }
}