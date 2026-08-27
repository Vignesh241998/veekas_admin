// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../model/category_model.dart';
// import '../viewmodel/category_view_model.dart';
//
// class EditCategoryDialog extends ConsumerStatefulWidget {
//   final CategoryModel category;
//
//   const EditCategoryDialog({
//     super.key,
//     required this.category,
//   });
//
//   @override
//   ConsumerState<EditCategoryDialog> createState() =>
//       _EditCategoryDialogState();
// }
//
// class _EditCategoryDialogState
//     extends ConsumerState<EditCategoryDialog> {
//   final _formKey = GlobalKey<FormState>();
//
//   late TextEditingController _nameController;
//
//   PlatformFile? _selectedImage;
//
//   bool _loading = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _nameController = TextEditingController(
//       text: widget.category.categoryName,
//     );
//   }
//
//   Future<void> _pickImage() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       withData: true,
//     );
//
//     if (result != null) {
//       setState(() {
//         _selectedImage = result.files.first;
//       });
//     }
//   }
//
//   Future<void> _updateCategory() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() {
//       _loading = true;
//     });
//
//     try {
//       await ref
//           .read(categoryViewModelProvider.notifier)
//           .updateCategory(
//         categoryId: widget.category.id,
//         categoryName: _nameController.text.trim(),
//         image: _selectedImage,
//       );
//
//       if (!mounted) return;
//
//       Navigator.pop(context);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Category Updated Successfully"),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//         ),
//       );
//     }
//
//     setState(() {
//       _loading = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Edit Category"),
//
//       content: SizedBox(
//         width: 450,
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: "Category Name",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return "Enter category name";
//                   }
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 20),
//
//               if (_selectedImage == null)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     widget.category.categoryImage,
//                     height: 120,
//                     errorBuilder: (_, __, ___) {
//                       return const Icon(
//                         Icons.image_not_supported,
//                         size: 80,
//                       );
//                     },
//                   ),
//                 )
//               else
//                 Image.memory(
//                   _selectedImage!.bytes!,
//                   height: 120,
//                 ),
//
//               const SizedBox(height: 20),
//
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton.icon(
//                   onPressed: _pickImage,
//                   icon: const Icon(Icons.image),
//                   label: const Text("Change Image"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//
//       actions: [
//
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text("Cancel"),
//         ),
//
//         ElevatedButton(
//           onPressed: _loading ? null : _updateCategory,
//           child: _loading
//               ? const SizedBox(
//             height: 20,
//             width: 20,
//             child: CircularProgressIndicator(
//               strokeWidth: 2,
//             ),
//           )
//               : const Text("Update"),
//         ),
//
//       ],
//     );
//   }
// }
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/category_model.dart';
import '../viewmodel/category_view_model.dart';

class EditCategoryDialog extends ConsumerStatefulWidget {

  final CategoryModel category;

  const EditCategoryDialog({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<EditCategoryDialog> createState() =>
      _EditCategoryDialogState();
}


class _EditCategoryDialogState
    extends ConsumerState<EditCategoryDialog> {

  // ============================================================
  // FORM
  // ============================================================

  final _formKey = GlobalKey<FormState>();


  // ============================================================
  // CONTROLLER
  // ============================================================

  late TextEditingController _nameController;


  // ============================================================
  // IMAGE
  // ============================================================

  PlatformFile? _selectedImage;


  // ============================================================
  // LOADING
  // ============================================================

  bool _loading = false;


  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.category.categoryName,
    );
  }


  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> _pickImage() async {

    final result =
    await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null) {
      return;
    }

    final file = result.files.first;

    setState(() {
      _selectedImage = file;
    });
  }


  // ============================================================
  // UPDATE CATEGORY
  // ============================================================

  Future<void> _updateCategory() async {

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {

      // Call ViewModel
      await ref
          .read(categoryViewModelProvider.notifier)
          .updateCategory(
        categoryId: widget.category.id,
        categoryName:
        _nameController.text.trim(),
        image: _selectedImage,
      );


      if (!mounted) {
        return;
      }


      // Close dialog
      Navigator.pop(context);


      // Success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Category updated successfully",
          ),
        ),
      );

    } catch (e) {

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }


  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {

    _nameController.dispose();

    super.dispose();
  }


  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text(
        "Edit Category",
      ),

      content: SizedBox(
        width: 450,

        child: Form(
          key: _formKey,

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              // =================================================
              // CATEGORY NAME
              // =================================================

              TextFormField(

                controller: _nameController,

                decoration: const InputDecoration(
                  labelText: "Category Name",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {

                  if (value == null ||
                      value.trim().isEmpty) {

                    return "Enter category name";
                  }

                  return null;
                },
              ),

              const SizedBox(
                height: 20,
              ),


              // =================================================
              // IMAGE PREVIEW
              // =================================================

              if (_selectedImage == null)

                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(8),

                  child: Image.network(

                    widget.category.categoryImage,

                    height: 120,
                    width: 120,

                    fit: BoxFit.cover,

                    errorBuilder:
                        (context, error, stackTrace) {

                      return Container(
                        height: 120,
                        width: 120,

                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius:
                          BorderRadius.circular(8),
                        ),

                        child: const Icon(
                          Icons.image_not_supported,
                          size: 60,
                        ),
                      );
                    },
                  ),
                )

              else

                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(8),

                  child: Image.memory(

                    _selectedImage!.bytes!,

                    height: 120,
                    width: 120,

                    fit: BoxFit.cover,
                  ),
                ),


              const SizedBox(
                height: 20,
              ),


              // =================================================
              // CHANGE IMAGE BUTTON
              // =================================================

              SizedBox(
                width: double.infinity,

                child: OutlinedButton.icon(

                  onPressed:
                  _loading
                      ? null
                      : _pickImage,

                  icon: const Icon(
                    Icons.image,
                  ),

                  label: const Text(
                    "Change Image",
                  ),
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

        // CANCEL
        TextButton(

          onPressed: _loading
              ? null
              : () {
            Navigator.pop(context);
          },

          child: const Text(
            "Cancel",
          ),
        ),


        // UPDATE
        ElevatedButton(

          onPressed:
          _loading
              ? null
              : _updateCategory,

          child: _loading

              ? const SizedBox(
            height: 20,
            width: 20,

            child:
            CircularProgressIndicator(
              strokeWidth: 2,
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
