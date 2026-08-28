import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../viewmodal/brand_view_modal.dart';
import '../widgets/brand_table.dart';
import 'add_brand_dialog.dart';


class BrandScreen extends ConsumerWidget {
  const BrandScreen({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final brandState =
    ref.watch(
      brandViewModelProvider,
    );

    return Scaffold(
      backgroundColor: AppColors.background,

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // =====================================================
            // HEADER
            // =====================================================

            Row(
              children: [

                ElevatedButton.icon(
                  onPressed: () {

                    showDialog(
                      context: context,

                      builder: (_) =>
                      const AddBrandDialog(),
                    );
                  },

                  icon: const Icon(
                    Icons.add,
                  ),

                  label: const Text(
                    "Add Brand",
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 25,
            ),

            // =====================================================
            // BRAND LIST
            // =====================================================

            Expanded(
              child: brandState.when(

                // -------------------------------------------------
                // LOADING
                // -------------------------------------------------

                loading: () =>
                const Center(
                  child:
                  CircularProgressIndicator(),
                ),

                // -------------------------------------------------
                // ERROR
                // -------------------------------------------------

                error: (
                    e,
                    _,
                    ) =>
                    Center(
                      child: Text(
                        e.toString(),
                      ),
                    ),

                // -------------------------------------------------
                // DATA
                // -------------------------------------------------

                data: (
                    brands,
                    ) {

                  if (brands.isEmpty) {

                    return const Center(
                      child: Text(
                        "No Brands Found",
                      ),
                    );
                  }

                  return BrandTable(
                    brands: brands,
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