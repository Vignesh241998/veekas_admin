import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.black,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 13,
    color: AppColors.grey,
  );
}