import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modal/product_image_modal.dart';
import '../view/product_image_delete_dialog.dart';
import '../view/product_image_edit_dialog.dart';
import '../viewmodal/product_view_modal.dart';


class ProductImageTable extends ConsumerWidget {
  final List<ProductImageModel> productImages;
  final int productId;

  const ProductImageTable({
    super.key,
    required this.productImages,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 56,
              dataRowMinHeight: 85,
              dataRowMaxHeight: 100,

              // Give the table enough space to scroll horizontally
              columnSpacing: 60,

              // columns: const [
              //   DataColumn(
              //     label: Text(
              //       'ID',
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              //
              //   DataColumn(
              //     label: Text(
              //       'Image',
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              //
              //   DataColumn(
              //     label: Text(
              //       'Status',
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              //
              //   DataColumn(
              //     label: Text(
              //       'Actions',
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ],
              columns: const [
                DataColumn(
                  label: SizedBox(
                    width: 80,
                    child: Text(
                      'ID',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                DataColumn(
                  label: SizedBox(
                    width: 250,
                    child: Text(
                      'Image',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                DataColumn(
                  label: SizedBox(
                    width: 150,
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                DataColumn(
                  label: SizedBox(
                    width: 180,
                    child: Text(
                      'Actions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              rows: productImages.map(
                    (productImage) {
                  return DataRow(
                    cells: [
                      // ==========================================
                      // ID
                      // ==========================================

                      DataCell(
                        Text(
                          productImage.id.toString(),
                        ),
                      ),

                      // ==========================================
                      // IMAGE
                      // ==========================================

                      DataCell(
                        _ProductImagePreview(
                          imageUrl: productImage.image,
                        ),
                      ),

                      // ==========================================
                      // STATUS
                      // ==========================================

                      DataCell(
                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                            productImage.status ==
                                'ACTIVE'
                                ? Colors.green.withValues(
                              alpha: 0.1,
                            )
                                : Colors.red.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: Text(
                            productImage.status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w600,
                              color:
                              productImage.status ==
                                  'ACTIVE'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),

                      // ==========================================
                      // ACTIONS
                      // ==========================================

                      DataCell(
                        Row(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Edit',
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 20,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible:
                                  false,
                                  builder: (context) {
                                    return EditProductImageDialog(
                                      productImage:
                                      productImage,
                                    );
                                  },
                                );
                              },
                            ),

                            // IconButton(
                            //   tooltip: 'Delete',
                            //   icon: const Icon(
                            //     Icons.delete_outline,
                            //     size: 20,
                            //   ),
                            //   onPressed: () {
                            //     showDialog(
                            //       context: context,
                            //       barrierDismissible:
                            //       false,
                            //       builder: (context) {
                            //         return DeleteProductImageDialog(
                            //           productImage:
                            //           productImage,
                            //         );
                            //       },
                            //     );
                            //   },
                            // ),
                            IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 20,
                              ),
                              onPressed: () async {
                                final deleted = await showDialog<bool>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return DeleteProductImageDialog(
                                      productImage: productImage,
                                    );
                                  },
                                );

                                // ========================================================
                                // REFRESH CURRENTLY SELECTED PRODUCT
                                // ========================================================

                                if (deleted == true) {
                                  await ref
                                      .read(
                                    productImageViewModelProvider.notifier,
                                  )
                                      .getImagesByProduct(productId);
                                }
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
        ),
      ),
    );
  }
}

// ============================================================
// IMAGE PREVIEW
// ============================================================

class _ProductImagePreview extends StatelessWidget {
  final String? imageUrl;

  const _ProductImagePreview({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius:
          BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
        ),
      );
    }

    return ClipRRect(
      borderRadius:
      BorderRadius.circular(8),
      child: Image.network(
        imageUrl!,
        width: 65,
        height: 65,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return Container(
            width: 65,
            height: 65,
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.broken_image_outlined,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}