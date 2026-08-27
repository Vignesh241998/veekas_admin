import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modal/product_image_modal.dart';
import '../viewmodal/product_view_modal.dart';


class DeleteProductImageDialog extends ConsumerStatefulWidget {
  final ProductImageModel productImage;

  const DeleteProductImageDialog({
    super.key,
    required this.productImage,
  });

  @override
  ConsumerState<DeleteProductImageDialog> createState() =>
      _DeleteProductImageDialogState();
}

class _DeleteProductImageDialogState
    extends ConsumerState<DeleteProductImageDialog> {
  bool isLoading = false;

  // ============================================================
  // DELETE IMAGE
  // ============================================================

  Future<void> _deleteImage() async {
    setState(() {
      isLoading = true;
    });

    try {
      await ref
          .read(productImageViewModelProvider.notifier)
          .deleteProductImage(
        widget.productImage.id,
      );

      if (!mounted) return;

      // Navigator.pop(context);
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Product image deleted successfully',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

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
  // IMAGE PREVIEW
  // ============================================================

  Widget _buildImagePreview() {
    if (widget.productImage.image == null ||
        widget.productImage.image!.isEmpty) {
      return Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 35,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        widget.productImage.image!,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return Container(
            width: 90,
            height: 90,
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.broken_image_outlined,
              color: Colors.grey,
              size: 35,
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete Product Image',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SizedBox(
        width: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ==================================================
            // IMAGE
            // ==================================================

            _buildImagePreview(),

            const SizedBox(height: 20),

            // ==================================================
            // MESSAGE
            // ==================================================

            const Text(
              'Are you sure you want to delete this product image?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'This action will make the image inactive.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),

      // ==========================================================
      // ACTIONS
      // ==========================================================

      actions: [

        // ========================================================
        // CANCEL
        // ========================================================

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

        // ========================================================
        // DELETE
        // ========================================================

        ElevatedButton(
          onPressed:
          isLoading ? null : _deleteImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: isLoading
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
              : const Text(
            'Delete',
          ),
        ),
      ],
    );
  }
}