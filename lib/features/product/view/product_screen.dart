import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../viewmodal/add_product_dialog.dart';
import '../viewmodal/product_view_modal.dart';
import '../widgets/product_table.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(
      productViewModelProvider,
    );

    return Scaffold(
      backgroundColor: AppColors.background,

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // ====================================================
            // HEADER
            // ====================================================

            Row(
              children: [

                ElevatedButton.icon(
                  onPressed: () {

                    showDialog(
                      context: context,
                      builder: (_) =>
                      const AddProductDialog(),
                    );

                  },

                  icon: const Icon(
                    Icons.add,
                  ),

                  label: const Text(
                    "Add Product",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ====================================================
            // PRODUCT LIST
            // ====================================================

            Expanded(
              child: productState.when(

                // ------------------------------------------------
                // LOADING
                // ------------------------------------------------

                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),

                // ------------------------------------------------
                // ERROR
                // ------------------------------------------------

                error: (error, stackTrace) =>
                    Center(
                      child: Text(
                        error.toString(),
                      ),
                    ),

                // ------------------------------------------------
                // DATA
                // ------------------------------------------------

                data: (products) {

                  if (products.isEmpty) {

                    return const Center(
                      child: Text(
                        "No Products Found",
                      ),
                    );
                  }

                  return ProductTable(
                    products: products,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}