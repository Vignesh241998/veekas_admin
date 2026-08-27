import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../viewmodel/category_view_model.dart';
import '../widgets/category_table.dart';
import 'add_category_dialog.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(categoryViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Header
            Row(
              children: [

                // const Text(
                //   "Categories",
                //   style: TextStyle(
                //     fontSize: 28,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                //
                // const Spacer(),
                //
                // SizedBox(
                //   width: 280,
                //   child: TextField(
                //     decoration: InputDecoration(
                //       hintText: "Search Category",
                //       prefixIcon: const Icon(Icons.search),
                //       filled: true,
                //       fillColor: Colors.white,
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //   ),
                // ),
                //
                // const SizedBox(width: 20),

                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AddCategoryDialog(),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Category"),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Expanded(
              child: categoryState.when(

                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),

                error: (e, _) => Center(
                  child: Text(e.toString()),
                ),

                data: (categories) {

                  if (categories.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Categories Found",
                      ),
                    );
                  }

                  return CategoryTable(
                    categories: categories,
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