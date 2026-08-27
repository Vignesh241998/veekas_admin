// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../modal/product_variant_modal.dart';
// import '../viewmodal/product_view_modal.dart';
// import '../widgets/variant_form_dialog.dart';
//
// class ProductVariantScreen
//     extends ConsumerStatefulWidget {
//   final int productId;
//   final String? productName;
//
//   const ProductVariantScreen({
//     super.key,
//     required this.productId,
//     this.productName,
//   });
//
//   @override
//   ConsumerState<ProductVariantScreen>
//   createState() =>
//       _ProductVariantScreenState();
// }
//
// class _ProductVariantScreenState
//     extends ConsumerState<ProductVariantScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//
//     Future.microtask(() {
//       ref
//           .read(
//         productVariantViewModelProvider
//             .notifier,
//       )
//           .getVariants(
//         widget.productId,
//       );
//     });
//   }
//
//   // ============================================================
//   // ADD
//   // ============================================================
//
//   Future<void> addVariant() async {
//     await showDialog(
//       context: context,
//       builder: (_) {
//         return VariantFormDialog(
//           productId: widget.productId,
//         );
//       },
//     );
//   }
//
//   // ============================================================
//   // EDIT
//   // ============================================================
//
//   Future<void> editVariant(
//       ProductVariantModel variant,
//       ) async {
//     await showDialog(
//       context: context,
//       builder: (_) {
//         return VariantFormDialog(
//           productId: widget.productId,
//           variant: variant,
//         );
//       },
//     );
//   }
//
//   // ============================================================
//   // DELETE
//   // ============================================================
//
//   Future<void> deleteVariant(
//       ProductVariantModel variant,
//       ) async {
//     final variantId = variant.id;
//
//     if (variantId == null) {
//       return;
//     }
//
//     final confirm =
//     await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: const Text(
//             'Delete Variant',
//           ),
//           content: const Text(
//             'Are you sure you want to delete this variant?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(
//                   dialogContext,
//                   false,
//                 );
//               },
//               child: const Text(
//                 'Cancel',
//               ),
//             ),
//             ElevatedButton(
//               style:
//               ElevatedButton.styleFrom(
//                 backgroundColor:
//                 Colors.red,
//                 foregroundColor:
//                 Colors.white,
//               ),
//               onPressed: () {
//                 Navigator.pop(
//                   dialogContext,
//                   true,
//                 );
//               },
//               child: const Text(
//                 'Delete',
//               ),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (confirm != true) {
//       return;
//     }
//
//     try {
//       await ref
//           .read(
//         productVariantViewModelProvider
//             .notifier,
//       )
//           .deleteVariant(
//         variantId,
//       );
//
//       if (!mounted) return;
//
//       ScaffoldMessenger.of(context)
//           .showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Variant deleted successfully',
//           ),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//
//       ScaffoldMessenger.of(context)
//           .showSnackBar(
//         SnackBar(
//           content: Text(
//             e.toString().replaceFirst(
//               'Exception: ',
//               '',
//             ),
//           ),
//         ),
//       );
//     }
//   }
//
//   // ============================================================
//   // BUILD
//   // ============================================================
//
//   @override
//   Widget build(
//       BuildContext context,
//       ) {
//     final variantState = ref.watch(
//       productVariantViewModelProvider,
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.productName == null
//               ? 'Product Variants'
//               : '${widget.productName} - Variants',
//         ),
//       ),
//
//       body: variantState.when(
//         // ======================================================
//         // LOADING
//         // ======================================================
//
//         loading: () {
//           return const Center(
//             child:
//             CircularProgressIndicator(),
//           );
//         },
//
//         // ======================================================
//         // ERROR
//         // ======================================================
//
//         error: (error, stackTrace) {
//           return Center(
//             child: Column(
//               mainAxisSize:
//               MainAxisSize.min,
//               children: [
//                 const Icon(
//                   Icons.error_outline,
//                   size: 50,
//                   color: Colors.red,
//                 ),
//
//                 const SizedBox(
//                   height: 10,
//                 ),
//
//                 Text(
//                   error.toString()
//                       .replaceFirst(
//                     'Exception: ',
//                     '',
//                   ),
//                 ),
//
//                 const SizedBox(
//                   height: 15,
//                 ),
//
//                 ElevatedButton(
//                   onPressed: () {
//                     ref
//                         .read(
//                       productVariantViewModelProvider
//                           .notifier,
//                     )
//                         .getVariants(
//                       widget.productId,
//                     );
//                   },
//                   child: const Text(
//                     'Retry',
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//
//         // ======================================================
//         // DATA
//         // ======================================================
//
//         data: (variants) {
//           if (variants.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No variants found',
//               ),
//             );
//           }
//
//           return ListView.builder(
//             padding:
//             const EdgeInsets.all(16),
//             itemCount: variants.length,
//             itemBuilder:
//                 (context, index) {
//               final variant =
//               variants[index];
//
//               return Card(
//                 margin:
//                 const EdgeInsets.only(
//                   bottom: 12,
//                 ),
//
//                 child: Padding(
//                   padding:
//                   const EdgeInsets.all(
//                     16,
//                   ),
//
//                   child: Column(
//                     crossAxisAlignment:
//                     CrossAxisAlignment
//                         .start,
//                     children: [
//                       // ========================================
//                       // TOP
//                       // ========================================
//
//                       Row(
//                         mainAxisAlignment:
//                         MainAxisAlignment
//                             .spaceBetween,
//                         children: [
//                           Text(
//                             'Variant #${variant.id}',
//                             style:
//                             const TextStyle(
//                               fontSize: 17,
//                               fontWeight:
//                               FontWeight.bold,
//                             ),
//                           ),
//
//                           Row(
//                             children: [
//                               IconButton(
//                                 tooltip:
//                                 'Edit',
//                                 onPressed:
//                                     () {
//                                   editVariant(
//                                     variant,
//                                   );
//                                 },
//                                 icon:
//                                 const Icon(
//                                   Icons
//                                       .edit_outlined,
//                                 ),
//                               ),
//
//                               IconButton(
//                                 tooltip:
//                                 'Delete',
//                                 onPressed:
//                                     () {
//                                   deleteVariant(
//                                     variant,
//                                   );
//                                 },
//                                 icon:
//                                 const Icon(
//                                   Icons
//                                       .delete_outline,
//                                   color:
//                                   Colors.red,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//
//                       const Divider(),
//
//                       // ========================================
//                       // PRICE / STOCK
//                       // ========================================
//
//                       Wrap(
//                         spacing: 30,
//                         runSpacing: 10,
//                         children: [
//                           Text(
//                             'Actual Price: ₹${variant.actualPrice.toStringAsFixed(2)}',
//                           ),
//
//                           Text(
//                             'Discount Price: ₹${variant.discountPrice.toStringAsFixed(2)}',
//                           ),
//
//                           Text(
//                             'Stock: ${variant.stock}',
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(
//                         height: 10,
//                       ),
//
//                       Text(
//                         'SKU: ${variant.sku}',
//                       ),
//
//                       const SizedBox(
//                         height: 15,
//                       ),
//
//                       // ========================================
//                       // ATTRIBUTES
//                       // ========================================
//
//                       const Text(
//                         'Attributes',
//                         style: TextStyle(
//                           fontWeight:
//                           FontWeight.bold,
//                         ),
//                       ),
//
//                       const SizedBox(
//                         height: 8,
//                       ),
//
//                       if (variant.attributes
//                           .isEmpty)
//                         const Text(
//                           'No attributes',
//                         )
//                       else
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: variant
//                               .attributes
//                               .map(
//                                 (attribute) {
//                               return Chip(
//                                 label: Text(
//                                   '${attribute.attributeName}: ${attribute.attributeValue}',
//                                 ),
//                               );
//                             },
//                           ).toList(),
//                         ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//
//       floatingActionButton:
//       FloatingActionButton.extended(
//         onPressed: addVariant,
//         icon: const Icon(
//           Icons.add,
//         ),
//         label: const Text(
//           'Add Variant',
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../product/Modal/product_modal.dart';
import '../../product/repository/product_repository.dart';

import '../modal/product_variant_modal.dart';
import '../viewmodal/product_view_modal.dart';
import '../widgets/variant_form_dialog.dart';

class ProductVariantScreen extends ConsumerStatefulWidget {
  /// Optional.
  ///
  /// If productId is passed from another screen,
  /// that product will be selected automatically.
  final int? productId;

  final String? productName;

  const ProductVariantScreen({
    super.key,
    this.productId,
    this.productName,
  });

  @override
  ConsumerState<ProductVariantScreen> createState() =>
      _ProductVariantScreenState();
}

class _ProductVariantScreenState
    extends ConsumerState<ProductVariantScreen> {
  // ============================================================
  // REPOSITORY
  // ============================================================

  final ProductRepository _productRepository =
  ProductRepository();

  // ============================================================
  // PRODUCTS
  // ============================================================

  List<ProductModel> products = [];

  int? selectedProductId;

  bool isProductsLoading = true;
  String? productsError;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadProducts();
  }

  // ============================================================
  // LOAD PRODUCTS
  // ============================================================

  Future<void> _loadProducts() async {
    setState(() {
      isProductsLoading = true;
      productsError = null;
    });

    try {
      final result =
      await _productRepository.getProducts();

      if (!mounted) return;

      setState(() {
        products = result;

        // If productId was passed from another screen,
        // select that product.
        if (widget.productId != null &&
            result.any(
                  (product) =>
              product.id == widget.productId,
            )) {
          selectedProductId = widget.productId;
        }

        // If nothing is selected, select first product.
        else if (result.isNotEmpty) {
          selectedProductId = result.first.id;
        }

        isProductsLoading = false;
      });

      // Load variants for selected product.
      if (selectedProductId != null) {
        _loadVariants(selectedProductId!);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isProductsLoading = false;

        productsError = e
            .toString()
            .replaceFirst(
          'Exception: ',
          '',
        );
      });
    }
  }

  // ============================================================
  // LOAD VARIANTS
  // ============================================================

  Future<void> _loadVariants(
      int productId,
      ) async {
    await ref
        .read(
      productVariantViewModelProvider
          .notifier,
    )
        .getVariants(productId);
  }

  // ============================================================
  // PRODUCT CHANGE
  // ============================================================

  void _onProductChanged(int? productId) {
    if (productId == null) return;

    setState(() {
      selectedProductId = productId;
    });

    _loadVariants(productId);
  }

  // ============================================================
  // SELECTED PRODUCT
  // ============================================================

  ProductModel? get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }

    for (final product in products) {
      if (product.id == selectedProductId) {
        return product;
      }
    }

    return null;
  }

  // ============================================================
  // ADD VARIANT
  // ============================================================

  Future<void> addVariant1() async {
    if (selectedProductId == null) {
      _showMessage(
        'Please select a product first.',
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (_) {
        return VariantFormDialog(
          productId: selectedProductId!,
        );
      },
    );

    // Refresh after dialog closes.
    if (selectedProductId != null) {
      await _loadVariants(
        selectedProductId!,
      );
    }
  }
  Future<void> addVariant() async {
    await showDialog(
      context: context,
      builder: (_) {
        return const VariantFormDialog();
      },
    );

    // Reload variants if needed here.
    if (selectedProductId != null) {
      await _loadVariants(
        selectedProductId!,
      );
    }
  }
  // ============================================================
  // EDIT VARIANT
  // ============================================================

  Future<void> editVariant(
      ProductVariantModel variant,
      ) async {
    if (selectedProductId == null) {
      return;
    }

    await showDialog(
      context: context,
      builder: (_) {
        return VariantFormDialog(
          productId: selectedProductId!,
          variant: variant,
        );
      },
    );

    // Refresh after edit.
    if (selectedProductId != null) {
      await _loadVariants(
        selectedProductId!,
      );
    }
  }

  // ============================================================
  // DELETE VARIANT
  // ============================================================

  Future<void> deleteVariant(
      ProductVariantModel variant,
      ) async {
    final variantId = variant.id;

    if (variantId == null) {
      return;
    }

    final confirm =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Variant',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: const Text(
            'Are you sure you want to delete this variant?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              style:
              ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    try {
      await ref
          .read(
        productVariantViewModelProvider
            .notifier,
      )
          .deleteVariant(
        variantId,
      );

      if (!mounted) return;

      _showMessage(
        'Variant deleted successfully',
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
        isError: true,
      );
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
      String message, {
        bool isError = false,
      }) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        backgroundColor:
        isError ? Colors.red : null,
        content: Text(message),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final variantState = ref.watch(
      productVariantViewModelProvider,
    );

    return Scaffold(
      backgroundColor:
      const Color(0xFFF6F7FB),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        title: Text(
          selectedProduct == null
              ? 'Product Variants'
              : '${selectedProduct!.productName} - Variants',
        ),

        backgroundColor: Colors.white,

        foregroundColor:
        const Color(0xFF202124),

        elevation: 0,
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Column(
        children: [
          // ======================================================
          // PRODUCT SELECTOR
          // ======================================================

          _buildProductSelector(),

          const Divider(
            height: 1,
          ),

          // ======================================================
          // VARIANTS
          // ======================================================

          Expanded(
            child: _buildVariantBody(
              variantState,
            ),
          ),
        ],
      ),

      // ========================================================
      // ADD BUTTON
      // ========================================================

      floatingActionButton:
      selectedProductId == null
          ? null
          : FloatingActionButton.extended(
        onPressed: addVariant,

        backgroundColor:
        const Color(0xFF965DC2),

        foregroundColor:
        Colors.white,

        icon: const Icon(
          Icons.add,
        ),

        label: const Text(
          'Add Variant',
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT SELECTOR
  // ============================================================

  Widget _buildProductSelector() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 18,
      ),

      color: Colors.white,

      child: Row(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            color: Color(0xFF965DC2),
          ),

          const SizedBox(width: 12),

          const Text(
            'Select Product',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF202124),
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: isProductsLoading
                ? Container(
              height: 48,
              alignment:
              Alignment.centerLeft,
              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color:
                const Color(0xFFF7F7F8),
                borderRadius:
                BorderRadius.circular(
                  8,
                ),
              ),
              child: const SizedBox(
                width: 20,
                height: 20,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            )
                : productsError != null
                ? _buildProductError()
                : products.isEmpty
                ? _buildNoProducts()
                : _buildDropdown(),
          ),

          const SizedBox(width: 15),

          IconButton(
            tooltip: 'Refresh Products',
            onPressed: isProductsLoading
                ? null
                : _loadProducts,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DROPDOWN
  // ============================================================

  Widget _buildDropdown() {
    return DropdownButtonFormField<int>(
      value: selectedProductId,

      isExpanded: true,

      decoration:
      InputDecoration(
        labelText: 'Product',

        prefixIcon: const Icon(
          Icons.shopping_bag_outlined,
        ),

        border:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            8,
          ),
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            8,
          ),
          borderSide:
          const BorderSide(
            color: Color(0xFFDCDCE1),
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            8,
          ),
          borderSide:
          const BorderSide(
            color: Color(0xFF965DC2),
            width: 2,
          ),
        ),
      ),

      items: products.map(
            (product) {
          return DropdownMenuItem<int>(
            value: product.id,

            child: Text(
              '${product.productName}  •  ID: ${product.id}',

              overflow:
              TextOverflow.ellipsis,

              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          );
        },
      ).toList(),

      onChanged:
      _onProductChanged,
    );
  }

  // ============================================================
  // PRODUCT ERROR
  // ============================================================

  Widget _buildProductError() {
    return Container(
      height: 48,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),

        borderRadius:
        BorderRadius.circular(8),

        border: Border.all(
          color: Colors.red.shade200,
        ),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 20,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              productsError ??
                  'Unable to load products.',
              overflow:
              TextOverflow.ellipsis,

              style: const TextStyle(
                color: Colors.red,
                fontSize: 13,
              ),
            ),
          ),

          TextButton(
            onPressed: _loadProducts,
            child: const Text(
              'Retry',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NO PRODUCTS
  // ============================================================

  Widget _buildNoProducts() {
    return Container(
      height: 48,

      alignment:
      Alignment.centerLeft,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      decoration: BoxDecoration(
        color:
        const Color(0xFFF7F7F8),

        borderRadius:
        BorderRadius.circular(8),

        border: Border.all(
          color:
          const Color(0xFFDCDCE1),
        ),
      ),

      child: const Text(
        'No products available',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }

  // ============================================================
  // VARIANT BODY
  // ============================================================

  Widget _buildVariantBody(
      AsyncValue<List<ProductVariantModel>>
      variantState,
      ) {
    if (selectedProductId == null) {
      return const Center(
        child: Text(
          'Please select a product to manage variants',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF55555C),
          ),
        ),
      );
    }

    return variantState.when(
      // ========================================================
      // LOADING
      // ========================================================

      loading: () {
        return const Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child:
            CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Color(0xFF965DC2),
            ),
          ),
        );
      },

      // ========================================================
      // ERROR
      // ========================================================

      error: (error, stackTrace) {
        return Center(
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),

              const SizedBox(height: 12),

              const Text(
                'Unable to load variants',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: 500,
                child: Text(
                  error
                      .toString()
                      .replaceFirst(
                    'Exception: ',
                    '',
                  ),
                  textAlign:
                  TextAlign.center,
                  style:
                  const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              ElevatedButton.icon(
                onPressed: () {
                  _loadVariants(
                    selectedProductId!,
                  );
                },

                icon: const Icon(
                  Icons.refresh,
                ),

                label: const Text(
                  'Retry',
                ),
              ),
            ],
          ),
        );
      },

      // ========================================================
      // DATA
      // ========================================================

      data: (variants) {
        if (variants.isEmpty) {
          return _buildEmptyVariants();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(
            24,
          ),

          itemCount: variants.length,

          itemBuilder:
              (context, index) {
            final variant =
            variants[index];

            return _buildVariantCard(
              variant,
            );
          },
        );
      },
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyVariants() {
    return Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,

            decoration:
            const BoxDecoration(
              color: Color(0xFFF0E8F6),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.inventory_2_outlined,
              size: 34,
              color: Color(0xFF965DC2),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'No variants found',
            style: TextStyle(
              fontSize: 17,
              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Add the first variant for this product.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 18),

          ElevatedButton.icon(
            onPressed: addVariant,

            icon: const Icon(
              Icons.add,
            ),

            label: const Text(
              'Add Variant',
            ),

            style:
            ElevatedButton.styleFrom(
              backgroundColor:
              const Color(0xFF965DC2),
              foregroundColor:
              Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VARIANT CARD
  // ============================================================

  Widget _buildVariantCard(
      ProductVariantModel variant,
      ) {
    return Card(
      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),

      elevation: 0,

      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(
          12,
        ),

        side: const BorderSide(
          color: Color(0xFFE5E5EA),
        ),
      ),

      child: Padding(
        padding:
        const EdgeInsets.all(
          18,
        ),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            // ==================================================
            // TOP
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: Text(
                    'Variant #${variant.id ?? '-'}',

                    style:
                    const TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration:
                  BoxDecoration(
                    color:
                    variant.status
                        .toUpperCase() ==
                        'ACTIVE'
                        ? const Color(
                      0xFFE8F7EE,
                    )
                        : const Color(
                      0xFFFFEEEE,
                    ),

                    borderRadius:
                    BorderRadius
                        .circular(
                      20,
                    ),
                  ),

                  child: Text(
                    variant.status,

                    style:
                    TextStyle(
                      fontSize: 11,
                      fontWeight:
                      FontWeight.w700,

                      color: variant.status
                          .toUpperCase() ==
                          'ACTIVE'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                IconButton(
                  tooltip: 'Edit',

                  onPressed: () {
                    editVariant(
                      variant,
                    );
                  },

                  icon: const Icon(
                    Icons
                        .edit_outlined,
                    size: 20,
                  ),
                ),

                IconButton(
                  tooltip: 'Delete',

                  onPressed: () {
                    deleteVariant(
                      variant,
                    );
                  },

                  icon: const Icon(
                    Icons
                        .delete_outline,
                    size: 20,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const Divider(),

            const SizedBox(
              height: 5,
            ),

            // ==================================================
            // PRICE / STOCK
            // ==================================================

            Wrap(
              spacing: 35,
              runSpacing: 12,

              children: [
                _buildInfoItem(
                  'Actual Price',
                  '₹${variant.actualPrice.toStringAsFixed(2)}',
                ),

                _buildInfoItem(
                  'Discount Price',
                  '₹${variant.discountPrice.toStringAsFixed(2)}',
                ),

                _buildInfoItem(
                  'Stock',
                  '${variant.stock}',
                ),

                _buildInfoItem(
                  'SKU',
                  variant.sku,
                ),
              ],
            ),

            const SizedBox(
              height: 18,
            ),

            // ==================================================
            // ATTRIBUTES
            // ==================================================

            const Text(
              'Attributes',

              style: TextStyle(
                fontSize: 14,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            if (variant.attributes.isEmpty)
              const Text(
                'No attributes',
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,

                children:
                variant.attributes
                    .map(
                      (attribute) {
                    return Chip(
                      backgroundColor:
                      const Color(
                        0xFFF3ECF8,
                      ),

                      side:
                      BorderSide.none,

                      label: Text(
                        '${attribute.attributeName}: ${attribute.attributeValue}',

                        style:
                        const TextStyle(
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w600,
                          color:
                          Color(
                            0xFF633B7D,
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INFO ITEM
  // ============================================================

  Widget _buildInfoItem(
      String title,
      String value,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),

        const SizedBox(
          height: 3,
        ),

        Text(
          value,

          style: const TextStyle(
            fontSize: 13,
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ],
    );
  }
}