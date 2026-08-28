import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veekas_ecommerce_app/features/product/viewmodal/product_view_modal.dart';

import '../modal/product_modal.dart';

class DeleteProductDialog extends ConsumerStatefulWidget {
  final ProductModel product;

  const DeleteProductDialog({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<DeleteProductDialog> createState() =>
      _DeleteProductDialogState();
}

class _DeleteProductDialogState
    extends ConsumerState<DeleteProductDialog> {

  bool isLoading = false;

  // ============================================================
  // DELETE PRODUCT
  // ============================================================

  Future<void> deleteProduct() async {
    setState(() {
      isLoading = true;
    });

    try {
      final success = await ref
          .read(productViewModelProvider.notifier)
          .deleteProduct(widget.product.id);

      if (!mounted) return;

      if (success) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Product Deleted Successfully",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              "Exception: ",
              "",
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Delete Product",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SizedBox(
        width: 450,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Text(
            "Are you sure you want to delete "
                "'${widget.product.productName}'?",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),

      actionsPadding: const EdgeInsets.fromLTRB(
        24,
        10,
        24,
        20,
      ),

      actions: [

        // ======================================================
        // CANCEL
        // ======================================================

        TextButton(
          onPressed: isLoading
              ? null
              : () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
          ),
        ),

        const SizedBox(width: 8),

        // ======================================================
        // DELETE
        // ======================================================

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size(
              140,
              45,
            ),
          ),

          onPressed: isLoading
              ? null
              : deleteProduct,

          child: isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text(
            "Delete Product",
          ),
        ),
      ],
    );
  }
}