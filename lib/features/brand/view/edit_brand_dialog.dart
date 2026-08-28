import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modal/brand_modal.dart';
import '../viewmodal/brand_view_modal.dart';


class EditBrandDialog extends ConsumerStatefulWidget {
  final BrandModel brand;

  const EditBrandDialog({
    super.key,
    required this.brand,
  });

  @override
  ConsumerState<EditBrandDialog> createState() =>
      _EditBrandDialogState();
}

class _EditBrandDialogState
    extends ConsumerState<EditBrandDialog> {

  // ============================================================
  // CONTROLLER
  // ============================================================

  late TextEditingController _brandNameController;

  // ============================================================
  // VARIABLES
  // ============================================================

  PlatformFile? _selectedImage;

  bool _isLoading = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _brandNameController =
        TextEditingController(
          text: widget.brand.brandName,
        );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _brandNameController.dispose();
    super.dispose();
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> _pickImage() async {
    try {
      final result =
      await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null &&
          result.files.isNotEmpty) {

        setState(() {
          _selectedImage =
              result.files.first;
        });
      }
    } catch (e) {
      _showError(
        "Unable to select image",
      );
    }
  }

  // ============================================================
  // UPDATE BRAND
  // ============================================================

  Future<void> _updateBrand() async {

    final brandName =
    _brandNameController.text.trim();

    // ----------------------------------------------------------
    // VALIDATION
    // ----------------------------------------------------------

    if (brandName.isEmpty) {
      _showError(
        "Please enter brand name",
      );
      return;
    }

    // ----------------------------------------------------------
    // START LOADING
    // ----------------------------------------------------------

    setState(() {
      _isLoading = true;
    });

    try {

      // --------------------------------------------------------
      // API CALL
      // --------------------------------------------------------

      final success =
      await ref
          .read(
        brandViewModelProvider
            .notifier,
      )
          .updateBrand(
        brandId: widget.brand.id,
        brandName: brandName,
        image: _selectedImage,
      );

      // --------------------------------------------------------
      // SUCCESS
      // --------------------------------------------------------

      if (success) {

        if (!mounted) return;

        Navigator.pop(context);

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Brand updated successfully",
            ),
            backgroundColor:
            Colors.green,
          ),
        );
      }

    } catch (e) {

      // --------------------------------------------------------
      // ERROR
      // --------------------------------------------------------

      if (!mounted) return;

      _showError(
        e.toString(),
      );

    } finally {

      // --------------------------------------------------------
      // STOP LOADING
      // --------------------------------------------------------

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // ERROR
  // ============================================================

  void _showError(
      String message,
      ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {

    return AlertDialog(
      title: const Text(
        "Edit Brand",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SizedBox(
        width: 450,

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // =================================================
              // BRAND NAME
              // =================================================

              const Text(
                "Brand Name",
                style: TextStyle(
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              TextField(
                controller:
                _brandNameController,

                enabled: !_isLoading,

                decoration:
                InputDecoration(
                  hintText:
                  "Enter brand name",

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      8,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // =================================================
              // IMAGE
              // =================================================

              const Text(
                "Brand Image",
                style: TextStyle(
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              GestureDetector(
                onTap: _isLoading
                    ? null
                    : _pickImage,

                child: Container(
                  width: double.infinity,
                  height: 180,

                  decoration:
                  BoxDecoration(
                    border:
                    Border.all(
                      color: Colors.grey,
                    ),

                    borderRadius:
                    BorderRadius.circular(
                      8,
                    ),
                  ),

                  child:
                  _selectedImage != null
                      ? _buildSelectedImage()
                      : _buildExistingImage(),
                ),
              ),
            ],
          ),
        ),
      ),

      // ========================================================
      // BUTTONS
      // ========================================================

      actions: [

        // ------------------------------------------------------
        // CANCEL
        // ------------------------------------------------------

        TextButton(
          onPressed: _isLoading
              ? null
              : () {
            Navigator.pop(
              context,
            );
          },

          child: const Text(
            "Cancel",
          ),
        ),

        // ------------------------------------------------------
        // UPDATE
        // ------------------------------------------------------

        ElevatedButton(
          onPressed: _isLoading
              ? null
              : _updateBrand,

          child: SizedBox(
            width: 90,
            height: 20,

            child: Center(
              child: _isLoading
                  ? const SizedBox(
                width: 18,
                height: 18,

                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Text(
                "Update",
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EXISTING IMAGE
  // ============================================================

  Widget _buildExistingImage() {

    if (widget.brand.brandImage
        .isEmpty) {

      return const Column(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Icon(
            Icons.cloud_upload_outlined,
            size: 45,
            color: Colors.grey,
          ),

          SizedBox(
            height: 10,
          ),

          Text(
            "Click to select image",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [

        // ------------------------------------------------------
        // EXISTING IMAGE
        // ------------------------------------------------------

        Positioned.fill(
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(
              8,
            ),

            child: Image.network(
              widget.brand.brandImage,
              fit: BoxFit.contain,

              errorBuilder:
                  (
                  context,
                  error,
                  stackTrace,
                  ) {
                return const Center(
                  child: Icon(
                    Icons
                        .image_not_supported,
                    color: Colors.red,
                    size: 40,
                  ),
                );
              },
            ),
          ),
        ),

        // ------------------------------------------------------
        // CHANGE IMAGE INDICATOR
        // ------------------------------------------------------

        if (!_isLoading)
          Positioned(
            right: 8,
            bottom: 8,

            child: Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),

              decoration:
              BoxDecoration(
                color: Colors.black
                    .withOpacity(0.65),

                borderRadius:
                BorderRadius.circular(
                  6,
                ),
              ),

              child: const Text(
                "Click to change",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // SELECTED NEW IMAGE
  // ============================================================

  Widget _buildSelectedImage() {

    return Stack(
      children: [

        // ------------------------------------------------------
        // NEW IMAGE
        // ------------------------------------------------------

        Positioned.fill(
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(
              8,
            ),

            child: Image.memory(
              _selectedImage!.bytes!,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // ------------------------------------------------------
        // REMOVE NEW IMAGE
        // ------------------------------------------------------

        if (!_isLoading)
          Positioned(
            top: 8,
            right: 8,

            child: InkWell(
              onTap: () {

                setState(() {
                  _selectedImage =
                  null;
                });
              },

              child: Container(
                width: 32,
                height: 32,

                decoration:
                const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }
}