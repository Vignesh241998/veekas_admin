import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../category/model/category_model.dart';
import '../../category/viewmodel/category_view_model.dart';
import '../Modal/sub_category_modal.dart';
import '../ViewModal/sub_category_view_model.dart';


class EditSubCategoryDialog extends ConsumerStatefulWidget {
  final SubCategoryModel subCategory;

  const EditSubCategoryDialog({
    super.key,
    required this.subCategory,
  });

  @override
  ConsumerState<EditSubCategoryDialog> createState() =>
      _EditSubCategoryDialogState();
}

class _EditSubCategoryDialogState
    extends ConsumerState<EditSubCategoryDialog> {

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;

  int? _selectedCategoryId;

  PlatformFile? _selectedImage;

  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();

    // Existing sub category name
    _nameController = TextEditingController(
      text: widget.subCategory.subCategoryName,
    );

    // Existing category
    _selectedCategoryId =
        widget.subCategory.categoryId;

    // Load categories for dropdown
    Future.microtask(() {
      ref
          .read(categoryViewModelProvider.notifier)
          .getCategories();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> _pickImage() async {

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
  }

  // ============================================================
  // UPDATE SUB CATEGORY
  // ============================================================

  Future<void> _updateSubCategory() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryId == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select a category",
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {

      final success =
      await ref
          .read(
        subCategoryViewModelProvider
            .notifier,
      )
          .updateSubCategory(

        subCategoryId:
        widget.subCategory.id,

        categoryId:
        _selectedCategoryId!,

        subCategoryName:
        _nameController.text.trim(),

        image: _selectedImage,
      );

      if (!mounted) {
        return;
      }

      if (success) {

        Navigator.pop(context);

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Sub Category updated successfully",
            ),
            backgroundColor: Colors.green,
          ),
        );

      } else {

        setState(() {
          _isUpdating = false;
        });
      }

    } catch (e) {

      if (!mounted) {
        return;
      }

      setState(() {
        _isUpdating = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Failed to update sub category: $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // EXISTING IMAGE
  // ============================================================

  Widget _buildImagePreview() {

    // New image selected
    if (_selectedImage != null &&
        _selectedImage!.bytes != null) {

      return ClipRRect(
        borderRadius:
        BorderRadius.circular(8),

        child: Image.memory(
          _selectedImage!.bytes!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      );
    }

    // Existing image
    if (widget
        .subCategory
        .subCategoryImage
        .isNotEmpty) {

      return ClipRRect(
        borderRadius:
        BorderRadius.circular(8),

        child: Image.network(
          widget
              .subCategory
              .subCategoryImage,

          width: 80,
          height: 80,

          fit: BoxFit.cover,

          errorBuilder:
              (
              context,
              error,
              stackTrace,
              ) {
            return const Icon(
              Icons.image_not_supported,
              color: Colors.grey,
              size: 35,
            );
          },
        ),
      );
    }

    return const Icon(
      Icons.image,
      color: Colors.grey,
      size: 35,
    );
  }

  @override
  Widget build(BuildContext context) {

    final categoryState =
    ref.watch(
      categoryViewModelProvider,
    );

    return AlertDialog(

      title: const Text(
        "Edit Sub Category",
      ),

      content: SizedBox(
        width: 450,

        child: Form(
          key: _formKey,

          child: SingleChildScrollView(

            child: Column(

              mainAxisSize:
              MainAxisSize.min,

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // =================================================
                // CATEGORY
                // =================================================

                const Text(
                  "Category",
                  style: TextStyle(
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                categoryState.when(

                  loading: () {

                    return const Center(
                      child: Padding(
                        padding:
                        EdgeInsets.all(10),

                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },

                  error: (
                      error,
                      stackTrace,
                      ) {

                    return Row(
                      children: [

                        const Expanded(
                          child: Text(
                            "Unable to load categories",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: () {

                            ref
                                .read(
                              categoryViewModelProvider
                                  .notifier,
                            )
                                .getCategories();
                          },

                          icon:
                          const Icon(
                            Icons.refresh,
                          ),
                        ),
                      ],
                    );
                  },

                  data: (
                      categories,
                      ) {

                    return DropdownButtonFormField<int>(

                      value:
                      _selectedCategoryId,

                      decoration:
                      const InputDecoration(
                        hintText:
                        "Select Category",

                        border:
                        OutlineInputBorder(),
                      ),

                      items: categories
                          .map(
                            (
                            CategoryModel category,
                            ) {

                          return DropdownMenuItem<int>(

                            value:
                            category.id,

                            child: Text(
                              category.categoryName,
                            ),
                          );
                        },
                      )
                          .toList(),

                      onChanged:
                      _isUpdating
                          ? null
                          : (
                          value,
                          ) {

                        setState(() {
                          _selectedCategoryId =
                              value;
                        });
                      },

                      validator: (
                          value,
                          ) {

                        if (value == null) {
                          return "Please select category";
                        }

                        return null;
                      },
                    );
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                // =================================================
                // SUB CATEGORY NAME
                // =================================================

                const Text(
                  "Sub Category Name",
                  style: TextStyle(
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                TextFormField(

                  controller:
                  _nameController,

                  enabled:
                  !_isUpdating,

                  decoration:
                  const InputDecoration(
                    hintText:
                    "Enter sub category name",

                    border:
                    OutlineInputBorder(),
                  ),

                  validator: (
                      value,
                      ) {

                    if (value == null ||
                        value.trim().isEmpty) {

                      return
                        "Please enter sub category name";
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                // =================================================
                // IMAGE
                // =================================================

                const Text(
                  "Sub Category Image",
                  style: TextStyle(
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Row(
                  children: [

                    // Image preview
                    Container(

                      width: 80,
                      height: 80,

                      decoration:
                      BoxDecoration(

                        border:
                        Border.all(
                          color:
                          Colors.grey.shade300,
                        ),

                        borderRadius:
                        BorderRadius.circular(
                          8,
                        ),
                      ),

                      child:
                      _buildImagePreview(),
                    ),

                    const SizedBox(
                      width: 15,
                    ),

                    OutlinedButton.icon(

                      onPressed:
                      _isUpdating
                          ? null
                          : _pickImage,

                      icon: const Icon(
                        Icons.upload,
                      ),

                      label: const Text(
                        "Change Image",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      // ==========================================================
      // ACTIONS
      // ==========================================================

      actions: [

        // ---------------------------------------------------------
        // CANCEL
        // ---------------------------------------------------------

        TextButton(

          onPressed:
          _isUpdating
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

        // ---------------------------------------------------------
        // UPDATE
        // ---------------------------------------------------------

        ElevatedButton(

          style:
          ElevatedButton.styleFrom(
            backgroundColor:
            Colors.blue,

            foregroundColor:
            Colors.white,
          ),

          onPressed:
          _isUpdating
              ? null
              : _updateSubCategory,

          child: _isUpdating

              ? const SizedBox(
            width: 20,
            height: 20,

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
      ],
    );
  }
}