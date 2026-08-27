import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../category/model/category_model.dart';
import '../../category/viewmodel/category_view_model.dart';
import '../ViewModal/sub_category_view_model.dart';

class AddSubCategoryDialog extends ConsumerStatefulWidget {
  const AddSubCategoryDialog({
    super.key,
  });

  @override
  ConsumerState<AddSubCategoryDialog> createState() =>
      _AddSubCategoryDialogState();
}

class _AddSubCategoryDialogState
    extends ConsumerState<AddSubCategoryDialog> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
  TextEditingController();

  int? _selectedCategoryId;

  PlatformFile? _selectedImage;

  bool _isAdding = false;


  @override
  void initState() {
    super.initState();

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
  // ADD SUB CATEGORY
  // ============================================================

  Future<void> _addSubCategory() async {

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
      _isAdding = true;
    });


    try {

      final success =
      await ref
          .read(
        subCategoryViewModelProvider
            .notifier,
      )
          .addSubCategory(

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
              "Sub Category added successfully",
            ),
            backgroundColor: Colors.green,
          ),
        );

      } else {

        setState(() {
          _isAdding = false;
        });

      }

    } catch (e) {

      if (!mounted) {
        return;
      }

      setState(() {
        _isAdding = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Failed to add sub category: $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    final categoryState =
    ref.watch(
      categoryViewModelProvider,
    );


    return AlertDialog(

      title: const Text(
        "Add Sub Category",
      ),

      content: SizedBox(
        width: 450,

        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // =================================================
                // CATEGORY DROPDOWN
                // =================================================

                const Text(
                  "Category",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
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

                  error: (error, stackTrace) {

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
                          icon: const Icon(
                            Icons.refresh,
                          ),
                        ),
                      ],
                    );
                  },

                  data: (categories) {

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

                      onChanged: _isAdding
                          ? null
                          : (value) {

                        setState(() {
                          _selectedCategoryId =
                              value;
                        });
                      },

                      validator: (value) {

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
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                TextFormField(

                  controller:
                  _nameController,

                  enabled: !_isAdding,

                  decoration:
                  const InputDecoration(
                    hintText:
                    "Enter sub category name",
                    border:
                    OutlineInputBorder(),
                  ),

                  validator: (value) {

                    if (value == null ||
                        value.trim().isEmpty) {

                      return "Please enter sub category name";
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
                    fontWeight: FontWeight.w600,
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
                        BorderRadius.circular(8),
                      ),

                      child: _selectedImage !=
                          null &&
                          _selectedImage!
                              .bytes !=
                              null

                          ? ClipRRect(
                        borderRadius:
                        BorderRadius
                            .circular(8),

                        child: Image.memory(
                          _selectedImage!
                              .bytes!,

                          fit: BoxFit.cover,
                        ),
                      )

                          : const Icon(
                        Icons.image,
                        color:
                        Colors.grey,
                        size: 35,
                      ),
                    ),

                    const SizedBox(
                      width: 15,
                    ),

                    OutlinedButton.icon(

                      onPressed:
                      _isAdding
                          ? null
                          : _pickImage,

                      icon: const Icon(
                        Icons.upload,
                      ),

                      label: const Text(
                        "Choose Image",
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

          onPressed: _isAdding
              ? null
              : () {
            Navigator.pop(context);
          },

          child: const Text(
            "Cancel",
          ),
        ),


        // ---------------------------------------------------------
        // ADD
        // ---------------------------------------------------------

        ElevatedButton(

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),

          onPressed:
          _isAdding
              ? null
              : _addSubCategory,

          child: _isAdding

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
            "Add",
          ),
        ),
      ],
    );
  }
}