import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class LoginLeftPanel extends StatelessWidget {
  const LoginLeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 50,
        vertical: 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_rounded,
            size: 80,
            color: Colors.white,
          ),

          const SizedBox(height: 30),

          Text(
            "VEEKAS ADMIN",
            style: AppTextStyles.heading.copyWith(
              color: Colors.white,
              fontSize: 34,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Manage your entire e-commerce business from one place.",
            style: AppTextStyles.body.copyWith(
              color: Colors.white70,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 50),

          _buildFeature(
            Icons.dashboard_customize,
            "Dashboard Overview",
          ),

          const SizedBox(height: 20),

          _buildFeature(
            Icons.inventory_2_outlined,
            "Products & Categories",
          ),

          const SizedBox(height: 20),

          _buildFeature(
            Icons.shopping_cart_checkout,
            "Orders & Customers",
          ),

          const SizedBox(height: 20),

          _buildFeature(
            Icons.analytics_outlined,
            "Reports & Analytics",
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(
      IconData icon,
      String title,
      ) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white24,
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}