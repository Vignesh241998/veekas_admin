import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modal/product_variant_modal.dart';
import '../modal/variant_attribute_modal.dart';
import '../view/product_variant_delete_dialog.dart';
import '../view/product_variant_edit_dialog.dart';
import '../viewmodal/product_view_modal.dart';


class ProductVariantTable
    extends ConsumerWidget {
  final List<ProductVariantModel>
  productVariants;

  final int productId;

  const ProductVariantTable({
    super.key,
    required this.productVariants,
    required this.productId,
  });

  // ============================================================
  // REFRESH CURRENT PRODUCT
  // ============================================================

  Future<void> _refreshVariants(
      WidgetRef ref,
      ) async {
    await ref
        .read(
      productVariantViewModelProvider
          .notifier,
    )
        .getVariantsByProduct(
      productId,
    );
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection:
          Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection:
            Axis.horizontal,
            child: DataTable(
              headingRowHeight: 55,
              dataRowMinHeight: 70,
              dataRowMaxHeight: 90,
              columnSpacing: 30,

              columns: const [
                DataColumn(
                  label: SizedBox(
                    width: 60,
                    child: Text(
                      'ID',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                DataColumn(
                  label: SizedBox(
                    width: 140,
                    child: Text(
                      'Attribute 1',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                DataColumn(
                  label: SizedBox(
                    width: 140,
                    child: Text(
                      'Attribute 2',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                DataColumn(
                  label: SizedBox(
                    width: 140,
                    child: Text(
                      'Attribute 3',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                DataColumn(
                  label: SizedBox(
                    width: 110,
                    child: Text(
                      'Actual Price',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                DataColumn(
                  label: SizedBox(
                    width: 110,
                    child: Text(
                      'Discount Price',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                DataColumn(
                  label: SizedBox(
                    width: 80,
                    child: Text(
                      'Stock',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                DataColumn(
                  label: SizedBox(
                    width: 180,
                    child: Text(
                      'SKU',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
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
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                DataColumn(
                  label: SizedBox(
                    width: 140,
                    child: Text(
                      'Actions',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],

              rows: productVariants.map(
                    (variant) {
                  return DataRow(
                    cells: [

                      // ==================================================
                      // ID
                      // ==================================================

                      DataCell(
                        SizedBox(
                          width: 60,
                          child: Text(
                            variant.id.toString(),
                          ),
                        ),
                      ),

                      // ==================================================
                      // ATTRIBUTE 1
                      // ==================================================

                      DataCell(
                        SizedBox(
                          width: 140,
                          child: _buildAttributes(
                            variant.attributes,
                          ),
                        ),
                      ),

                      // ==================================================
                      // ATTRIBUTE 2
                      // ==================================================

                      DataCell(
                        SizedBox(
                          width: 140,
                          child: _buildAttributes(
                            variant.attributes,
                          ),
                        ),
                      ),

                      // ==================================================
                      // ATTRIBUTE 3
                      // ==================================================

                      DataCell(
                        SizedBox(
                          width: 140,
                          child: _buildAttributes(
                            variant.attributes,
                          ),
                        ),
                      ),

                      // ==================================================
                      // ACTUAL PRICE
                      // ==================================================

                      DataCell(
                        SizedBox(
                          width: 110,
                          child: Text(
                            '₹${variant.actualPrice.toStringAsFixed(2)}',
                          ),
                        ),
                      ),

                      // ==================================================
                      // DISCOUNT PRICE
                      // ==================================================

                      DataCell(
                        SizedBox(
                          width: 110,
                          child: Text(
                            '₹${variant.discountPrice.toStringAsFixed(2)}',
                          ),
                        ),
                      ),

                      // ==================================================
                      // STOCK
                      // ==================================================

                      DataCell(
                        SizedBox(
                          width: 80,
                          child: Text(
                            variant.stock.toString(),
                          ),
                        ),
                      ),

                      // ==================================================
                      // SKU
                      // ==================================================

                      DataCell(
                        SizedBox(
                          width: 180,
                          child: Text(
                            variant.sku,
                            overflow:
                            TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      // ==================================================
                      // STATUS
                      // ==================================================

                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                              variant.status ==
                                  'ACTIVE'
                                  ? Colors.green
                                  .withValues(
                                alpha: 0.1,
                              )
                                  : Colors.red
                                  .withValues(
                                alpha: 0.1,
                              ),
                              borderRadius:
                              BorderRadius.circular(
                                20,
                              ),
                            ),
                            child: Text(
                              variant.status,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight:
                                FontWeight.w600,
                                color:
                                variant.status ==
                                    'ACTIVE'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ==================================================
                      // ACTIONS
                      // ==================================================

                      DataCell(
                        SizedBox(
                          width: 140,
                          child: Row(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [

                              // ==========================================
                              // EDIT
                              // ==========================================

                              IconButton(
                                tooltip: 'Edit',
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  final updated =
                                  await showDialog<bool>(
                                    context: context,
                                    barrierDismissible:
                                    false,
                                    builder: (context) {
                                      return EditProductVariantDialog(
                                        variant: variant,
                                      );
                                    },
                                  );

                                  if (updated == true) {
                                    await _refreshVariants(
                                      ref,
                                    );
                                  }
                                },
                              ),

                              // ==========================================
                              // DELETE
                              // ==========================================

                              IconButton(
                                tooltip: 'Delete',
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  final deleted =
                                  await showDialog<bool>(
                                    context: context,
                                    barrierDismissible:
                                    false,
                                    builder: (context) {
                                      return DeleteProductVariantDialog(
                                        variant: variant,
                                      );
                                    },
                                  );

                                  if (deleted == true) {
                                    await _refreshVariants(
                                      ref,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
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

  // ============================================================
  // ATTRIBUTE DISPLAY
  // ============================================================

  /*Widget _buildAttribute(
      String? name,
      String? value,
      )
  {
    if ((name == null || name.isEmpty) &&
        (value == null || value.isEmpty)) {
      return const Text('-');
    }

    return Column(
      mainAxisAlignment:
      MainAxisAlignment.center,
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        if (name != null && name.isNotEmpty)
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (value != null && value.isNotEmpty)
          Text(
            value,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }*/
  Widget _buildAttributes(
      List<VariantAttributeModel> attributes,
      ) {
    if (attributes.isEmpty) {
      return const Text(
        'No attributes',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: attributes.map((attribute) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${attribute.attributeName}: ',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                attribute.attributeValue,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}