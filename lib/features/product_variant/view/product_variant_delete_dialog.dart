import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modal/product_variant_modal.dart';
import '../viewmodal/product_view_modal.dart';

class DeleteProductVariantDialog
    extends ConsumerStatefulWidget {
  final ProductVariantModel variant;

  const DeleteProductVariantDialog({
    super.key,
    required this.variant,
  });

  @override
  ConsumerState<DeleteProductVariantDialog> createState() =>
      _DeleteProductVariantDialogState();
}

class _DeleteProductVariantDialogState
    extends ConsumerState<DeleteProductVariantDialog> {

  bool isLoading = false;

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> _deleteVariant() async {

    // Show loader immediately
    setState(() {
      isLoading = true;
    });

    try {

      await ref
          .read(
        productVariantViewModelProvider.notifier,
      )
          .deleteVariant(
        widget.variant.id!,
      );

      if (!mounted) return;

      // Close dialog after successful delete
      Navigator.pop(
        context,
        true,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Product variant deleted successfully',
          ),
        ),
      );

    } catch (e) {

      if (!mounted) return;

      // Stop loader if error occurs
      setState(() {
        isLoading = false;
      });

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
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {

    final variant = widget.variant;

    return AlertDialog(

      title: const Text(
        'Delete Product Variant',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SizedBox(
        width: 450,

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              'Are you sure you want to delete this product variant?',
              style: TextStyle(
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // VARIANT INFORMATION
            // ==================================================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.grey.shade100,

                borderRadius:
                BorderRadius.circular(8),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  if (variant.sku.isNotEmpty)
                    Text(
                      'SKU: ${variant.sku}',

                      style: const TextStyle(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                  const SizedBox(height: 6),

                  Text(
                    'Stock: ${variant.stock}',
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Price: ₹${variant.discountPrice.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'This action will mark the variant as inactive.',

              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),

      // ==========================================================
      // ACTIONS
      // ==========================================================

      actions: [

        // CANCEL
        TextButton(
          onPressed: isLoading
              ? null
              : () {
            Navigator.pop(context);
          },

          child: const Text(
            'Cancel',
          ),
        ),

        // DELETE
        ElevatedButton(

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),

          onPressed:
          isLoading
              ? null
              : _deleteVariant,

          child: isLoading

          // ==============================
          // LOADER
          // ==============================

              ? const SizedBox(
            width: 20,
            height: 20,

            child:
            CircularProgressIndicator(
              strokeWidth: 2,

              valueColor:
              AlwaysStoppedAnimation<
                  Color>(
                Colors.white,
              ),
            ),
          )

          // ==============================
          // NORMAL BUTTON
          // ==============================

              : const Text(
            'Delete Variant',
          ),
        ),
      ],
    );
  }
}