import 'package:flutter/material.dart';
import 'package:veekas_ecommerce_app/features/Admin_Home_Screen/admin_home_screen.dart';

import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/register_screen.dart';
import '../../features/auth/view/splash_screen.dart';
import '../../features/customer/home/view/customer_home_screen.dart';
import '../../features/dashboard/view/dashboard_screen.dart';

class AppRouter {
  AppRouter._();


  static Route<dynamic> generateRoute(
      RouteSettings settings,
      ) {


    switch (settings.name) {


      case "/":

        return MaterialPageRoute(
          builder: (_) =>
          const SplashScreen(),
        );



      case "/login":

        return MaterialPageRoute(
          builder: (_) =>
          const LoginScreen(),
        );



      case "/register":

        return MaterialPageRoute(
          builder: (_) =>
          const RegisterScreen(),
        );



      case "/dashboard":
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );

      case '/customer-home':
        return MaterialPageRoute(
          builder: (_) => const CustomerHomeScreen(),
        );
      case "/admin-home-page":
        return MaterialPageRoute(
          builder: (_) => const AdminHomeScreen(),
        );
      default:

        return MaterialPageRoute(

          builder: (_) =>
          const Scaffold(

            body: Center(

              child: Text(
                "Page Not Found",
              ),

            ),

          ),

        );

    }

  }

}





// Temporary Dashboard
// Replace later with real Dashboard Screen

class DashboardPlaceholder extends StatelessWidget {

  const DashboardPlaceholder({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
          "Veekas Admin Dashboard",
        ),

      ),


      body:
      const Center(

        child:
        Text(
          "Dashboard Coming Soon",
        ),

      ),

    );

  }

}