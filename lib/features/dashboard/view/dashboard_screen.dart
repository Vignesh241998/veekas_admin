import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../auth/viewmodal/auth_view_model.dart';
import '../widgets/admin_sidebar.dart';
import '../widgets/admin_topbar.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends ConsumerState<DashboardScreen> {
  int selectedIndex = 0;

  final List<String> pageTitles = [
    "Dashboard",
    "Categories",
    "Sub Categories",
    "Brands",
    "Products",
    "Orders",
    "Customers",
    "Coupons",
    "Reports",
    "Settings",
    "Logout",
  ];

  Future<void> _logout() async {
    try {
      await ref
          .read(authViewModelProvider.notifier)
          .logout();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/login",
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          AdminSidebar(
            selectedIndex: selectedIndex,
            onMenuSelected: (index) async {
              // if (index == 10) {
              //   await _logout();
              //   return;
              // }
              if (index == 10) {
                showDialog(
                  context: context,
                  builder: (_) => ConfirmationDialog(
                    title: "Logout",
                    message: "Are you sure you want to logout?",
                    onConfirm: () async {
                      await _logout();
                    },
                  ),
                );
                return;
              }

              setState(() {
                selectedIndex = index;
              });
            },
          ),

          Expanded(
            child: Column(
              children: [
                AdminTopBar(
                  title: pageTitles[selectedIndex],
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black12,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          pageTitles[selectedIndex],
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}