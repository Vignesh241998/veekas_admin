import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(
      BuildContext context,
      String message,
      ) {
    _show(
      context,
      message,
      AppColors.success,
      Icons.check_circle,
    );
  }

  static void error(
      BuildContext context,
      String message,
      ) {
    _show(
      context,
      message,
      AppColors.error,
      Icons.error,
    );
  }

  static void warning(
      BuildContext context,
      String message,
      ) {
    _show(
      context,
      message,
      AppColors.warning,
      Icons.warning,
    );
  }

  static void _show(
      BuildContext context,
      String message,
      Color backgroundColor,
      IconData icon,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}