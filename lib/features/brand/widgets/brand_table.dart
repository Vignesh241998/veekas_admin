import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../modal/brand_modal.dart';
import '../viewmodal/brand_view_modal.dart';
import '../view/edit_brand_dialog.dart';

class BrandTable extends StatelessWidget {
  final List<BrandModel> brands;

  const BrandTable({
    super.key,
    required this.brands,
  });

  @override
  Widget build(BuildContext context) {
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
            DataColumn(
              label: Text("Image"),
            ),
            DataColumn(
              label: Text("Brand"),
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
          rows: brands.map((brand) {
            return DataRow(
              cells: [

                // =================================================
                // IMAGE
                // =================================================

                DataCell(
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(6),
                    child:
                    brand.brandImage.isNotEmpty
                        ? Image.network(
                      brand.brandImage,
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
                // BRAND NAME
                // =================================================

                DataCell(
                  Text(
                    brand.brandName,
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
                      brand.status ==
                          "ACTIVE"
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Text(
                      brand.status,
                      style: TextStyle(
                        color:
                        brand.status ==
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
                // CREATED DATE
                // =================================================

                DataCell(
                  Text(
                    brand.createdAt,
                  ),
                ),

                // =================================================
                // ACTIONS
                // =================================================

                DataCell(
                  Row(
                    children: [

                      // -------------------------------------------
                      // EDIT
                      // -------------------------------------------

                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) =>
                                EditBrandDialog(
                                  brand: brand,
                                ),
                          );
                        },
                      ),

                      // -------------------------------------------
                      // DELETE
                      // -------------------------------------------

                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _showDeleteDialog(
                            context,
                            brand,
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

  // ============================================================
  // DELETE CONFIRMATION DIALOG
  // ============================================================

  void _showDeleteDialog(
      BuildContext context,
      BrandModel brand,
      ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return _DeleteBrandDialog(
          brand: brand,
        );
      },
    );
  }
}


// ================================================================
// DELETE BRAND DIALOG
// ================================================================

class _DeleteBrandDialog extends ConsumerStatefulWidget {
  final BrandModel brand;

  const _DeleteBrandDialog({
    required this.brand,
  });

  @override
  ConsumerState<_DeleteBrandDialog> createState() =>
      _DeleteBrandDialogState();
}


// ================================================================
// DELETE BRAND DIALOG STATE
// ================================================================

class _DeleteBrandDialogState
    extends ConsumerState<_DeleteBrandDialog> {

  bool _isLoading = false;

  // ============================================================
  // DELETE BRAND
  // ============================================================

  Future<void> _deleteBrand() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success =
      await ref
          .read(
        brandViewModelProvider.notifier,
      )
          .deleteBrand(
        widget.brand.id,
      );

      if (!mounted) return;

      if (success) {

        Navigator.pop(context);

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Brand deleted successfully",
            ),
            backgroundColor:
            Colors.green,
          ),
        );
      }
    } catch (e) {

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // ========================================================
      // LARGER DIALOG
      // ========================================================

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
        0,
      ),

      actionsPadding:
      const EdgeInsets.fromLTRB(
        28,
        10,
        28,
        24,
      ),

      title: const Text(
        "Delete Brand",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SizedBox(
        width: 430,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            const SizedBox(
              height: 8,
            ),

            // ==================================================
            // WARNING ICON + MESSAGE
            // ==================================================

            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 25,
                  ),
                ),

                const SizedBox(
                  width: 15,
                ),

                Expanded(
                  child: Text(
                    "Are you sure you want to delete "
                        "'${widget.brand.brandName}'?",
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // ==================================================
            // WARNING TEXT
            // ==================================================

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius:
                BorderRadius.circular(8),
              ),
              child: const Text(
                "This brand will be removed from "
                    "the active brand list.",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // ACTION BUTTONS
      // ========================================================

      actions: [

        // ======================================================
        // CANCEL
        // ======================================================

        TextButton(
          onPressed: _isLoading
              ? null
              : () {
            Navigator.pop(
              context,
            );
          },
          child: const Text(
            "Cancel",
          ),
        ),

        // ======================================================
        // DELETE
        // ======================================================

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize:
            const Size(110, 40),
          ),

          onPressed:
          _isLoading
              ? null
              : _deleteBrand,

          child: SizedBox(
            width: 80,
            height: 20,
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                width: 18,
                height: 18,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Text(
                "Delete",
              ),
            ),
          ),
        ),
      ],
    );
  }
}