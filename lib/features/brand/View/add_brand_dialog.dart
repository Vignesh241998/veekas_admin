import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ViewModal/brand_view_modal.dart';


class AddBrandDialog extends ConsumerStatefulWidget {
  const AddBrandDialog({
    super.key,
  });

  @override
  ConsumerState<AddBrandDialog> createState() =>
      _AddBrandDialogState();
}

class _AddBrandDialogState
    extends ConsumerState<AddBrandDialog> {

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController _brandNameController =
  TextEditingController();

  // ============================================================
  // VARIABLES
  // ============================================================

  PlatformFile? _selectedImage;

  bool _isLoading = false;

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
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null &&
          result.files.isNotEmpty) {

        setState(() {
          _selectedImage = result.files.first;
        });
      }
    } catch (e) {
      _showError(
        "Unable to select image",
      );
    }
  }

  // ============================================================
  // ADD BRAND
  // ============================================================

  Future<void> _addBrand() async {

    // ----------------------------------------------------------
    // VALIDATE BRAND NAME
    // ----------------------------------------------------------

    final brandName =
    _brandNameController.text.trim();

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
        brandViewModelProvider.notifier,
      )
          .addBrand(
        brandName: brandName,
        image: _selectedImage,
      );

      // --------------------------------------------------------
      // SUCCESS
      // --------------------------------------------------------

      if (success) {

        if (!mounted) return;

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Brand added successfully",
            ),
            backgroundColor: Colors.green,
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
  // ERROR MESSAGE
  // ============================================================

  void _showError(
      String message,
      ) {

    ScaffoldMessenger.of(context).showSnackBar(
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
        "Add Brand",
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
                  fontWeight: FontWeight.w600,
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
              // IMAGE LABEL
              // =================================================

              const Text(
                "Brand Image",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              // =================================================
              // IMAGE PICKER
              // =================================================

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
                      ? _buildImagePreview()
                      : _buildImagePicker(),
                ),
              ),
            ],
          ),
        ),
      ),

      // ========================================================
      // ACTIONS
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
        // ADD BRAND
        // ------------------------------------------------------

        ElevatedButton(
          onPressed:
          _isLoading
              ? null
              : _addBrand,

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
                "Add Brand",
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // IMAGE PICKER UI
  // ============================================================

  Widget _buildImagePicker() {

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

        SizedBox(
          height: 5,
        ),

        Text(
          "JPG, JPEG or PNG",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // IMAGE PREVIEW
  // ============================================================

  Widget _buildImagePreview() {

    return Stack(
      children: [

        // ------------------------------------------------------
        // IMAGE
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
        // REMOVE IMAGE BUTTON
        // ------------------------------------------------------

        if (!_isLoading)
          Positioned(
            top: 8,
            right: 8,

            child: InkWell(
              onTap: () {

                setState(() {
                  _selectedImage = null;
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