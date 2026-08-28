import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veekas_ecommerce_app/features/shipment/view/shipment_view_screen.dart';
import 'package:veekas_ecommerce_app/features/brand/view/brand_screen.dart';
import 'package:veekas_ecommerce_app/features/orders/view/view_screen.dart';
import 'package:veekas_ecommerce_app/features/product/view/product_screen.dart';
import 'package:veekas_ecommerce_app/features/product_image/view/product_image_screen.dart';
import 'package:veekas_ecommerce_app/features/product_variant/view/product_variat_screen.dart';
import 'package:veekas_ecommerce_app/features/sub_category/views/sub_category_screen.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../auth/viewmodal/auth_view_model.dart';
import '../category/view/category_screen.dart';
import '../dashboard/view/dashboard_screen.dart';
import '../dashboard/widgets/admin_sidebar.dart';
import '../dashboard/widgets/admin_topbar.dart';


class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() =>
      _AdminHomeScreenState();
}

class _AdminHomeScreenState
    extends ConsumerState<AdminHomeScreen> {
  int selectedIndex = 0;

  final List<String> pageTitles = [
    "Dashboard",
    "Categories",
    "Sub Categories",
    "Brands",
    "Products",
    "Orders",
    "Customers",
    "Product Image",
    "Variants",
    "shipment",
    "Logout",
  ];

  Future<void> _logout() async {
    try {
      await ref.read(authViewModelProvider.notifier).logout();

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

  // Widget _buildBody() {
  //   switch (selectedIndex) {
  //     case 0:
  //       return const Center(
  //         child: Text(
  //           "Dashboard",
  //           style: TextStyle(
  //             fontSize: 30,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       );
  //
  //     case 1:
  //       return const CategoryScreen();
  //
  //     case 2:
  //       return const SubCategoryScreen();
  //       // return const Center(
  //       //   child: Text("Sub Categories"),
  //       // );
  //
  //     case 3:
  //       return const BrandScreen();
  //
  //     case 4:
  //       return const ProductScreen();
  //       // return const Center(
  //       //   child: Text("Products"),
  //       // );
  //
  //     case 5:
  //       return const Center(
  //         child: Text("Orders"),
  //       );
  //
  //     case 6:
  //       return const Center(
  //         child: Text("Customers"),
  //       );
  //
  //     case 7:
  //       return const ProductImageScreen();
  //       // return const Center(
  //       //   child: Text("Product Images"),
  //       // );
  //
  //     case 8:
  //       return const ProductVariantScreen();
  //       // return const Center(
  //       //   child: Text("Reports"),
  //       // );
  //
  //     case 9:
  //       return const Center(
  //         child: Text("Settings"),
  //       );
  //
  //     default:
  //       return const SizedBox();
  //   }
  // }
  Widget _buildBody() {
    switch (selectedIndex) {
      case 0:
        return const DashboardScreen();
        /*return const Center(
          child: Text(
            "Dashboard",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        );*/

      case 1:
        return const CategoryScreen();

      case 2:
        return const SubCategoryScreen();

      case 3:
        return const BrandScreen();

      case 4:
        return const ProductScreen();

      case 5:
        return const OrderScreen();

    // return const Center(
    //   child: Text("Orders"),
    // );

      case 6:
        return const Center(
          child: Text("Customers"),
        );

      case 7:
        return const ProductImageScreen();

      case 8:
        return const ProductVariantScreen();

      case 9:
        return const ShipmentScreen();


      default:
        return const SizedBox();
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
                  child: Container(
                    color: AppColors.background,
                    child: _buildBody(),
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