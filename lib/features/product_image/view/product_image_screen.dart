import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veekas_ecommerce_app/features/product_image/view/product_image_add_dialog.dart';

import '../../product/ViewModal/product_view_modal.dart';
import '../modal/product_image_modal.dart';
import '../viewmodal/product_view_modal.dart';
import '../widgets/product_image_table.dart';


class ProductImageScreen extends ConsumerStatefulWidget {
  const ProductImageScreen({super.key});

  @override
  ConsumerState<ProductImageScreen> createState() =>
      _ProductImageScreenState();
}

class _ProductImageScreenState
    extends ConsumerState<ProductImageScreen> {
  int? selectedProductId;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      // Load products for dropdown
      ref.read(productViewModelProvider.notifier).getProducts();
    });
  }

  // ============================================================
  // LOAD IMAGES FOR SELECTED PRODUCT
  // ============================================================

  Future<void> _loadProductImages(int productId) async {
    try {
      await ref
          .read(productImageViewModelProvider.notifier)
          .getImagesByProduct(productId);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    }
  }

  // ============================================================
  // PRODUCT CHANGED
  // ============================================================

  void _onProductChanged(int? productId) {
    setState(() {
      selectedProductId = productId;
    });

    if (productId != null) {
      _loadProductImages(productId);
    }
  }

  // ============================================================
  // OPEN ADD IMAGE DIALOG
  // ============================================================

  void _openAddImageDialog() {
    if (selectedProductId == null) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AddProductImageDialog(
          productId: selectedProductId!,
        );
      },
    ).then((_) {
      if (selectedProductId != null) {
        _loadProductImages(selectedProductId!);
      }
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(
      productViewModelProvider,
    );

    final productImageState = ref.watch(
      productImageViewModelProvider,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ==================================================
            // HEADER
            // ==================================================

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [

                const Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      'Product Images',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      'Manage images for your products',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                // ==================================================
                // ADD IMAGE BUTTON
                // ==================================================

                if (selectedProductId != null)
                  ElevatedButton.icon(
                    onPressed: _openAddImageDialog,
                    icon: const Icon(
                      Icons.add_photo_alternate_outlined,
                    ),
                    label: const Text(
                      'Add Image',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            // ==================================================
            // PRODUCT DROPDOWN
            // ==================================================

            Container(
              width: 450,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.05,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Select Product',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  productState.when(
                    loading: () => const SizedBox(
                      height: 50,
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),

                    error: (error, stackTrace) =>
                        Text(
                          error.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),

                    data: (products) {

                      if (products.isEmpty) {
                        return const Text(
                          'No products available',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        );
                      }

                      return DropdownButtonFormField<int>(
                        value: selectedProductId,

                        isExpanded: true,

                        decoration:
                        const InputDecoration(
                          hintText: 'Select Product',
                          border:
                          OutlineInputBorder(),
                        ),

                        items: products.map((product) {
                          return DropdownMenuItem<int>(
                            value: product.id,
                            child: Text(
                              product.productName,
                              overflow:
                              TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),

                        onChanged: _onProductChanged,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ==================================================
            // IMAGE CONTENT
            // ==================================================

            Expanded(
              child: selectedProductId == null
                  ? _buildSelectProductMessage()
                  : productImageState.when(
                loading: () => const Center(
                  child:
                  CircularProgressIndicator(),
                ),

                error: (
                    error,
                    stackTrace,
                    ) =>
                    _buildErrorState(error),

                data: (images) {
                  return _buildImageContent(
                    images,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SELECT PRODUCT MESSAGE
  // ============================================================

  Widget _buildSelectProductMessage() {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: const [

          Icon(
            Icons.image_outlined,
            size: 60,
            color: Colors.grey,
          ),

          SizedBox(height: 12),

          Text(
            'Select a product to view its images',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // IMAGE CONTENT
  // ============================================================

  Widget _buildImageContent(
      List<ProductImageModel> images,
      ) {
    if (images.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.image_not_supported_outlined,
              size: 60,
              color: Colors.grey,
            ),

            const SizedBox(height: 12),

            const Text(
              'No images found for this product',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _openAddImageDialog,
              icon: const Icon(
                Icons.add_photo_alternate_outlined,
              ),
              label: const Text(
                'Add Image',
              ),
            ),
          ],
        ),
      );
    }

    return ProductImageTable(
      productImages: images,
      productId: selectedProductId!,
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [

          const Icon(
            Icons.error_outline,
            size: 50,
            color: Colors.red,
          ),

          const SizedBox(height: 12),

          Text(
            error.toString(),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {
              if (selectedProductId != null) {
                _loadProductImages(
                  selectedProductId!,
                );
              }
            },
            child: const Text(
              'Retry',
            ),
          ),
        ],
      ),
    );
  }
}