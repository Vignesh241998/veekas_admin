import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../viewmodal/sub_category_view_model.dart';
import '../widgets/sub_category_table.dart';
import 'add_sub_category_dialog.dart';

class SubCategoryScreen extends ConsumerWidget {
  const SubCategoryScreen({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final subCategoryState =
    ref.watch(
      subCategoryViewModelProvider,
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

                // -------------------------------------------------
                // ADD SUB CATEGORY BUTTON
                // -------------------------------------------------

                ElevatedButton.icon(
                  onPressed: () {

                    showDialog(
                      context: context,

                      builder: (_) =>
                      const AddSubCategoryDialog(),
                    );
                  },

                  icon: const Icon(
                    Icons.add,
                  ),

                  label: const Text(
                    "Add Sub Category",
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 25,
            ),

            // =====================================================
            // SUB CATEGORY LIST
            // =====================================================

            Expanded(
              child: subCategoryState.when(

                // -------------------------------------------------
                // LOADING
                // -------------------------------------------------

                loading: () {

                  return const Center(
                    child:
                    CircularProgressIndicator(),
                  );
                },

                // -------------------------------------------------
                // ERROR
                // -------------------------------------------------

                error: (
                    error,
                    stackTrace,
                    ) {

                  return Center(
                    child: Text(
                      error.toString(),
                    ),
                  );
                },

                // -------------------------------------------------
                // DATA
                // -------------------------------------------------

                data: (
                    subCategories,
                    ) {

                  // -----------------------------------------------
                  // EMPTY
                  // -----------------------------------------------

                  if (subCategories.isEmpty) {

                    return const Center(
                      child: Text(
                        "No Sub Categories Found",
                      ),
                    );
                  }

                  // -----------------------------------------------
                  // TABLE
                  // -----------------------------------------------

                  return SubCategoryTable(
                    subCategories: subCategories,
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