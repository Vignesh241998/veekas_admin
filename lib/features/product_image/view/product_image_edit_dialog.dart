import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modal/product_image_modal.dart';
import '../viewmodal/product_view_modal.dart';

class EditProductImageDialog extends ConsumerStatefulWidget {
  final ProductImageModel productImage;

  const EditProductImageDialog({
    super.key,
    required this.productImage,
  });

  @override
  ConsumerState<EditProductImageDialog> createState() =>
      _EditProductImageDialogState();
}

class _EditProductImageDialogState
    extends ConsumerState<EditProductImageDialog> {
  PlatformFile? selectedImage;

  bool isLoading = false;

  // ============================================================
  // PICK NEW IMAGE
  // ============================================================

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
        ],
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.first;

      if (file.bytes == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to read selected image',
            ),
          ),
        );

        return;
      }

      setState(() {
        selectedImage = file;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to select image: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // UPDATE IMAGE
  // ============================================================

  Future<void> _updateImage() async {
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a new image',
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await ref
          .read(productImageViewModelProvider.notifier)
          .updateProductImage(
        id: widget.productImage.id,
        image: selectedImage!,
      );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Product image updated successfully',
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
  // CURRENT IMAGE
  // ============================================================

  Widget _buildCurrentImage() {
    if (widget.productImage.image == null ||
        widget.productImage.image!.isEmpty) {
      return Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.image_not_supported_outlined,
          size: 50,
          color: Colors.grey,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        widget.productImage.image!,
        width: 180,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return Container(
            width: 180,
            height: 180,
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.broken_image_outlined,
              size: 50,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // NEW IMAGE PREVIEW
  // ============================================================

  Widget _buildNewImagePreview() {
    if (selectedImage == null) {
      return Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 45,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              'Select new image',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.memory(
        selectedImage!.bytes!,
        width: 180,
        height: 180,
        fit: BoxFit.cover,
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
        'Edit Product Image',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SizedBox(
        width: 620,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              // ==================================================
              // PRODUCT INFO
              // ==================================================

              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius:
                  BorderRadius.circular(8),
                ),
                child: Row(
                  children: [

                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 20,
                    ),

                    const SizedBox(width: 10),

                    Text(
                      widget.productImage.productName ??
                          'Product ID: ${widget.productImage.productId}',
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // IMAGE SECTION
              // ==================================================

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  // ==============================================
                  // CURRENT IMAGE
                  // ==============================================

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        const Text(
                          'Current Image',
                          style: TextStyle(
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Center(
                          child:
                          _buildCurrentImage(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 25),

                  // ==============================================
                  // NEW IMAGE
                  // ==============================================

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        const Text(
                          'New Image',
                          style: TextStyle(
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Center(
                          child:
                          _buildNewImagePreview(),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed:
                            isLoading
                                ? null
                                : _pickImage,
                            icon: const Icon(
                              Icons
                                  .photo_library_outlined,
                            ),
                            label: const Text(
                              'Choose Image',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Text(
                'Allowed formats: JPG, JPEG, PNG • Maximum size: 2 MB',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
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
        // UPDATE
        // ========================================================

        ElevatedButton(
          onPressed:
          isLoading
              ? null
              : _updateImage,
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
            'Update Image',
          ),
        ),
      ],
    );
  }
}