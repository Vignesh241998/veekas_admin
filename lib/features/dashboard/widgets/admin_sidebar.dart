import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onMenuSelected;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: AppColors.primary,
      child: Column(
        children: [

          // Logo
          Container(
            height: 90,
            alignment: Alignment.center,
            child: const Text(
              "VEEKAS ADMIN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const Divider(
            color: Colors.white24,
            height: 1,
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [

                _menuItem(
                  index: 0,
                  icon: Icons.dashboard_rounded,
                  title: "Dashboard",
                ),

                _menuItem(
                  index: 1,
                  icon: Icons.category_outlined,
                  title: "Categories",
                ),

                _menuItem(
                  index: 2,
                  icon: Icons.account_tree_outlined,
                  title: "Sub Categories",
                ),

                _menuItem(
                  index: 3,
                  icon: Icons.workspace_premium_outlined,
                  title: "Brands",
                ),

                _menuItem(
                  index: 4,
                  icon: Icons.inventory_2_outlined,
                  title: "Products",
                ),

                _menuItem(
                  index: 5,
                  icon: Icons.shopping_cart_outlined,
                  title: "Orders",
                ),

                _menuItem(
                  index: 6,
                  icon: Icons.people_outline,
                  title: "Customers",
                ),

                _menuItem(
                  index: 7,
                  icon: Icons.discount_outlined,
                  title: "Product Images",
                ),

                _menuItem(
                  index: 8,
                  icon: Icons.bar_chart_outlined,
                  title: "Product Variants",
                ),

                _menuItem(
                  index: 9,
                  icon: Icons.settings_outlined,
                  title: "Settings",
                ),
              ],
            ),
          ),

          const Divider(
            color: Colors.white24,
            height: 1,
          ),

          _menuItem(
            index: 10,
            icon: Icons.logout,
            title: "Logout",
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _menuItem({
    required int index,
    required IconData icon,
    required String title,
  }) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onMenuSelected(index),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withOpacity(.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [

              Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),

              const SizedBox(width: 15),

              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}