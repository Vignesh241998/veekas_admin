// import 'package:flutter/material.dart';
//
// import '../../../core/theme/app_colors.dart';
// import '../model/category_model.dart';
// import '../view/edit_category_dialog.dart';
//
// class CategoryTable extends StatelessWidget {
//   final List<CategoryModel> categories;
//
//   const CategoryTable({
//     super.key,
//     required this.categories,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: SingleChildScrollView(
//         child: DataTable(
//           columnSpacing: 40,
//           dataRowMinHeight: 70,
//           dataRowMaxHeight: 70,
//           headingRowColor:
//           MaterialStateProperty.all(AppColors.primaryLight),
//           columns: const [
//             DataColumn(label: Text("Image")),
//             DataColumn(label: Text("Category")),
//             DataColumn(label: Text("Status")),
//             DataColumn(label: Text("Created")),
//             DataColumn(label: Text("Action")),
//           ],
//           rows: categories.map((category) {
//             print("category.categoryImag");
//             print(category.categoryImage);
//             return DataRow(
//               cells: [
//                 /// Image
//                 DataCell(
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(6),
//                     child: Image.network(
//                       category.categoryImage,
//                       width: 50,
//                       height: 50,
//                       fit: BoxFit.cover,
//
//                       loadingBuilder: (context, child, loadingProgress) {
//                         print("Loading Image: ${category.categoryImage}");
//                         return child;
//                       },
//
//                       errorBuilder: (context, error, stackTrace) {
//                         print("IMAGE ERROR: $error");
//                         print("IMAGE URL: ${category.categoryImage}");
//                         return const Icon(
//                           Icons.image_not_supported,
//                           color: Colors.red,
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 // DataCell(
//                 //   Container(
//                 //     width: 60,
//                 //     height: 60,
//                 //     color: Colors.amber,
//                 //     child: Image.network(
//                 //       category.categoryImage.replaceAll("http://127.0.0.1:8000", "http://localhost:8000"),
//                 //     )
//                 //   ),
//                 // ),
//                 /// Name
//                 DataCell(
//                   Text(
//                     category.categoryName,
//                   ),
//                 ),
//
//                 /// Status
//                 DataCell(
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: category.status == "ACTIVE"
//                           ? Colors.green.shade100
//                           : Colors.red.shade100,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       category.status,
//                       style: TextStyle(
//                         color: category.status == "ACTIVE"
//                             ? Colors.green
//                             : Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 /// Created Date
//                 DataCell(
//                   Text(category.createdAt),
//                 ),
//
//                 /// Actions
//                 DataCell(
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(
//                           Icons.edit,
//                           color: Colors.blue,
//                         ),
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (_) => EditCategoryDialog(
//                               category: category,
//                             ),
//                           );
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(
//                           Icons.delete,
//                           color: Colors.red,
//                         ),
//                         onPressed: () {
//                           _showDeleteDialog(
//                             context,
//                             category,
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
//
//   void _showDeleteDialog(
//       BuildContext context,
//       CategoryModel category,
//       ) {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           title: const Text("Delete Category"),
//           content: Text(
//             "Delete '${category.categoryName}' ?",
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//               ),
//               onPressed: () {
//                 /// Delete API
//                 Navigator.pop(context);
//               },
//               child: const Text("Delete"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../model/category_model.dart';
import '../view/edit_category_dialog.dart';
import '../viewmodel/category_view_model.dart';

class CategoryTable extends ConsumerWidget {
  final List<CategoryModel> categories;

  const CategoryTable({
    super.key,
    required this.categories,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    return Card(
      elevation: 2,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      child: SingleChildScrollView(
        child: DataTable(

          columnSpacing: 40,

          dataRowMinHeight: 70,
          dataRowMaxHeight: 70,

          headingRowColor:
          MaterialStateProperty.all(
            AppColors.primaryLight,
          ),

          columns: const [

            DataColumn(
              label: Text("Image"),
            ),

            DataColumn(
              label: Text("Category"),
            ),

            DataColumn(
              label: Text("Status"),
            ),

            DataColumn(
              label: Text("Created"),
            ),

            DataColumn(
              label: Text("Action"),
            ),
          ],

          rows: categories.map((category) {

            print("category.categoryImage");
            print(category.categoryImage);

            return DataRow(

              cells: [

                // =================================================
                // IMAGE
                // =================================================

                DataCell(
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(6),

                    child: Image.network(
                      category.categoryImage,

                      width: 50,
                      height: 50,

                      fit: BoxFit.cover,

                      loadingBuilder:
                          (
                          context,
                          child,
                          loadingProgress,
                          ) {

                        print(
                          "Loading Image: ${category.categoryImage}",
                        );

                        return child;
                      },

                      errorBuilder:
                          (
                          context,
                          error,
                          stackTrace,
                          ) {

                        print(
                          "IMAGE ERROR: $error",
                        );

                        print(
                          "IMAGE URL: ${category.categoryImage}",
                        );

                        return const Icon(
                          Icons.image_not_supported,
                          color: Colors.red,
                        );
                      },
                    ),
                  ),
                ),


                // =================================================
                // CATEGORY NAME
                // =================================================

                DataCell(
                  Text(
                    category.categoryName,
                  ),
                ),


                // =================================================
                // STATUS
                // =================================================

                DataCell(
                  Container(

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration:
                    BoxDecoration(

                      color:
                      category.status == "ACTIVE"
                          ? Colors.green.shade100
                          : Colors.red.shade100,

                      borderRadius:
                      BorderRadius.circular(20),
                    ),

                    child: Text(

                      category.status,

                      style: TextStyle(

                        color:
                        category.status == "ACTIVE"
                            ? Colors.green
                            : Colors.red,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),


                // =================================================
                // CREATED DATE
                // =================================================

                DataCell(
                  Text(
                    category.createdAt,
                  ),
                ),


                // =================================================
                // ACTIONS
                // =================================================

                DataCell(
                  Row(
                    children: [

                      // -------------------------------------------------
                      // EDIT
                      // -------------------------------------------------

                      IconButton(

                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),

                        onPressed: () {

                          showDialog(
                            context: context,

                            builder: (_) =>
                                EditCategoryDialog(
                                  category: category,
                                ),
                          );
                        },
                      ),


                      // -------------------------------------------------
                      // DELETE
                      // -------------------------------------------------

                      IconButton(

                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),

                        onPressed: () {

                          _showDeleteDialog(
                            context,
                            ref,
                            category,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }


  // =============================================================
  // DELETE CONFIRMATION DIALOG
  // =============================================================

  /*void _showDeleteDialog(
      BuildContext context,
      WidgetRef ref,
      CategoryModel category,
      ) {

    showDialog(
      context: context,

      builder: (dialogContext) {

        return AlertDialog(

          title: const Text(
            "Delete Category",
          ),

          content: Text(
            "Delete '${category.categoryName}' ?",
          ),

          actions: [

            // =====================================================
            // CANCEL
            // =====================================================

            TextButton(

              onPressed: () {

                Navigator.pop(
                  dialogContext,
                );
              },

              child: const Text(
                "Cancel",
              ),
            ),


            // =====================================================
            // DELETE
            // =====================================================

            ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),

              onPressed: () async {

                // -------------------------------------------------
                // Close confirmation dialog
                // -------------------------------------------------

                Navigator.pop(
                  dialogContext,
                );


                // -------------------------------------------------
                // Show loading dialog
                // -------------------------------------------------

                showDialog(
                  context: context,

                  barrierDismissible: false,

                  builder: (_) {

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );


                // -------------------------------------------------
                // Call ViewModel Delete
                // -------------------------------------------------

                try {

                  final success =
                  await ref
                      .read(
                    categoryViewModelProvider
                        .notifier,
                  )
                      .deleteCategory(
                    category.id,
                  );


                  // -------------------------------------------------
                  // Close loading dialog
                  // -------------------------------------------------

                  if (context.mounted) {

                    Navigator.pop(context);
                  }


                  // -------------------------------------------------
                  // SUCCESS
                  // -------------------------------------------------

                  if (success) {

                    if (context.mounted) {

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Category deleted successfully",
                          ),

                          backgroundColor:
                          Colors.green,
                        ),
                      );
                    }
                  }

                }

                // -------------------------------------------------
                // ERROR
                // -------------------------------------------------

                catch (e) {

                  // Close loading dialog
                  if (context.mounted) {

                    Navigator.pop(context);
                  }


                  if (context.mounted) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          "Failed to delete category: $e",
                        ),

                        backgroundColor:
                        Colors.red,
                      ),
                    );
                  }
                }
              },

              child: const Text(
                "Delete",
              ),
            ),
          ],
        );
      },
    );
  }*/
  void _showDeleteDialog(
      BuildContext context,
      WidgetRef ref,
      CategoryModel category,
      ) {
    bool isDeleting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                "Delete Category",
              ),

              content: SizedBox(
                width: 350,
                child: Text(
                  "Delete '${category.categoryName}' ?",
                ),
              ),

              actions: [

                // =====================================================
                // CANCEL
                // =====================================================

                TextButton(
                  onPressed: isDeleting
                      ? null
                      : () {
                    Navigator.pop(dialogContext);
                  },

                  child: const Text(
                    "Cancel",
                  ),
                ),

                // =====================================================
                // DELETE
                // =====================================================

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),

                  onPressed: isDeleting
                      ? null
                      : () async {

                    // Start button loader
                    setState(() {
                      isDeleting = true;
                    });

                    try {

                      // Call Delete API
                      final success =
                      await ref
                          .read(
                        categoryViewModelProvider
                            .notifier,
                      )
                          .deleteCategory(
                        category.id,
                      );

                      if (!context.mounted) {
                        return;
                      }

                      if (success) {

                        // Close delete dialog
                        Navigator.pop(dialogContext);

                        // Show success message
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Category deleted successfully",
                            ),
                            backgroundColor:
                            Colors.green,
                          ),
                        );

                      } else {

                        // Stop loader
                        setState(() {
                          isDeleting = false;
                        });

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Failed to delete category",
                            ),
                            backgroundColor:
                            Colors.red,
                          ),
                        );
                      }

                    } catch (e) {

                      if (!context.mounted) {
                        return;
                      }

                      // Stop loader
                      setState(() {
                        isDeleting = false;
                      });

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            "Failed to delete category: $e",
                          ),
                          backgroundColor:
                          Colors.red,
                        ),
                      );
                    }
                  },

                  child: isDeleting
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Delete",
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}