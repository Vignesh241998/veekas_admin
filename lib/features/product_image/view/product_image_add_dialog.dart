import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodal/product_view_modal.dart';


class AddProductImageDialog extends ConsumerStatefulWidget {
  final int productId;

  const AddProductImageDialog({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<AddProductImageDialog> createState() =>
      _AddProductImageDialogState();
}

class _AddProductImageDialogState
    extends ConsumerState<AddProductImageDialog> {
  List<PlatformFile> selectedImages = [];

  bool isLoading = false;

  // ============================================================
  // PICK IMAGES
  // ============================================================

  Future<void> _pickImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
        ],
        allowMultiple: true,
        withData: true,
      );

      if (result == null) {
        return;
      }

      final validImages = result.files.where(
            (file) => file.bytes != null,
      ).toList();

      if (validImages.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select valid image files',
            ),
          ),
        );

        return;
      }

      setState(() {
        selectedImages.addAll(validImages);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to select images: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // REMOVE IMAGE
  // ============================================================

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  // ============================================================
  // ADD PRODUCT IMAGES
  // ============================================================

  Future<void> _addProductImages() async {
    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select at least one image',
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
          .addProductImages(
        productId: widget.productId,
        images: selectedImages,
      );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Product images added successfully',
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

  Widget _buildImagePreview(
      PlatformFile image,
      int index,
      ) {
    return Container(
      width: 120,
      height: 145,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [

          // ==================================================
          // IMAGE
          // ==================================================

          Positioned.fill(
            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(10),
              child: Image.memory(
                image.bytes!,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ==================================================
          // REMOVE BUTTON
          // ==================================================

          Positioned(
            top: 5,
            right: 5,
            child: InkWell(
              onTap: isLoading
                  ? null
                  : () {
                _removeImage(index);
              },
              borderRadius:
              BorderRadius.circular(20),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(
                    alpha: 0.65,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 17,
                ),
              ),
            ),
          ),

          // ==================================================
          // FILE NAME
          // ==================================================

          Positioned(
            left: 6,
            right: 6,
            bottom: 6,
            child: Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: 0.65,
                ),
                borderRadius:
                BorderRadius.circular(5),
              ),
              child: Text(
                image.name,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
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
        'Add Product Images',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SizedBox(
        width: 650,
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
                      'Product ID: ${widget.productId}',
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // CHOOSE IMAGE BUTTON
              // ==================================================

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    'Product Images',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  OutlinedButton.icon(
                    onPressed:
                    isLoading
                        ? null
                        : _pickImages,
                    icon: const Icon(
                      Icons
                          .add_photo_alternate_outlined,
                    ),
                    label: const Text(
                      'Choose Images',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // ==================================================
              // SELECTED IMAGE PREVIEW
              // ==================================================

              if (selectedImages.isEmpty)
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                      Colors.grey.shade300,
                    ),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [

                      Icon(
                        Icons
                            .image_outlined,
                        size: 50,
                        color:
                        Colors.grey.shade400,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        'No images selected',
                        style: TextStyle(
                          color:
                          Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        'JPG, JPEG or PNG',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                          Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(
                    selectedImages.length,
                        (index) {
                      return _buildImagePreview(
                        selectedImages[index],
                        index,
                      );
                    },
                  ),
                ),

              const SizedBox(height: 12),

              if (selectedImages.isNotEmpty)
                Text(
                  '${selectedImages.length} image(s) selected',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                    Colors.grey.shade600,
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
        // ADD IMAGE
        // ========================================================

        ElevatedButton(
          onPressed:
          isLoading
              ? null
              : _addProductImages,
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
            'Add Image',
          ),
        ),
      ],
    );
  }
}