import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../Modal/sub_category_modal.dart';
import '../ViewModal/sub_category_view_model.dart';
import '../Views/edit_sub_category_dialog.dart';


class SubCategoryTable extends ConsumerWidget {
  final List<SubCategoryModel> subCategories;

  const SubCategoryTable({
    super.key,
    required this.subCategories,
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
        scrollDirection: Axis.horizontal,

        child: DataTable(
          columnSpacing: 40,

          dataRowMinHeight: 70,
          dataRowMaxHeight: 70,

          headingRowColor:
          MaterialStateProperty.all(
            AppColors.primaryLight,
          ),

          columns: const [

            // Image
            DataColumn(
              label: Text("Image"),
            ),

            // Category
            DataColumn(
              label: Text("Category"),
            ),

            // Sub Category
            DataColumn(
              label: Text("Sub Category"),
            ),

            // Status
            DataColumn(
              label: Text("Status"),
            ),

            // Created
            DataColumn(
              label: Text("Created"),
            ),

            // Action
            DataColumn(
              label: Text("Action"),
            ),
          ],

          rows: subCategories.map(
                (subCategory) {

              return DataRow(
                cells: [

                  // =================================================
                  // IMAGE
                  // =================================================

                  DataCell(
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(6),

                      child: subCategory
                          .subCategoryImage
                          .isNotEmpty
                          ? Image.network(
                        subCategory
                            .subCategoryImage,

                        width: 50,
                        height: 50,

                        fit: BoxFit.cover,

                        loadingBuilder: (
                            context,
                            child,
                            loadingProgress,
                            ) {

                          if (loadingProgress ==
                              null) {
                            return child;
                          }

                          return const SizedBox(
                            width: 50,
                            height: 50,

                            child: Center(
                              child:
                              CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },

                        errorBuilder: (
                            context,
                            error,
                            stackTrace,
                            ) {

                          print(
                            "SUB CATEGORY IMAGE ERROR: $error",
                          );

                          print(
                            "IMAGE URL: ${subCategory.subCategoryImage}",
                          );

                          return const Icon(
                            Icons
                                .image_not_supported,
                            color: Colors.red,
                          );
                        },
                      )
                          : const Icon(
                        Icons
                            .image_not_supported,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),

                  // =================================================
                  // CATEGORY
                  // =================================================

                  DataCell(
                    Text(
                      subCategory.categoryName,
                    ),
                  ),

                  // =================================================
                  // SUB CATEGORY
                  // =================================================

                  DataCell(
                    Text(
                      subCategory.subCategoryName,
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
                        subCategory.status ==
                            "ACTIVE"
                            ? Colors.green.shade100
                            : Colors.red.shade100,

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: Text(
                        subCategory.status,

                        style: TextStyle(
                          color:
                          subCategory.status ==
                              "ACTIVE"
                              ? Colors.green
                              : Colors.red,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // =================================================
                  // CREATED
                  // =================================================

                  DataCell(
                    Text(
                      subCategory.createdAt,
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
                                  EditSubCategoryDialog(
                                    subCategory:
                                    subCategory,
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
                              subCategory,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  // ==============================================================
  // DELETE CONFIRMATION DIALOG
  // ==============================================================

  void _showDeleteDialog(
      BuildContext context,
      WidgetRef ref,
      SubCategoryModel subCategory,
      ) {

    bool isDeleting = false;

    showDialog(
      context: context,

      barrierDismissible: false,

      builder: (dialogContext) {

        return StatefulBuilder(
          builder: (
              context,
              setState,
              ) {

            return AlertDialog(

              // ==================================================
              // DIALOG SIZE
              // ==================================================

              contentPadding:
              const EdgeInsets.fromLTRB(
                28,
                24,
                28,
                10,
              ),

              titlePadding:
              const EdgeInsets.fromLTRB(
                28,
                24,
                28,
                10,
              ),

              actionsPadding:
              const EdgeInsets.fromLTRB(
                28,
                10,
                28,
                24,
              ),

              // ==================================================
              // TITLE
              // ==================================================

              title: const Text(
                "Delete Sub Category",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // ==================================================
              // CONTENT
              // ==================================================

              content: SizedBox(
                width: 420,

                child: Text(
                  "Are you sure you want to delete "
                      "'${subCategory.subCategoryName}'?",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),

              // ==================================================
              // ACTIONS
              // ==================================================

              actions: [

                // ------------------------------------------------
                // CANCEL
                // ------------------------------------------------

                TextButton(

                  onPressed: isDeleting
                      ? null
                      : () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },

                  child: const Text(
                    "Cancel",
                  ),
                ),

                // ------------------------------------------------
                // DELETE
                // ------------------------------------------------

                ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.red,

                    foregroundColor:
                    Colors.white,

                    minimumSize:
                    const Size(
                      100,
                      42,
                    ),
                  ),

                  onPressed: isDeleting
                      ? null
                      : () async {

                    // Show loader
                    setState(() {
                      isDeleting = true;
                    });

                    try {

                      final success =
                      await ref
                          .read(
                        subCategoryViewModelProvider
                            .notifier,
                      )
                          .deleteSubCategory(
                        subCategory.id,
                      );

                      if (!context.mounted) {
                        return;
                      }

                      if (success) {

                        // Close dialog
                        Navigator.pop(
                          dialogContext,
                        );

                        // Success message
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Sub Category deleted successfully",
                            ),
                            backgroundColor:
                            Colors.green,
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

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Failed to delete sub category: $e",
                          ),
                          backgroundColor:
                          Colors.red,
                        ),
                      );
                    }
                  },

                  // =================================================
                  // BUTTON LOADER
                  // =================================================

                  child: isDeleting

                      ? const SizedBox(
                    width: 20,
                    height: 20,

                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,

                      color:
                      Colors.white,
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