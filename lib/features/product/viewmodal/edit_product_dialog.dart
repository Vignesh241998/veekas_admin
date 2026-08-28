// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:veekas_ecommerce_app/features/product/viewmodal/product_view_modal.dart';
//
// import '../modal/product_modal.dart';
//
// class EditProductDialog extends ConsumerStatefulWidget {
//   final ProductModel product;
//
//   const EditProductDialog({
//     super.key,
//     required this.product,
//   });
//
//   @override
//   ConsumerState<EditProductDialog> createState() =>
//       _EditProductDialogState();
// }
//
// class _EditProductDialogState
//     extends ConsumerState<EditProductDialog> {
//
//   // ============================================================
//   // CONTROLLERS
//   // ============================================================
//
//   late final TextEditingController productNameController;
//
//   late final TextEditingController descriptionController;
//
//   late final TextEditingController actualPriceController;
//
//   late final TextEditingController discountPriceController;
//
//   late final TextEditingController stockController;
//
//
//   // ============================================================
//   // DROPDOWN VALUES
//   // ============================================================
//
//   late int selectedCategoryId;
//
//   late int selectedSubCategoryId;
//
//   late int selectedBrandId;
//
//
//   // ============================================================
//   // IMAGE
//   // ============================================================
//
//   PlatformFile? selectedImage;
//
//
//   // ============================================================
//   // SWITCH VALUES
//   // ============================================================
//
//   late bool isFeatured;
//
//   late bool isNewArrival;
//
//   late bool hasVariant;
//
//
//   // ============================================================
//   // LOADING
//   // ============================================================
//
//   bool isLoading = false;
//
//
//   // ============================================================
//   // INIT
//   // ============================================================
//
//   @override
//   void initState() {
//     super.initState();
//
//     final product = widget.product;
//
//     // ----------------------------------------------------------
//     // Text fields
//     // ----------------------------------------------------------
//
//     productNameController =
//         TextEditingController(
//           text: product.productName,
//         );
//
//     descriptionController =
//         TextEditingController(
//           text: product.description,
//         );
//
//     actualPriceController =
//         TextEditingController(
//           text: product.actualPrice.toString(),
//         );
//
//     discountPriceController =
//         TextEditingController(
//           text: product.discountPrice.toString(),
//         );
//
//     stockController =
//         TextEditingController(
//           text: product.stock.toString(),
//         );
//
//
//     // ----------------------------------------------------------
//     // Dropdowns
//     // ----------------------------------------------------------
//
//     selectedCategoryId =
//         product.categoryId;
//
//     selectedSubCategoryId =
//         product.subCategoryId;
//
//     selectedBrandId =
//         product.brandId;
//
//
//     // ----------------------------------------------------------
//     // Switches
//     // ----------------------------------------------------------
//
//     isFeatured =
//         product.isFeatured;
//
//     isNewArrival =
//         product.isNewArrival;
//
//     hasVariant =
//         product.hasVariant;
//   }
//
//
//   // ============================================================
//   // DISPOSE
//   // ============================================================
//
//   @override
//   void dispose() {
//
//     productNameController.dispose();
//
//     descriptionController.dispose();
//
//     actualPriceController.dispose();
//
//     discountPriceController.dispose();
//
//     stockController.dispose();
//
//     super.dispose();
//   }
//
//
//   // ============================================================
//   // PICK IMAGE
//   // ============================================================
//
//   Future<void> pickImage() async {
//
//     final result =
//     await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       withData: true,
//     );
//
//     if (result != null &&
//         result.files.isNotEmpty) {
//
//       setState(() {
//
//         selectedImage =
//             result.files.first;
//
//       });
//     }
//   }
//
//
//   // ============================================================
//   // UPDATE PRODUCT
//   // ============================================================
//
//   Future<void> updateProduct() async {
//
//     // ----------------------------------------------------------
//     // BASIC VALIDATION
//     // ----------------------------------------------------------
//
//     if (productNameController.text
//         .trim()
//         .isEmpty) {
//
//       _showMessage(
//         "Please enter product name",
//       );
//
//       return;
//     }
//
//
//     if (actualPriceController.text
//         .trim()
//         .isEmpty) {
//
//       _showMessage(
//         "Please enter actual price",
//       );
//
//       return;
//     }
//
//
//     if (discountPriceController.text
//         .trim()
//         .isEmpty) {
//
//       _showMessage(
//         "Please enter discount price",
//       );
//
//       return;
//     }
//
//
//     if (stockController.text
//         .trim()
//         .isEmpty) {
//
//       _showMessage(
//         "Please enter stock",
//       );
//
//       return;
//     }
//
//
//     // ----------------------------------------------------------
//     // CONVERT PRICE
//     // ----------------------------------------------------------
//
//     final double? actualPrice =
//     double.tryParse(
//       actualPriceController.text.trim(),
//     );
//
//     final double? discountPrice =
//     double.tryParse(
//       discountPriceController.text.trim(),
//     );
//
//
//     // ----------------------------------------------------------
//     // CONVERT STOCK
//     // ----------------------------------------------------------
//
//     final int? stock =
//     int.tryParse(
//       stockController.text.trim(),
//     );
//
//
//     if (actualPrice == null) {
//
//       _showMessage(
//         "Enter valid actual price",
//       );
//
//       return;
//     }
//
//
//     if (discountPrice == null) {
//
//       _showMessage(
//         "Enter valid discount price",
//       );
//
//       return;
//     }
//
//
//     if (stock == null) {
//
//       _showMessage(
//         "Enter valid stock",
//       );
//
//       return;
//     }
//
//
//     // ----------------------------------------------------------
//     // START LOADING
//     // ----------------------------------------------------------
//
//     setState(() {
//       isLoading = true;
//     });
//
//
//     try {
//
//       final success =
//       await ref
//           .read(
//         productViewModelProvider
//             .notifier,
//       )
//           .updateProduct(
//
//         // ------------------------------------------------------
//         // PRODUCT ID
//         // ------------------------------------------------------
//
//         productId:
//         widget.product.id,
//
//
//         // ------------------------------------------------------
//         // CATEGORY
//         // ------------------------------------------------------
//
//         categoryId:
//         selectedCategoryId,
//
//
//         // ------------------------------------------------------
//         // SUB CATEGORY
//         // ------------------------------------------------------
//
//         subCategoryId:
//         selectedSubCategoryId,
//
//
//         // ------------------------------------------------------
//         // BRAND
//         // ------------------------------------------------------
//
//         brandId:
//         selectedBrandId,
//
//
//         // ------------------------------------------------------
//         // PRODUCT NAME
//         // ------------------------------------------------------
//
//         productName:
//         productNameController.text.trim(),
//
//
//         // ------------------------------------------------------
//         // DESCRIPTION
//         // ------------------------------------------------------
//
//         description:
//         descriptionController.text.trim(),
//
//
//         // ------------------------------------------------------
//         // PRICES
//         // ------------------------------------------------------
//
//         actualPrice:
//         actualPrice,
//
//         discountPrice:
//         discountPrice,
//
//
//         // ------------------------------------------------------
//         // STOCK
//         // ------------------------------------------------------
//
//         stock:
//         stock,
//
//
//         // ------------------------------------------------------
//         // IMAGE
//         // ------------------------------------------------------
//
//         thumbnailImage:
//         selectedImage,
//
//
//         // ------------------------------------------------------
//         // SWITCHES
//         // ------------------------------------------------------
//
//         isFeatured:
//         isFeatured,
//
//         isNewArrival:
//         isNewArrival,
//
//         hasVariant:
//         hasVariant,
//       );
//
//
//       // --------------------------------------------------------
//       // SUCCESS
//       // --------------------------------------------------------
//
//       if (!mounted) {
//         return;
//       }
//
//
//       if (success) {
//
//         Navigator.pop(context);
//
//         _showSuccessMessage(
//           "Product Updated Successfully",
//         );
//       }
//
//     } catch (e) {
//
//       if (!mounted) {
//         return;
//       }
//
//       _showMessage(
//         e.toString(),
//       );
//
//     } finally {
//
//       if (mounted) {
//
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }
//
//
//   // ============================================================
//   // ERROR MESSAGE
//   // ============================================================
//
//   void _showMessage(
//       String message,
//       ) {
//
//     ScaffoldMessenger.of(context)
//         .showSnackBar(
//       SnackBar(
//         content: Text(message),
//       ),
//     );
//   }
//
//
//   // ============================================================
//   // SUCCESS MESSAGE
//   // ============================================================
//
//   void _showSuccessMessage(
//       String message,
//       ) {
//
//     ScaffoldMessenger.of(context)
//         .showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor:
//         Colors.green,
//       ),
//     );
//   }
//
//
//   // ============================================================
//   // BUILD
//   // ============================================================
//
//   @override
//   Widget build(
//       BuildContext context,
//       ) {
//
//     return AlertDialog(
//
//       // ========================================================
//       // TITLE
//       // ========================================================
//
//       title: const Text(
//         "Edit Product",
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//
//
//       // ========================================================
//       // CONTENT
//       // ========================================================
//
//       content: SizedBox(
//         width: 600,
//
//         child: SingleChildScrollView(
//
//           child: Column(
//             mainAxisSize:
//             MainAxisSize.min,
//
//             children: [
//
//               // ==================================================
//               // PRODUCT CODE
//               // ==================================================
//
//               TextField(
//                 enabled: false,
//
//                 controller:
//                 TextEditingController(
//                   text:
//                   widget.product.productCode,
//                 ),
//
//                 decoration:
//                 const InputDecoration(
//                   labelText:
//                   "Product Code",
//                   border:
//                   OutlineInputBorder(),
//                 ),
//               ),
//
//               const SizedBox(
//                 height: 15,
//               ),
//
//
//               // ==================================================
//               // CATEGORY
//               // ==================================================
//
//               DropdownButtonFormField<int>(
//                 value:
//                 selectedCategoryId,
//
//                 decoration:
//                 const InputDecoration(
//                   labelText:
//                   "Category",
//                   border:
//                   OutlineInputBorder(),
//                 ),
//
//                 items: [
//
//                   DropdownMenuItem<int>(
//                     value:
//                     widget.product.categoryId,
//
//                     child: Text(
//                       widget.product.categoryName,
//                     ),
//                   ),
//                 ],
//
//                 onChanged:
//                 isLoading
//                     ? null
//                     : (value) {
//
//                   if (value ==
//                       null) {
//                     return;
//                   }
//
//                   setState(() {
//
//                     selectedCategoryId =
//                         value;
//
//                   });
//                 },
//               ),
//
//               const SizedBox(
//                 height: 15,
//               ),
//
//
//               // ==================================================
//               // SUB CATEGORY
//               // ==================================================
//
//               DropdownButtonFormField<int>(
//                 value:
//                 selectedSubCategoryId,
//
//                 decoration:
//                 const InputDecoration(
//                   labelText:
//                   "Sub Category",
//                   border:
//                   OutlineInputBorder(),
//                 ),
//
//                 items: [
//
//                   DropdownMenuItem<int>(
//                     value:
//                     widget.product.subCategoryId,
//
//                     child: Text(
//                       widget.product.subCategoryName,
//                     ),
//                   ),
//                 ],
//
//                 onChanged:
//                 isLoading
//                     ? null
//                     : (value) {
//
//                   if (value ==
//                       null) {
//                     return;
//                   }
//
//                   setState(() {
//
//                     selectedSubCategoryId =
//                         value;
//
//                   });
//                 },
//               ),
//
//               const SizedBox(
//                 height: 15,
//               ),
//
//
//               // ==================================================
//               // BRAND
//               // ==================================================
//
//               DropdownButtonFormField<int>(
//                 value:
//                 selectedBrandId,
//
//                 decoration:
//                 const InputDecoration(
//                   labelText:
//                   "Brand",
//                   border:
//                   OutlineInputBorder(),
//                 ),
//
//                 items: [
//
//                   DropdownMenuItem<int>(
//                     value:
//                     widget.product.brandId,
//
//                     child: Text(
//                       widget.product.brandName,
//                     ),
//                   ),
//                 ],
//
//                 onChanged:
//                 isLoading
//                     ? null
//                     : (value) {
//
//                   if (value ==
//                       null) {
//                     return;
//                   }
//
//                   setState(() {
//
//                     selectedBrandId =
//                         value;
//
//                   });
//                 },
//               ),
//
//               const SizedBox(
//                 height: 15,
//               ),
//
//
//               // ==================================================
//               // PRODUCT NAME
//               // ==================================================
//
//               TextField(
//                 controller:
//                 productNameController,
//
//                 enabled:
//                 !isLoading,
//
//                 decoration:
//                 const InputDecoration(
//                   labelText:
//                   "Product Name",
//                   border:
//                   OutlineInputBorder(),
//                 ),
//               ),
//
//               const SizedBox(
//                 height: 15,
//               ),
//
//
//               // ==================================================
//               // DESCRIPTION
//               // ==================================================
//
//               TextField(
//                 controller:
//                 descriptionController,
//
//                 enabled:
//                 !isLoading,
//
//                 maxLines: 4,
//
//                 decoration:
//                 const InputDecoration(
//                   labelText:
//                   "Description",
//                   border:
//                   OutlineInputBorder(),
//                 ),
//               ),
//
//               const SizedBox(
//                 height: 15,
//               ),
//
//
//               // ==================================================
//               // ACTUAL PRICE
//               // ==================================================
//
//               TextField(
//                 controller:
//                 actualPriceController,
//
//                 enabled:
//                 !isLoading,
//
//                 keyboardType:
//                 const TextInputType.numberWithOptions(
//                   decimal: true,
//                 ),
//
//                 decoration:
//                 const InputDecoration(
//                   labelText:
//                   "Actual Price",
//                   prefixText:
//                   "₹ ",
//                   border:
//                   OutlineInputBorder(),
//                 ),
//               ),
//
//               const SizedBox(
//                 height: 15,
//               ),
//
//
//               // ==================================================
//               // DISCOUNT PRICE
//               // ==================================================
//
//               TextField(
//                 controller:
//                 discountPriceController,
//
//                 enabled:
//                 !isLoading,
//
//                 keyboardType:
//                 const TextInputType.numberWithOptions(
//                   decimal: true,
//                 ),
//
//                 decoration:
//                 const InputDecoration(
//                   labelText:
//                   "Discount Price",
//                   prefixText:
//                   "₹ ",
//                   border:
//                   OutlineInputBorder(),
//                 ),
//               ),
//
//               const SizedBox(
//                 height: 15,
//               ),
//
//
//               // ==================================================
//               // STOCK
//               // ==================================================
//
//               TextField(
//                 controller:
//                 stockController,
//
//                 enabled:
//                 !isLoading,
//
//                 keyboardType:
//                 TextInputType.number,
//
//                 decoration:
//                 const InputDecoration(
//                   labelText:
//                   "Stock",
//                   border:
//                   OutlineInputBorder(),
//                 ),
//               ),
//
//               const SizedBox(
//                 height: 20,
//               ),
//
//
//               // ==================================================
//               // CURRENT IMAGE
//               // ==================================================
//
//               if (selectedImage == null &&
//                   widget.product.thumbnailImage !=
//                       null &&
//                   widget.product.thumbnailImage!
//                       .isNotEmpty)
//
//                 Column(
//                   crossAxisAlignment:
//                   CrossAxisAlignment.start,
//
//                   children: [
//
//                     const Text(
//                       "Current Image",
//                       style:
//                       TextStyle(
//                         fontWeight:
//                         FontWeight.bold,
//                       ),
//                     ),
//
//                     const SizedBox(
//                       height: 10,
//                     ),
//
//                     ClipRRect(
//                       borderRadius:
//                       BorderRadius.circular(
//                         8,
//                       ),
//
//                       child:
//                       Image.network(
//                         widget.product
//                             .thumbnailImage!,
//
//                         width: 100,
//
//                         height: 100,
//
//                         fit:
//                         BoxFit.cover,
//
//                         errorBuilder:
//                             (
//                             context,
//                             error,
//                             stackTrace,
//                             ) {
//
//                           return Container(
//                             width: 100,
//                             height: 100,
//
//                             alignment:
//                             Alignment.center,
//
//                             decoration:
//                             BoxDecoration(
//                               border:
//                               Border.all(
//                                 color:
//                                 Colors.grey,
//                               ),
//
//                               borderRadius:
//                               BorderRadius
//                                   .circular(
//                                 8,
//                               ),
//                             ),
//
//                             child:
//                             const Icon(
//                               Icons
//                                   .image_not_supported,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//
//                     const SizedBox(
//                       height: 15,
//                     ),
//                   ],
//                 ),
//
//
//               // ==================================================
//               // NEW IMAGE
//               // ==================================================
//
//               Row(
//                 children: [
//
//                   ElevatedButton.icon(
//
//                     onPressed:
//                     isLoading
//                         ? null
//                         : pickImage,
//
//                     icon:
//                     const Icon(
//                       Icons.image,
//                     ),
//
//                     label:
//                     const Text(
//                       "Choose New Image",
//                     ),
//                   ),
//
//                   const SizedBox(
//                     width: 15,
//                   ),
//
//                   Expanded(
//                     child:
//                     Text(
//                       selectedImage?.name ??
//                           "No new image selected",
//
//                       overflow:
//                       TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(
//                 height: 20,
//               ),
//
//
//               // ==================================================
//               // FEATURED
//               // ==================================================
//
//               SwitchListTile(
//                 contentPadding:
//                 EdgeInsets.zero,
//
//                 title:
//                 const Text(
//                   "Featured Product",
//                 ),
//
//                 value:
//                 isFeatured,
//
//                 onChanged:
//                 isLoading
//                     ? null
//                     : (value) {
//
//                   setState(() {
//
//                     isFeatured =
//                         value;
//
//                   });
//                 },
//               ),
//
//
//               // ==================================================
//               // NEW ARRIVAL
//               // ==================================================
//
//               SwitchListTile(
//                 contentPadding:
//                 EdgeInsets.zero,
//
//                 title:
//                 const Text(
//                   "New Arrival",
//                 ),
//
//                 value:
//                 isNewArrival,
//
//                 onChanged:
//                 isLoading
//                     ? null
//                     : (value) {
//
//                   setState(() {
//
//                     isNewArrival =
//                         value;
//
//                   });
//                 },
//               ),
//
//
//               // ==================================================
//               // HAS VARIANT
//               // ==================================================
//
//               SwitchListTile(
//                 contentPadding:
//                 EdgeInsets.zero,
//
//                 title:
//                 const Text(
//                   "Has Variant",
//                 ),
//
//                 value:
//                 hasVariant,
//
//                 onChanged:
//                 isLoading
//                     ? null
//                     : (value) {
//
//                   setState(() {
//
//                     hasVariant =
//                         value;
//
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//
//
//       // ==========================================================
//       // ACTIONS
//       // ==========================================================
//
//       actions: [
//
//         // --------------------------------------------------------
//         // CANCEL
//         // --------------------------------------------------------
//
//         TextButton(
//
//           onPressed:
//           isLoading
//               ? null
//               : () {
//
//             Navigator.pop(
//               context,
//             );
//           },
//
//           child:
//           const Text(
//             "Cancel",
//           ),
//         ),
//
//
//         // --------------------------------------------------------
//         // UPDATE
//         // --------------------------------------------------------
//
//         ElevatedButton(
//
//           onPressed:
//           isLoading
//               ? null
//               : updateProduct,
//
//           child:
//           isLoading
//
//               ? const SizedBox(
//             width: 20,
//             height: 20,
//
//             child:
//             CircularProgressIndicator(
//               strokeWidth: 2,
//               color:
//               Colors.white,
//             ),
//           )
//
//               : const Text(
//             "Update Product",
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veekas_ecommerce_app/features/product/viewmodal/product_view_modal.dart';

import '../../brand/viewmodal/brand_view_modal.dart';
import '../../category/viewmodel/category_view_model.dart';
import '../../sub_category/viewmodal/sub_category_view_model.dart';
import '../modal/product_modal.dart';

class EditProductDialog extends ConsumerStatefulWidget {
  final ProductModel product;

  const EditProductDialog({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<EditProductDialog> createState() =>
      _EditProductDialogState();
}

class _EditProductDialogState
    extends ConsumerState<EditProductDialog> {

  // ============================================================
  // CONTROLLERS
  // ============================================================

  late final TextEditingController productNameController;
  late final TextEditingController descriptionController;
  late final TextEditingController actualPriceController;
  late final TextEditingController discountPriceController;
  late final TextEditingController stockController;

  // ============================================================
  // DROPDOWN VALUES
  // ============================================================

  int? selectedCategoryId;
  int? selectedSubCategoryId;
  int? selectedBrandId;

  // ============================================================
  // IMAGE
  // ============================================================

  PlatformFile? selectedImage;

  // ============================================================
  // SWITCHES
  // ============================================================

  late bool isFeatured;
  late bool isNewArrival;
  late bool hasVariant;

  // ============================================================
  // LOADING
  // ============================================================

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Existing product values
    selectedCategoryId = widget.product.categoryId;
    selectedSubCategoryId = widget.product.subCategoryId;
    selectedBrandId = widget.product.brandId;

    productNameController =
        TextEditingController(text: widget.product.productName);

    descriptionController =
        TextEditingController(text: widget.product.description);

    actualPriceController =
        TextEditingController(
          text: widget.product.actualPrice.toString(),
        );

    discountPriceController =
        TextEditingController(
          text: widget.product.discountPrice.toString(),
        );

    stockController =
        TextEditingController(
          text: widget.product.stock.toString(),
        );

    isFeatured = widget.product.isFeatured;
    isNewArrival = widget.product.isNewArrival;
    hasVariant = widget.product.hasVariant;
  }

  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    actualPriceController.dispose();
    discountPriceController.dispose();
    stockController.dispose();

    super.dispose();
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedImage = result.files.first;
      });
    }
  }

  // ============================================================
  // UPDATE PRODUCT
  // ============================================================

  Future<void> updateProduct() async {

    if (selectedCategoryId == null) {
      _showMessage("Please select category");
      return;
    }

    if (selectedSubCategoryId == null) {
      _showMessage("Please select sub category");
      return;
    }

    if (selectedBrandId == null) {
      _showMessage("Please select brand");
      return;
    }

    if (productNameController.text.trim().isEmpty) {
      _showMessage("Please enter product name");
      return;
    }

    final double? actualPrice =
    double.tryParse(actualPriceController.text.trim());

    final double? discountPrice =
    double.tryParse(discountPriceController.text.trim());

    final int? stock =
    int.tryParse(stockController.text.trim());

    if (actualPrice == null) {
      _showMessage("Enter valid actual price");
      return;
    }

    if (discountPrice == null) {
      _showMessage("Enter valid discount price");
      return;
    }

    if (stock == null) {
      _showMessage("Enter valid stock");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final success =
      await ref
          .read(productViewModelProvider.notifier)
          .updateProduct(

        productId: widget.product.id,

        categoryId: selectedCategoryId!,

        subCategoryId: selectedSubCategoryId!,

        brandId: selectedBrandId!,

        productName:
        productNameController.text.trim(),

        description:
        descriptionController.text.trim(),

        actualPrice: actualPrice,

        discountPrice: discountPrice,

        stock: stock,

        thumbnailImage: selectedImage,

        isFeatured: isFeatured,

        isNewArrival: isNewArrival,

        hasVariant: hasVariant,
      );

      if (!mounted) return;

      if (success) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Product Updated Successfully",
            ),
            backgroundColor: Colors.green,
          ),
        );
      }

    } catch (e) {

      if (!mounted) return;

      _showMessage(e.toString());

    } finally {

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {

    // ==========================================================
    // WATCH ALL DATA
    // ==========================================================

    final categoryState =
    ref.watch(categoryViewModelProvider);

    final subCategoryState =
    ref.watch(subCategoryViewModelProvider);

    final brandState =
    ref.watch(brandViewModelProvider);

    return AlertDialog(

      title: const Text(
        "Edit Product",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      content: SizedBox(
        width: 600,

        child: SingleChildScrollView(

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ==================================================
              // CATEGORY
              // ==================================================

              categoryState.when(

                // loading: () => const LinearProgressIndicator(),
                loading: () => const SizedBox.shrink(),
                error: (error, _) => Text(
                  error.toString(),
                ),

                data: (categories) {

                  return DropdownButtonFormField<int>(

                    value: categories.any(
                          (category) =>
                      category.id == selectedCategoryId,
                    )
                        ? selectedCategoryId
                        : null,

                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),

                    items: categories.map((category) {

                      return DropdownMenuItem<int>(
                        value: category.id,

                        child: Text(
                          category.categoryName,
                        ),
                      );

                    }).toList(),

                    onChanged: isLoading
                        ? null
                        : (value) {

                      setState(() {

                        selectedCategoryId = value;

                        // Important:
                        // reset subcategory when category changes
                        selectedSubCategoryId = null;

                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 15),

              // ==================================================
              // SUB CATEGORY
              // ==================================================

              subCategoryState.when(

                // loading: () => const LinearProgressIndicator(),
                loading: () => const SizedBox.shrink(),
                error: (error, _) => Text(
                  error.toString(),
                ),

                data: (subCategories) {

                  // Only subcategories belonging
                  // to selected category
                  final filteredSubCategories =
                  subCategories
                      .where(
                        (subCategory) =>
                    subCategory.categoryId ==
                        selectedCategoryId,
                  )
                      .toList();

                  return DropdownButtonFormField<int>(

                    value: filteredSubCategories.any(
                          (subCategory) =>
                      subCategory.id ==
                          selectedSubCategoryId,
                    )
                        ? selectedSubCategoryId
                        : null,

                    decoration: const InputDecoration(
                      labelText: "Sub Category",
                      border: OutlineInputBorder(),
                    ),

                    items:
                    filteredSubCategories.map(
                          (subCategory) {

                        return DropdownMenuItem<int>(
                          value: subCategory.id,

                          child: Text(
                            subCategory.subCategoryName,
                          ),
                        );

                      },
                    ).toList(),

                    onChanged:
                    selectedCategoryId == null ||
                        isLoading
                        ? null
                        : (value) {

                      setState(() {

                        selectedSubCategoryId =
                            value;

                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 15),

              // ==================================================
              // BRAND
              // ==================================================

              brandState.when(

                // loading: () => const LinearProgressIndicator(),
                loading: () => const SizedBox.shrink(),
                error: (error, _) => Text(
                  error.toString(),
                ),

                data: (brands) {

                  return DropdownButtonFormField<int>(

                    value: brands.any(
                          (brand) =>
                      brand.id == selectedBrandId,
                    )
                        ? selectedBrandId
                        : null,

                    decoration: const InputDecoration(
                      labelText: "Brand",
                      border: OutlineInputBorder(),
                    ),

                    items: brands.map((brand) {

                      return DropdownMenuItem<int>(
                        value: brand.id,

                        child: Text(
                          brand.brandName,
                        ),
                      );

                    }).toList(),

                    onChanged: isLoading
                        ? null
                        : (value) {

                      setState(() {

                        selectedBrandId = value;

                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 15),

              // ==================================================
              // PRODUCT NAME
              // ==================================================

              TextField(
                controller: productNameController,
                enabled: !isLoading,

                decoration: const InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // ==================================================
              // DESCRIPTION
              // ==================================================

              TextField(
                controller: descriptionController,
                enabled: !isLoading,
                maxLines: 4,

                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // ==================================================
              // ACTUAL PRICE
              // ==================================================

              TextField(
                controller: actualPriceController,
                enabled: !isLoading,

                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),

                decoration: const InputDecoration(
                  labelText: "Actual Price",
                  prefixText: "₹ ",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // ==================================================
              // DISCOUNT PRICE
              // ==================================================

              TextField(
                controller: discountPriceController,
                enabled: !isLoading,

                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),

                decoration: const InputDecoration(
                  labelText: "Discount Price",
                  prefixText: "₹ ",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // ==================================================
              // STOCK
              // ==================================================

              TextField(
                controller: stockController,
                enabled: !isLoading,

                keyboardType:
                TextInputType.number,

                decoration: const InputDecoration(
                  labelText: "Stock",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // IMAGE
              // ==================================================

              Row(
                children: [

                  ElevatedButton.icon(
                    onPressed:
                    isLoading
                        ? null
                        : pickImage,

                    icon: const Icon(
                      Icons.image,
                    ),

                    label: const Text(
                      "Choose Image",
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Text(
                      selectedImage?.name ??
                          "Current image will be kept",

                      overflow:
                      TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ==================================================
              // FEATURED
              // ==================================================

              SwitchListTile(
                contentPadding:
                EdgeInsets.zero,

                title: const Text(
                  "Featured Product",
                ),

                value: isFeatured,

                onChanged: isLoading
                    ? null
                    : (value) {

                  setState(() {
                    isFeatured = value;
                  });
                },
              ),

              // ==================================================
              // NEW ARRIVAL
              // ==================================================

              SwitchListTile(
                contentPadding:
                EdgeInsets.zero,

                title: const Text(
                  "New Arrival",
                ),

                value: isNewArrival,

                onChanged: isLoading
                    ? null
                    : (value) {

                  setState(() {
                    isNewArrival = value;
                  });
                },
              ),

              // ==================================================
              // HAS VARIANT
              // ==================================================

              SwitchListTile(
                contentPadding:
                EdgeInsets.zero,

                title: const Text(
                  "Has Variant",
                ),

                value: hasVariant,

                onChanged: isLoading
                    ? null
                    : (value) {

                  setState(() {
                    hasVariant = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),

      // ==========================================================
      // ACTIONS
      // ==========================================================

      actions: [

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

        ElevatedButton(
          onPressed:
          isLoading
              ? null
              : updateProduct,

          child: isLoading

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
            "Update Product",
          ),
        ),
      ],
    );
  }
}