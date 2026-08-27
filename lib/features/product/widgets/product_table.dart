import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../Modal/product_modal.dart';
import '../ViewModal/delete_product_dialog.dart';
import '../ViewModal/edit_product_dialog.dart';


class ProductTable extends StatelessWidget {
  final List<ProductModel> products;

  const ProductTable({
    super.key,
    required this.products,
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
        child: SingleChildScrollView(
          child: DataTable(
            columnSpacing: 30,
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

              // Product Code
              DataColumn(
                label: Text("Code"),
              ),

              // Product Name
              DataColumn(
                label: Text("Product"),
              ),

              // Category
              DataColumn(
                label: Text("Category"),
              ),

              // Sub Category
              DataColumn(
                label: Text("Sub Category"),
              ),

              // Brand
              DataColumn(
                label: Text("Brand"),
              ),

              // Actual Price
              DataColumn(
                label: Text("Actual Price"),
              ),

              // Discount Price
              DataColumn(
                label: Text("Discount Price"),
              ),

              // Stock
              DataColumn(
                label: Text("Stock"),
              ),

              // Featured
              DataColumn(
                label: Text("Featured"),
              ),

              // New Arrival
              DataColumn(
                label: Text("New Arrival"),
              ),

              // Variant
              DataColumn(
                label: Text("Variant"),
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

            rows: products.map((product) {

              return DataRow(
                cells: [

                  // ==================================================
                  // IMAGE
                  // ==================================================

                  DataCell(
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(6),

                      child: product.thumbnailImage !=
                          null &&
                          product.thumbnailImage!
                              .isNotEmpty

                          ? Image.network(
                        product.thumbnailImage!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,

                        errorBuilder:
                            (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return const SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons
                                  .image_not_supported,
                              color: Colors.red,
                            ),
                          );
                        },
                      )

                          : const SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // PRODUCT CODE
                  // ==================================================

                  DataCell(
                    Text(
                      product.productCode,
                    ),
                  ),

                  // ==================================================
                  // PRODUCT NAME
                  // ==================================================

                  DataCell(
                    SizedBox(
                      width: 150,
                      child: Text(
                        product.productName,
                        overflow:
                        TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // ==================================================
                  // CATEGORY
                  // ==================================================

                  DataCell(
                    Text(
                      product.categoryName,
                    ),
                  ),

                  // ==================================================
                  // SUB CATEGORY
                  // ==================================================

                  DataCell(
                    Text(
                      product.subCategoryName,
                    ),
                  ),

                  // ==================================================
                  // BRAND
                  // ==================================================

                  DataCell(
                    Text(
                      product.brandName,
                    ),
                  ),

                  // ==================================================
                  // ACTUAL PRICE
                  // ==================================================

                  DataCell(
                    Text(
                      "₹ ${product.actualPrice.toStringAsFixed(2)}",
                    ),
                  ),

                  // ==================================================
                  // DISCOUNT PRICE
                  // ==================================================

                  DataCell(
                    Text(
                      "₹ ${product.discountPrice.toStringAsFixed(2)}",
                    ),
                  ),

                  // ==================================================
                  // STOCK
                  // ==================================================

                  DataCell(
                    Text(
                      product.stock.toString(),
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,

                        color: product.stock <= 5
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  ),

                  // ==================================================
                  // FEATURED
                  // ==================================================

                  DataCell(
                    _statusChip(
                      product.isFeatured,
                      "YES",
                      "NO",
                    ),
                  ),

                  // ==================================================
                  // NEW ARRIVAL
                  // ==================================================

                  DataCell(
                    _statusChip(
                      product.isNewArrival,
                      "YES",
                      "NO",
                    ),
                  ),

                  // ==================================================
                  // VARIANT
                  // ==================================================

                  DataCell(
                    _statusChip(
                      product.hasVariant,
                      "YES",
                      "NO",
                    ),
                  ),

                  // ==================================================
                  // STATUS
                  // ==================================================

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
                        product.status ==
                            "ACTIVE"
                            ? Colors.green
                            .shade100
                            : Colors.red
                            .shade100,

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: Text(
                        product.status,

                        style: TextStyle(
                          color:
                          product.status ==
                              "ACTIVE"
                              ? Colors.green
                              : Colors.red,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // CREATED DATE
                  // ==================================================

                  DataCell(
                    Text(
                      _formatDate(
                        product.createdAt,
                      ),
                    ),
                  ),

                  // ==================================================
                  // ACTIONS
                  // ==================================================

                  DataCell(
                    Row(
                      mainAxisSize:
                      MainAxisSize.min,

                      children: [

                        // ------------------------------------------------
                        // EDIT
                        // ------------------------------------------------

                        IconButton(
                          tooltip:
                          "Edit Product",

                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),

                          onPressed: () {

                            showDialog(
                              context: context,

                              builder: (_) =>
                                  EditProductDialog(
                                    product: product,
                                  ),
                            );
                          },
                        ),

                        // ------------------------------------------------
                        // DELETE
                        // ------------------------------------------------

                        IconButton(
                          tooltip:
                          "Delete Product",

                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),

                          onPressed: () {

                            showDialog(
                              context: context,

                              builder: (_) =>
                                  DeleteProductDialog(
                                    product: product,
                                  ),
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
      ),
    );
  }

  // ============================================================
  // YES / NO CHIP
  // ============================================================

  Widget _statusChip(
      bool value,
      String activeText,
      String inactiveText,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: value
            ? Colors.green.shade100
            : Colors.grey.shade200,

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Text(
        value ? activeText : inactiveText,

        style: TextStyle(
          fontSize: 12,

          fontWeight:
          FontWeight.bold,

          color: value
              ? Colors.green
              : Colors.grey.shade700,
        ),
      ),
    );
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatDate(String date) {

    if (date.isEmpty) {
      return "-";
    }

    try {
      final parsedDate =
      DateTime.parse(date);

      return "${parsedDate.day.toString().padLeft(2, '0')}/"
          "${parsedDate.month.toString().padLeft(2, '0')}/"
          "${parsedDate.year}";
    } catch (e) {
      return date;
    }
  }
}