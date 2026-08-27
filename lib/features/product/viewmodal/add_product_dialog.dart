import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veekas_ecommerce_app/features/product/ViewModal/product_view_modal.dart';
// CATEGORY
import 'package:veekas_ecommerce_app/features/category/model/category_model.dart';
// SUB CATEGORY
import 'package:veekas_ecommerce_app/features/sub_category/Modal/sub_category_modal.dart';

// BRAND
import 'package:veekas_ecommerce_app/features/brand/viewmodal/brand_view_modal.dart';
import 'package:veekas_ecommerce_app/features/brand/Modal/brand_modal.dart';

import '../../category/viewmodel/category_view_model.dart';
import '../../sub_category/ViewModal/sub_category_view_model.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  const AddProductDialog({
    super.key,
  });

  @override
  ConsumerState<AddProductDialog> createState() =>
      _AddProductDialogState();
}

class _AddProductDialogState
    extends ConsumerState<AddProductDialog> {
// ============================================================
// CONTROLLERS
// ============================================================

  final TextEditingController productNameController =
  TextEditingController();

  final TextEditingController descriptionController =
  TextEditingController();

  final TextEditingController actualPriceController =
  TextEditingController();

  final TextEditingController discountPriceController =
  TextEditingController();

  final TextEditingController stockController =
  TextEditingController();

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
// SWITCH VALUES
// ============================================================

  bool isFeatured = false;
  bool isNewArrival = false;
  bool hasVariant = false;

// ============================================================
// LOADING
// ============================================================

  bool isLoading = false;

// ============================================================
// INIT
// ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(categoryViewModelProvider.notifier)
          .getCategories();

      ref
          .read(subCategoryViewModelProvider.notifier)
          .getSubCategories();

      ref
          .read(brandViewModelProvider.notifier)
          .getBrands();
    });
  }

// ============================================================
// DISPOSE
// ============================================================

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
// ADD PRODUCT
// ============================================================

  Future<void> addProduct() async {
// ==========================================================
// VALIDATION
// ==========================================================

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

    if (actualPriceController.text.trim().isEmpty) {
      _showMessage("Please enter actual price");
      return;
    }

    if (discountPriceController.text.trim().isEmpty) {
      _showMessage("Please enter discount price");
      return;
    }

    if (stockController.text.trim().isEmpty) {
      _showMessage("Please enter stock");
      return;
    }

// ==========================================================
// CONVERT VALUES
// ==========================================================

    final double? actualPrice = double.tryParse(
      actualPriceController.text.trim(),
    );

    final double? discountPrice = double.tryParse(
      discountPriceController.text.trim(),
    );

    final int? stock = int.tryParse(
      stockController.text.trim(),
    );

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

// ==========================================================
// START LOADING
// ==========================================================

    setState(() {
      isLoading = true;
    });

    try {
      final success = await ref
          .read(productViewModelProvider.notifier)
          .addProduct(
        categoryId: selectedCategoryId!,
        subCategoryId: selectedSubCategoryId!,
        brandId: selectedBrandId!,
        productName: productNameController.text.trim(),
        description: descriptionController.text.trim(),
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

        _showSuccessMessage(
          "Product Added Successfully",
        );
      }
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        e.toString().replaceFirst(
          'Exception: ',
          '',
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
// MESSAGE
// ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

// ============================================================
// BUILD
// ============================================================

  @override
  Widget build(BuildContext context) {
// ==========================================================
// WATCH PROVIDERS
// ==========================================================

    final categoryState = ref.watch(
      categoryViewModelProvider,
    );

    final subCategoryState = ref.watch(
      subCategoryViewModelProvider,
    );

    final brandState = ref.watch(
      brandViewModelProvider,
    );

// ==========================================================
// CATEGORY LIST
// ==========================================================

    final List<CategoryModel> categories =
        categoryState.value ?? [];

// ==========================================================
// ALL SUB CATEGORY LIST
// ==========================================================

    final List<SubCategoryModel> allSubCategories =
        subCategoryState.value ?? [];

// ==========================================================
// FILTER SUB CATEGORY
// ==========================================================

    final List<SubCategoryModel> filteredSubCategories =
    selectedCategoryId == null
        ? []
        : allSubCategories
        .where(
          (subCategory) =>
      subCategory.categoryId ==
          selectedCategoryId,
    )
        .toList();

// ==========================================================
// BRAND LIST
// ==========================================================

    final List<BrandModel> brands =
        brandState.value ?? [];

    return AlertDialog(
      title: const Text(
        "Add Product",
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

              DropdownButtonFormField<int>(
                value: selectedCategoryId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),

                items: categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(
                      category.categoryName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),

                onChanged: isLoading
                    ? null
                    : (value) {
                  setState(() {
                    selectedCategoryId = value;

// IMPORTANT:
// Reset subcategory when category changes.
                    selectedSubCategoryId = null;
                  });
                },
              ),

              const SizedBox(height: 15),

// ==================================================
// SUB CATEGORY
// ==================================================

              DropdownButtonFormField<int>(
                value: selectedSubCategoryId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: "Sub Category",
                  border: OutlineInputBorder(),
                ),

                items: filteredSubCategories.map((subCategory) {
                  return DropdownMenuItem<int>(
                    value: subCategory.id,
                    child: Text(
                      subCategory.subCategoryName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),

                onChanged: selectedCategoryId == null || isLoading
                    ? null
                    : (value) {
                  setState(() {
                    selectedSubCategoryId = value;
                  });
                },
              ),

              const SizedBox(height: 15),

// ==================================================
// BRAND
// ==================================================

              DropdownButtonFormField<int>(
                value: selectedBrandId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: "Brand",
                  border: OutlineInputBorder(),
                ),

                items: brands.map((brand) {
                  return DropdownMenuItem<int>(
                    value: brand.id,
                    child: Text(
                      brand.brandName,
                      overflow: TextOverflow.ellipsis,
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
                keyboardType: TextInputType.number,
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
                    isLoading ? null : pickImage,
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
                          "No image selected",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

// ==================================================
// FEATURED
// ==================================================

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
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
                contentPadding: EdgeInsets.zero,
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
                contentPadding: EdgeInsets.zero,
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
          onPressed: isLoading ? null : addProduct,
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
            "Add Product",
          ),
        ),
      ],
    );
  }
}
