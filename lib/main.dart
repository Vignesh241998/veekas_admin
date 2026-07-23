import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routes/app_router.dart';
import 'core/storage/preference_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_strings.dart';
import 'features/auth/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PreferenceService.init();

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

    return MaterialApp(
      title: AppStrings.appName,

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      initialRoute: "/",

      onGenerateRoute: AppRouter.generateRoute,
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