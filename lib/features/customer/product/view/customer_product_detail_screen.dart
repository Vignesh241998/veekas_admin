import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../product/modal/product_modal.dart';

import '../../../product_image/modal/product_image_modal.dart';
import '../../../product_image/viewmodal/product_view_modal.dart';

import '../../../product_variant/modal/product_variant_modal.dart';
import '../../../product_variant/viewmodal/product_view_modal.dart';
import '../../address/view/customer_checkout_screen.dart';
import '../../cart/model/cart_model.dart';
import '../../cart/view/cart_view_screen.dart';
import '../../cart/viewmodal/cart_view_modal.dart';

class CustomerProductDetailScreen
    extends ConsumerStatefulWidget {
  final ProductModel product;

  const CustomerProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<CustomerProductDetailScreen>
  createState() =>
      _CustomerProductDetailScreenState();
}

class _CustomerProductDetailScreenState
    extends ConsumerState<
        CustomerProductDetailScreen> {

  // ============================================================
  // IMAGE
  // ============================================================

  int selectedImageIndex = 0;

  // ============================================================
  // SELECTED VARIANT VALUES
  // ============================================================

  final Map<String, String>
  selectedAttributes = {};

  // ============================================================
  // SELECTED VARIANT
  // ============================================================

  ProductVariantModel? selectedVariant;

  // ============================================================
  // ADD TO CART LOADING
  // ============================================================

  bool isAddingToCart = false;

  bool isBuyingNow = false;
  // ============================================================
  // INIT
  // ============================================================

 /* @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      // ========================================================
      // LOAD PRODUCT IMAGES
      // ========================================================

      ref
          .read(
        productImageViewModelProvider
            .notifier,
      )
          .getImagesByProduct(
        widget.product.id,
      );

      // ========================================================
      // LOAD PRODUCT VARIANTS
      // ========================================================

      ref
          .read(
        productVariantViewModelProvider
            .notifier,
      )
          .getVariantsByProduct(
        widget.product.id,
      );

      // ========================================================
      // LOAD CART
      // ========================================================

      ref
          .read(
        cartViewModelProvider
            .notifier,
      )
          .getCart();
    });
  }*/
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      // Load product images
      ref
          .read(productImageViewModelProvider.notifier)
          .getImagesByProduct(
        widget.product.id,
      );

      // Load product variants
      ref
          .read(productVariantViewModelProvider.notifier)
          .getVariantsByProduct(
        widget.product.id,
      );

      // Load cart
      ref
          .read(cartViewModelProvider.notifier)
          .getCart();
    });
  }
  // ============================================================
  // BUILD
  // ============================================================

  @override
  @override
  Widget build(BuildContext context) {

    final imageState =
    ref.watch(productImageViewModelProvider);

    final variantState =
    ref.watch(productVariantViewModelProvider);

    // ============================================================
    // CART STATE
    // ============================================================

    final cartState =
    ref.watch(cartViewModelProvider);

    return Scaffold(
      backgroundColor:
      const Color(0xFFF6F7FB),

      body: SafeArea(
        child: Column(
          children: [

            // ==================================================
            // HEADER
            // ==================================================

            _buildHeader(cartState),

            // ==================================================
            // CONTENT
            // ==================================================

            Expanded(
              child: imageState.when(

                loading: () =>
                    _buildLoading(),

                error: (error, stackTrace) =>
                    _buildError(),

                data: (images) =>
                    _buildProductContent(
                      images,
                      variantState,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Widget build(
  //     BuildContext context,
  //     )
  // {
  //   final imageState =
  //   ref.watch(
  //     productImageViewModelProvider,
  //   );
  //
  //   final variantState =
  //   ref.watch(
  //     productVariantViewModelProvider,
  //   );
  //
  //   final cartState =
  //   ref.watch(
  //     cartViewModelProvider,
  //   );
  //
  //   return Scaffold(
  //     backgroundColor:
  //     const Color(0xFFF6F7FB),
  //
  //     body: SafeArea(
  //       child: Column(
  //         children: [
  //
  //           // ==================================================
  //           // HEADER
  //           // ==================================================
  //
  //           _buildHeader(
  //             cartState,
  //           ),
  //
  //           // ==================================================
  //           // CONTENT
  //           // ==================================================
  //
  //           Expanded(
  //             child: imageState.when(
  //               loading: () =>
  //                   _buildLoading(),
  //
  //               error: (
  //                   error,
  //                   stackTrace,
  //                   ) =>
  //                   _buildError(),
  //
  //               data: (images) =>
  //                   _buildProductContent(
  //                     images,
  //                     variantState,
  //                   ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
      AsyncValue<CartResponseModel?> cartState,
      ) {

    int cartCount = 0;

    cartState.whenData((cart) {

      if (cart != null) {
        cartCount = cart.totalItems;
      }

    });

    return Container(
      height: 76,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 28,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.04),

            blurRadius: 10,

            offset:
            const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [

          // ==================================================
          // BACK BUTTON
          // ==================================================

          InkWell(
            borderRadius:
            BorderRadius.circular(10),

            onTap: () {

              Navigator.pop(
                context,
              );

            },

            child: Container(
              height: 42,
              width: 42,

              decoration:
              BoxDecoration(
                color:
                const Color(
                  0xFFF7F7F8,
                ),

                borderRadius:
                BorderRadius.circular(
                  10,
                ),
              ),

              child: const Icon(
                Icons.arrow_back_rounded,
                size: 21,
                color:
                Color(0xFF3F3F46),
              ),
            ),
          ),

          const SizedBox(
            width: 18,
          ),

          // ==================================================
          // TITLE
          // ==================================================

          const Text(
            'Product Details',

            style: TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.w800,
              color:
              Color(0xFF202124),
            ),
          ),

          const Spacer(),

          // ==================================================
          // CART ICON + BADGE
          // ==================================================

          InkWell(
            borderRadius:
            BorderRadius.circular(12),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const CustomerCartScreen(),
                ),
              );
            },

            child: SizedBox(
              width: 48,
              height: 48,

              child: Stack(
                clipBehavior:
                Clip.none,

                children: [

                  // ==========================================
                  // CART ICON
                  // ==========================================

                  Center(
                    child: Container(
                      height: 40,
                      width: 40,

                      decoration:
                      const BoxDecoration(
                        color:
                        Color(0xFFEDE4F5),

                        shape:
                        BoxShape.circle,
                      ),

                      child:
                      const Icon(
                        Icons
                            .shopping_cart_outlined,

                        color:
                        Color(0xFF965DC2),

                        size: 21,
                      ),
                    ),
                  ),

                  // ==========================================
                  // CART BADGE
                  // ==========================================

                  if (cartCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,

                      child:
                      AnimatedSwitcher(

                        duration:
                        const Duration(
                          milliseconds: 250,
                        ),

                        transitionBuilder:
                            (
                            child,
                            animation,
                            ) {

                          return ScaleTransition(
                            scale:
                            animation,
                            child:
                            child,
                          );

                        },

                        child: Container(

                          key:
                          ValueKey<int>(
                            cartCount,
                          ),

                          constraints:
                          const BoxConstraints(
                            minWidth: 19,
                            minHeight: 19,
                          ),

                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 5,
                          ),

                          decoration:
                          const BoxDecoration(
                            color: Colors.red,
                            shape:
                            BoxShape.circle,
                          ),

                          child: Center(
                            child: Text(

                              cartCount > 99
                                  ? '99+'
                                  : cartCount
                                  .toString(),

                              style:
                              const TextStyle(
                                color:
                                Colors.white,

                                fontSize: 10,

                                fontWeight:
                                FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          // ==================================================
          // VEEKAS
          // ==================================================

          Row(
            children: [

              Container(
                height: 38,
                width: 38,

                decoration:
                const BoxDecoration(
                  color:
                  Color(0xFFEDE4F5),

                  shape:
                  BoxShape.circle,
                ),

                child: const Icon(
                  Icons
                      .shopping_bag_outlined,

                  color:
                  Color(0xFF965DC2),
                ),
              ),

              const SizedBox(
                width: 9,
              ),

              const Text(
                'Veekas',

                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCT CONTENT
  // ============================================================

  Widget _buildProductContent(
      List<ProductImageModel> images,
      AsyncValue<List<ProductVariantModel>>
      variantState,
      ) {
    return SingleChildScrollView(
      padding:
      const EdgeInsets.all(28),

      child: Container(
        padding:
        const EdgeInsets.all(28),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
          BorderRadius.circular(18),

          border: Border.all(
            color:
            const Color(0xFFE8E8EC),
          ),
        ),

        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // ==================================================
            // IMAGE
            // ==================================================

            Expanded(
              flex: 5,

              child:
              _buildImageSection(
                images,
              ),
            ),

            const SizedBox(
              width: 45,
            ),

            // ==================================================
            // PRODUCT INFORMATION
            // ==================================================

            Expanded(
              flex: 5,

              child:
              _buildProductInformation(
                variantState,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // IMAGE SECTION
  // ============================================================

  Widget _buildImageSection(
      List<ProductImageModel> images,
      ) {
    return SizedBox(
      height: 430,

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          // ==================================================
          // THUMBNAILS
          // ==================================================

          if (images.isNotEmpty)
            SizedBox(
              width: 82,

              child: ListView.separated(
                scrollDirection:
                Axis.vertical,

                itemCount:
                images.length,

                separatorBuilder:
                    (_, __) =>
                const SizedBox(
                  height: 10,
                ),

                itemBuilder:
                    (context, index) {
                  return _buildThumbnail(
                    images[index],
                    index,
                  );
                },
              ),
            ),

          const SizedBox(
            width: 14,
          ),

          // ==================================================
          // MAIN IMAGE
          // ==================================================

          Expanded(
            child: Container(
              height: 430,
              width: double.infinity,

              decoration:
              BoxDecoration(
                color:
                const Color(
                  0xFFF7F7F9,
                ),

                borderRadius:
                BorderRadius.circular(
                  16,
                ),

                border: Border.all(
                  color:
                  const Color(
                    0xFFE8E8EC,
                  ),
                ),
              ),

              child:
              _buildMainImage(
                images,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MAIN IMAGE
  // ============================================================

  Widget _buildMainImage(
      List<ProductImageModel> images,
      ) {
    if (images.isEmpty) {
      return _buildFallbackImage();
    }

    if (selectedImageIndex >=
        images.length) {
      selectedImageIndex = 0;
    }

    final image =
    images[selectedImageIndex];

    if (image.image == null ||
        image.image!.isEmpty) {
      return _buildFallbackImage();
    }

    return ClipRRect(
      borderRadius:
      BorderRadius.circular(16),

      child: Image.network(
        image.image!,

        width: double.infinity,
        height: double.infinity,

        fit: BoxFit.contain,

        errorBuilder:
            (
            context,
            error,
            stackTrace,
            ) {
          return _buildFallbackImage();
        },
      ),
    );
  }

  // ============================================================
  // THUMBNAIL
  // ============================================================

  Widget _buildThumbnail(
      ProductImageModel image,
      int index,
      ) {
    final isSelected =
        selectedImageIndex == index;

    return InkWell(
      borderRadius:
      BorderRadius.circular(10),

      onTap: () {
        setState(() {
          selectedImageIndex =
              index;
        });
      },

      child: AnimatedContainer(
        duration:
        const Duration(
          milliseconds: 200,
        ),

        height: 78,
        width: 78,

        padding:
        const EdgeInsets.all(3),

        decoration:
        BoxDecoration(
          color: Colors.white,

          borderRadius:
          BorderRadius.circular(10),

          border: Border.all(
            color: isSelected
                ? const Color(
              0xFF965DC2,
            )
                : const Color(
              0xFFE1E1E5,
            ),

            width:
            isSelected ? 2 : 1,
          ),
        ),

        child: ClipRRect(
          borderRadius:
          BorderRadius.circular(7),

          child:
          image.image != null &&
              image.image!
                  .isNotEmpty
              ? Image.network(
            image.image!,
            fit: BoxFit.cover,

            errorBuilder:
                (
                context,
                error,
                stackTrace,
                ) {
              return
                _buildSmallFallback();
            },
          )
              : _buildSmallFallback(),
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT INFORMATION
  // ============================================================

  Widget _buildProductInformation(
      AsyncValue<List<ProductVariantModel>>
      variantState,
      ) {
    final product =
        widget.product;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        // ==================================================
        // BRAND
        // ==================================================

        if (product.brandName.isNotEmpty)
          Text(
            product.brandName
                .toUpperCase(),

            style: const TextStyle(
              fontSize: 12,
              fontWeight:
              FontWeight.w700,
              letterSpacing: 1,
              color:
              Color(0xFF965DC2),
            ),
          ),

        const SizedBox(
          height: 12,
        ),

        // ==================================================
        // PRODUCT NAME
        // ==================================================

        Text(
          product.productName,

          style: const TextStyle(
            fontSize: 28,
            fontWeight:
            FontWeight.w800,
            color:
            Color(0xFF202124),
            height: 1.2,
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        // ==================================================
        // PRODUCT CODE
        // ==================================================

        if (product.productCode.isNotEmpty)
          Text(
            'Product Code: ${product.productCode}',

            style: const TextStyle(
              fontSize: 13,
              color:
              Color(0xFF8A8A93),
            ),
          ),

        const SizedBox(
          height: 24,
        ),

        // ==================================================
        // PRICE
        // ==================================================

        _buildPriceSection(),

        const SizedBox(
          height: 24,
        ),

        const Divider(
          color:
          Color(0xFFEAEAEA),
        ),

        const SizedBox(
          height: 24,
        ),

        // ==================================================
        // CATEGORY
        // ==================================================

        _buildInfoRow(
          'Category',
          product.categoryName,
        ),

        const SizedBox(
          height: 12,
        ),

        if (product.subCategoryName
            .isNotEmpty)
          _buildInfoRow(
            'Sub Category',
            product.subCategoryName,
          ),

        const SizedBox(
          height: 24,
        ),

        // ==================================================
        // DESCRIPTION
        // ==================================================

        const Text(
          'Description',

          style: TextStyle(
            fontSize: 16,
            fontWeight:
            FontWeight.w700,
            color:
            Color(0xFF202124),
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        Text(
          product.description
              .isNotEmpty
              ? product.description
              : 'No description available.',

          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color:
            Color(0xFF6B6B74),
          ),
        ),

        const SizedBox(
          height: 30,
        ),

        // ==================================================
        // VARIANTS
        // ==================================================

        _buildVariantSection(
          variantState,
        ),

        const SizedBox(
          height: 30,
        ),

        // ==================================================
        // ADD TO CART
        // ==================================================

        // _buildAddToCartButton(),
        // ==================================================
// ADD TO CART + BUY NOW
// ==================================================

        _buildActionButtons(),
      ],
    );
  }
// ============================================================
// ACTION BUTTONS
// ============================================================

  Widget _buildActionButtons() {
    return Row(
      children: [

        // ========================================================
        // ADD TO CART
        // ========================================================

        Expanded(
          child: SizedBox(
            height: 52,

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF965DC2),
                elevation: 0,

                side: const BorderSide(
                  color: Color(0xFF965DC2),
                  width: 1.5,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              onPressed: isAddingToCart || isBuyingNow
                  ? null
                  : _addToCart,

              child: isAddingToCart
                  ? const SizedBox(
                height: 21,
                width: 21,

                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFF965DC2),
                ),
              )
                  : const Row(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 19,
                  ),

                  SizedBox(width: 8),

                  Text(
                    'ADD TO CART',

                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        // ========================================================
        // BUY NOW
        // ========================================================

        Expanded(
          child: SizedBox(
            height: 52,

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF965DC2),

                foregroundColor:
                Colors.white,

                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),

              onPressed: isAddingToCart || isBuyingNow
                  ? null
                  : _buyNow,

              child: isBuyingNow
                  ? const SizedBox(
                height: 21,
                width: 21,

                child:
                CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              )
                  : const Row(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.flash_on_rounded,
                    size: 19,
                  ),

                  SizedBox(width: 8),

                  Text(
                    'BUY NOW',

                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  // ============================================================
  // PRICE
  // ============================================================

  Widget _buildPriceSection() {
    final product =
        widget.product;

    double actualPrice =
        product.actualPrice;

    double discountPrice =
        product.discountPrice;

    if (selectedVariant != null) {
      actualPrice =
          selectedVariant!.actualPrice;

      discountPrice =
          selectedVariant!.discountPrice;
    }

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.center,

      children: [

        Text(
          '₹${discountPrice.toStringAsFixed(2)}',

          style: const TextStyle(
            fontSize: 26,
            fontWeight:
            FontWeight.w800,
            color:
            Color(0xFF965DC2),
          ),
        ),

        const SizedBox(
          width: 12,
        ),

        if (actualPrice >
            discountPrice)
          Text(
            '₹${actualPrice.toStringAsFixed(2)}',

            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
              decoration:
              TextDecoration
                  .lineThrough,
            ),
          ),
      ],
    );
  }

  // ============================================================
  // VARIANT SECTION
  // ============================================================

  Widget _buildVariantSection(
      AsyncValue<List<ProductVariantModel>>
      variantState,
      ) {
    return variantState.when(
      loading: () {
        return const Padding(
          padding:
          EdgeInsets.symmetric(
            vertical: 10,
          ),

          child: SizedBox(
            height: 24,
            width: 24,

            child:
            CircularProgressIndicator(
              strokeWidth: 2.5,
            ),
          ),
        );
      },

      error: (
          error,
          stackTrace,
          ) {
        return _buildVariantError();
      },

      data: (variants) {
        final activeVariants =
        variants.where(
              (variant) {
            return variant.status
                .toUpperCase() ==
                'ACTIVE' &&
                variant.stock > 0;
          },
        ).toList();

        if (activeVariants.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildVariantOptions(
          activeVariants,
        );
      },
    );
  }

  // ============================================================
  // UNLIMITED ATTRIBUTE OPTIONS
  // ============================================================

  /*Widget _buildVariantOptions(
      List<ProductVariantModel> variants,
      )
  {
    final Map<String, List<String>>
    attributeGroups = {};

    for (final variant in variants) {
      for (final attribute
      in variant.attributes) {
        final name =
        attribute.attributeName
            .trim();

        final value =
        attribute.attributeValue
            .trim();

        if (name.isEmpty ||
            value.isEmpty) {
          continue;
        }

        attributeGroups.putIfAbsent(
          name,
              () => [],
        );

        if (!attributeGroups[name]!
            .contains(value)) {
          attributeGroups[name]!
              .add(value);
        }
      }
    }

    if (attributeGroups.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        const Text(
          'Select Options',

          style: TextStyle(
            fontSize: 17,
            fontWeight:
            FontWeight.w700,
            color:
            Color(0xFF202124),
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        ...attributeGroups.entries
            .map(
              (entry) {
            return Padding(
              padding:
              const EdgeInsets.only(
                bottom: 20,
              ),

              child:
              _buildAttributeGroup(
                name: entry.key,
                values: entry.value,
                variants: variants,
              ),
            );
          },
        ),

        if (selectedVariant != null)
          _buildSelectedVariantInfo(),
      ],
    );
  }*/
  Widget _buildVariantOptions(
      List<ProductVariantModel> variants,
      ) {
    final Map<String, List<String>> attributeGroups = {};

    // ------------------------------------------------------------
    // BUILD ATTRIBUTE GROUPS
    // ------------------------------------------------------------

    for (final variant in variants) {
      for (final attribute in variant.attributes) {
        final name = attribute.attributeName.trim();
        final value = attribute.attributeValue.trim();

        if (name.isEmpty || value.isEmpty) {
          continue;
        }

        attributeGroups.putIfAbsent(
          name,
              () => [],
        );

        if (!attributeGroups[name]!.contains(value)) {
          attributeGroups[name]!.add(value);
        }
      }
    }

    if (attributeGroups.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          'Select Options',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF202124),
          ),
        ),

        const SizedBox(height: 20),

        ...attributeGroups.entries.map(
              (entry) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: _buildAttributeGroup(
                name: entry.key,
                values: entry.value,
                variants: variants,
              ),
            );
          },
        ),

        // ----------------------------------------------------------
        // EXACT VARIANT FOUND
        // ----------------------------------------------------------

        if (selectedVariant != null)
          _buildSelectedVariantInfo(),
      ],
    );
  }

  bool _isAttributeValueAvailable({
    required String attributeName,
    required String attributeValue,
    required List<ProductVariantModel> variants,
  }) {
    for (final variant in variants) {

      final Map<String, String> variantAttributes = {};

      for (final attribute in variant.attributes) {
        final name = attribute.attributeName.trim();
        final value = attribute.attributeValue.trim();

        if (name.isNotEmpty && value.isNotEmpty) {
          variantAttributes[name] = value;
        }
      }

      // ----------------------------------------------------------
      // THIS OPTION MUST MATCH
      // ----------------------------------------------------------

      if (variantAttributes[attributeName] !=
          attributeValue) {
        continue;
      }

      bool matchesOtherSelections = true;

      // ----------------------------------------------------------
      // CHECK OTHER SELECTED ATTRIBUTES
      // ----------------------------------------------------------

      for (final entry in selectedAttributes.entries) {

        // Don't compare this attribute with itself.
        if (entry.key == attributeName) {
          continue;
        }

        if (variantAttributes[entry.key] !=
            entry.value) {
          matchesOtherSelections = false;
          break;
        }
      }

      if (matchesOtherSelections) {
        return true;
      }
    }

    return false;
  }
  // ============================================================
  // ATTRIBUTE GROUP
  // ============================================================
  Widget _buildAttributeGroup({
    required String name,
    required List<String> values,
    required List<ProductVariantModel> variants,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [

            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3F3F46),
              ),
            ),

            const SizedBox(width: 6),

            const Text(
              '*',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,

          children: values.map(
                (value) {

              final bool isSelected =
                  selectedAttributes[name] == value;

              final bool isAvailable =
              _isAttributeValueAvailable(
                attributeName: name,
                attributeValue: value,
                variants: variants,
              );

              return InkWell(
                borderRadius:
                BorderRadius.circular(9),

                // ------------------------------------------------
                // DISABLE INVALID OPTIONS
                // ------------------------------------------------

                onTap: isAvailable
                    ? () {
                  _selectAttribute(
                    name,
                    value,
                    variants,
                  );
                }
                    : null,

                child: AnimatedContainer(
                  duration:
                  const Duration(
                    milliseconds: 180,
                  ),

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 11,
                  ),

                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(
                      0xFF965DC2,
                    )
                        : isAvailable
                        ? Colors.white
                        : const Color(
                      0xFFF3F3F5,
                    ),

                    borderRadius:
                    BorderRadius.circular(9),

                    border: Border.all(
                      color: isSelected
                          ? const Color(
                        0xFF965DC2,
                      )
                          : isAvailable
                          ? const Color(
                        0xFFDCDCE1,
                      )
                          : const Color(
                        0xFFE7E7EA,
                      ),
                    ),
                  ),

                  child: Text(
                    value,

                    style: TextStyle(
                      fontSize: 13,

                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,

                      color: isSelected
                          ? Colors.white
                          : isAvailable
                          ? const Color(
                        0xFF3F3F46,
                      )
                          : const Color(
                        0xFFB5B5BC,
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
  // Widget _buildAttributeGroup({
  //   required String name,
  //   required List<String> values,
  //   required List<ProductVariantModel>
  //   variants,
  // })
  // {
  //   return Column(
  //     crossAxisAlignment:
  //     CrossAxisAlignment.start,
  //
  //     children: [
  //
  //       Text(
  //         name,
  //
  //         style: const TextStyle(
  //           fontSize: 14,
  //           fontWeight:
  //           FontWeight.w700,
  //           color:
  //           Color(0xFF3F3F46),
  //         ),
  //       ),
  //
  //       const SizedBox(
  //         height: 10,
  //       ),
  //
  //       Wrap(
  //         spacing: 8,
  //         runSpacing: 8,
  //
  //         children: values.map(
  //               (value) {
  //             final isSelected =
  //                 selectedAttributes[
  //                 name] ==
  //                     value;
  //
  //             return InkWell(
  //               borderRadius:
  //               BorderRadius.circular(
  //                 9,
  //               ),
  //
  //               onTap: () {
  //                 _selectAttribute(
  //                   name,
  //                   value,
  //                   variants,
  //                 );
  //               },
  //
  //               child:
  //               AnimatedContainer(
  //                 duration:
  //                 const Duration(
  //                   milliseconds: 180,
  //                 ),
  //
  //                 padding:
  //                 const EdgeInsets
  //                     .symmetric(
  //                   horizontal: 18,
  //                   vertical: 11,
  //                 ),
  //
  //                 decoration:
  //                 BoxDecoration(
  //                   color: isSelected
  //                       ? const Color(
  //                     0xFF965DC2,
  //                   )
  //                       : Colors.white,
  //
  //                   borderRadius:
  //                   BorderRadius.circular(
  //                     9,
  //                   ),
  //
  //                   border: Border.all(
  //                     color: isSelected
  //                         ? const Color(
  //                       0xFF965DC2,
  //                     )
  //                         : const Color(
  //                       0xFFDCDCE1,
  //                     ),
  //                   ),
  //                 ),
  //
  //                 child: Text(
  //                   value,
  //
  //                   style: TextStyle(
  //                     fontSize: 13,
  //
  //                     fontWeight:
  //                     isSelected
  //                         ? FontWeight
  //                         .w700
  //                         : FontWeight
  //                         .w500,
  //
  //                     color: isSelected
  //                         ? Colors.white
  //                         : const Color(
  //                       0xFF3F3F46,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         ).toList(),
  //       ),
  //     ],
  //   );
  // }

  // ============================================================
  // SELECT ATTRIBUTE
  // ============================================================
  void _removeInvalidSelections(
      List<ProductVariantModel> variants,
      ) {
    final Map<String, String> currentSelections =
    Map<String, String>.from(
      selectedAttributes,
    );

    for (final entry in currentSelections.entries) {

      final bool stillValid =
      _isAttributeValueAvailable(
        attributeName: entry.key,
        attributeValue: entry.value,
        variants: variants,
      );

      if (!stillValid) {
        selectedAttributes.remove(
          entry.key,
        );
      }
    }
  }
  void _selectAttribute(
      String name,
      String value,
      List<ProductVariantModel> variants,
      ) {
    setState(() {

      // ----------------------------------------------------------
      // SAME VALUE CLICKED → REMOVE SELECTION
      // ----------------------------------------------------------

      if (selectedAttributes[name] == value) {
        selectedAttributes.remove(name);
      } else {

        // --------------------------------------------------------
        // SELECT NEW VALUE
        // --------------------------------------------------------

        selectedAttributes[name] = value;
      }

      // ----------------------------------------------------------
      // REMOVE INVALID DEPENDENT SELECTIONS
      // ----------------------------------------------------------

      _removeInvalidSelections(
        variants,
      );

      // ----------------------------------------------------------
      // FIND EXACT VARIANT
      // ----------------------------------------------------------

      selectedVariant =
          _findExactVariant(
            variants,
          );
    });
  }

  // ============================================================
  // FIND VARIANT
  // ============================================================

/*  ProductVariantModel?
  _findMatchingVariant(
      List<ProductVariantModel>
      variants,
      )
  {
    if (selectedAttributes.isEmpty) {
      return null;
    }

    for (final variant in variants) {
      final Map<String, String>
      variantAttributes = {};

      for (final attribute
      in variant.attributes) {
        final name =
        attribute.attributeName
            .trim();

        final value =
        attribute.attributeValue
            .trim();

        if (name.isNotEmpty &&
            value.isNotEmpty) {
          variantAttributes[name] =
              value;
        }
      }

      bool matches = true;

      for (final entry
      in selectedAttributes
          .entries) {
        if (variantAttributes[
        entry.key] !=
            entry.value) {
          matches = false;
          break;
        }
      }

      if (matches) {
        return variant;
      }
    }

    return null;
  }*/
  ProductVariantModel? _findExactVariant(
      List<ProductVariantModel> variants,
      ) {
    if (selectedAttributes.isEmpty) {
      return null;
    }

    for (final variant in variants) {

      final Map<String, String> variantAttributes = {};

      for (final attribute in variant.attributes) {
        final name =
        attribute.attributeName.trim();

        final value =
        attribute.attributeValue.trim();

        if (name.isNotEmpty &&
            value.isNotEmpty) {
          variantAttributes[name] = value;
        }
      }

      // ----------------------------------------------------------
      // NUMBER OF ATTRIBUTES MUST MATCH
      // ----------------------------------------------------------

      if (variantAttributes.length !=
          selectedAttributes.length) {
        continue;
      }

      bool exactMatch = true;

      // ----------------------------------------------------------
      // EVERY ATTRIBUTE MUST MATCH
      // ----------------------------------------------------------

      for (final entry
      in selectedAttributes.entries) {

        if (variantAttributes[entry.key] !=
            entry.value) {
          exactMatch = false;
          break;
        }
      }

      if (exactMatch) {
        return variant;
      }
    }

    return null;
  }

  // ============================================================
  // SELECTED VARIANT
  // ============================================================

  Widget _buildSelectedVariantInfo() {
    final variant =
    selectedVariant!;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(14),

      decoration:
      BoxDecoration(
        color:
        const Color(0xFFF8F5FB),

        borderRadius:
        BorderRadius.circular(10),

        border: Border.all(
          color:
          const Color(0xFFE7D9F0),
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          const Text(
            'Selected Variant',

            style: TextStyle(
              fontSize: 13,
              fontWeight:
              FontWeight.w700,
              color:
              Color(0xFF965DC2),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          ...variant.attributes.map(
                (attribute) {
              return Padding(
                padding:
                const EdgeInsets.only(
                  bottom: 5,
                ),

                child: Row(
                  children: [

                    SizedBox(
                      width: 100,

                      child: Text(
                        attribute
                            .attributeName,

                        style:
                        const TextStyle(
                          fontSize: 12,
                          color:
                          Color(
                            0xFF6B6B74,
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Text(
                        attribute
                            .attributeValue,

                        style:
                        const TextStyle(
                          fontSize: 12,
                          fontWeight:
                          FontWeight
                              .w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            'SKU: ${variant.sku}',

            style: const TextStyle(
              fontSize: 12,
              color:
              Color(0xFF6B6B74),
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Text(
            'Stock: ${variant.stock}',

            style: TextStyle(
              fontSize: 12,
              fontWeight:
              FontWeight.w600,

              color: variant.stock > 0
                  ? const Color(
                0xFF16A34A,
              )
                  : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  Future<void> _addToCart() async {
    // ----------------------------------------------------------
    // PRODUCT WITH VARIANT
    // ----------------------------------------------------------

    // if (widget.product.hasVariant) {
    //   if (selectedVariant == null) {
    //     ScaffoldMessenger.of(
    //       context,
    //     ).showSnackBar(
    //       const SnackBar(
    //         content: Text(
    //           'Please select a product variant.',
    //         ),
    //       ),
    //     );
    //
    //     return;
    //   }
    //
    //   if (selectedVariant!.stock <= 0) {
    //     ScaffoldMessenger.of(
    //       context,
    //     ).showSnackBar(
    //       const SnackBar(
    //         content: Text(
    //           'Selected variant is out of stock.',
    //         ),
    //       ),
    //     );
    //
    //     return;
    //   }
    // }
    if (widget.product.hasVariant) {
      if (selectedVariant == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select all product options.',
            ),
          ),
        );

        return;
      }

      if (selectedVariant!.stock <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Selected variant is out of stock.',
            ),
          ),
        );

        return;
      }

      // Continue your existing add-to-cart logic...
    }
    if (isAddingToCart) {
      return;
    }

    setState(() {
      isAddingToCart = true;
    });

    try {
      await ref
          .read(
        cartViewModelProvider
            .notifier,
      )
          .addToCart(
        productId:
        widget.product.id,

        variantId:
        selectedVariant?.id,

        quantity: 1,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Product added to cart successfully.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isAddingToCart = false;
        });
      }
    }
  }
  // ============================================================
// BUY NOW
// ============================================================

  Future<void> _buyNow() async {
    // ----------------------------------------------------------
    // PREVENT DOUBLE CLICK
    // ----------------------------------------------------------

    if (isBuyingNow) {
      return;
    }

    // ----------------------------------------------------------
    // VALIDATE VARIANT
    // ----------------------------------------------------------

    if (widget.product.hasVariant) {
      if (selectedVariant == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select all product options.',
            ),
          ),
        );

        return;
      }

      if (selectedVariant!.stock <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Selected variant is out of stock.',
            ),
          ),
        );

        return;
      }
    }

    setState(() {
      isBuyingNow = true;
    });

    try {
      // ----------------------------------------------------------
      // GET CURRENT PRICE
      // ----------------------------------------------------------

      double price = widget.product.discountPrice;

      if (selectedVariant != null) {
        price = selectedVariant!.discountPrice;
      }

      if (!mounted) {
        return;
      }

      // ----------------------------------------------------------
      // GO DIRECTLY TO CHECKOUT
      // ----------------------------------------------------------

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CustomerCheckoutScreen(
            grandTotal: price,
            totalItems: 1,

            // ----------------------------------------------------
            // OPTIONAL:
            // Add these only if your checkout screen supports them.
            // ----------------------------------------------------

            // isBuyNow: true,
            // productId: widget.product.id,
            // variantId: selectedVariant?.id,
            // quantity: 1,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isBuyingNow = false;
        });
      }
    }
  }

  // ============================================================
  // ADD TO CART BUTTON
  // ============================================================

  Widget _buildAddToCartButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
          const Color(0xFF965DC2),

          foregroundColor:
          Colors.white,

          elevation: 0,

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              12,
            ),
          ),
        ),

        onPressed:
        isAddingToCart
            ? null
            : _addToCart,

        child: isAddingToCart
            ? const SizedBox(
          height: 22,
          width: 22,

          child:
          CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor:
            AlwaysStoppedAnimation<
                Color>(
              Colors.white,
            ),
          ),
        )
            : const Row(
          mainAxisAlignment:
          MainAxisAlignment
              .center,

          children: [

            Icon(
              Icons
                  .shopping_cart_outlined,
              size: 19,
            ),

            SizedBox(
              width: 9,
            ),

            Text(
              'ADD TO CART',

              style: TextStyle(
                fontSize: 14,
                fontWeight:
                FontWeight.w700,
                letterSpacing:
                0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _buildInfoRow(
      String title,
      String value,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        SizedBox(
          width: 105,

          child: Text(
            title,

            style: const TextStyle(
              fontSize: 13,
              color:
              Color(0xFF8A8A93),
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ),

        Expanded(
          child: Text(
            value,

            style: const TextStyle(
              fontSize: 13,
              color:
              Color(0xFF3F3F46),
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // VARIANT ERROR
  // ============================================================

  Widget _buildVariantError() {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(14),

      decoration:
      BoxDecoration(
        color:
        const Color(0xFFFFF5F5),

        borderRadius:
        BorderRadius.circular(10),
      ),

      child: Row(
        children: [

          const Icon(
            Icons.error_outline,
            size: 19,
            color: Colors.red,
          ),

          const SizedBox(
            width: 8,
          ),

          const Expanded(
            child: Text(
              'Unable to load product variants.',

              style: TextStyle(
                fontSize: 13,
                color: Colors.red,
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              ref
                  .read(
                productVariantViewModelProvider
                    .notifier,
              )
                  .getVariantsByProduct(
                widget.product.id,
              );
            },

            child:
            const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FALLBACK IMAGE
  // ============================================================

  Widget _buildFallbackImage() {
    return const Center(
      child: Icon(
        Icons
            .image_not_supported_outlined,

        size: 60,

        color:
        Color(0xFFC8C8CE),
      ),
    );
  }

  // ============================================================
  // SMALL FALLBACK
  // ============================================================

  Widget _buildSmallFallback() {
    return const Center(
      child: Icon(
        Icons
            .image_not_supported_outlined,

        size: 24,

        color:
        Color(0xFFC8C8CE),
      ),
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoading() {
    return const Center(
      child: SizedBox(
        height: 26,
        width: 26,

        child:
        CircularProgressIndicator(
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,

        children: [

          const Icon(
            Icons
                .error_outline_rounded,

            size: 40,

            color: Colors.red,
          ),

          const SizedBox(
            height: 12,
          ),

          const Text(
            'Unable to load product images',

            style: TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          TextButton(
            onPressed: () {
              ref
                  .read(
                productImageViewModelProvider
                    .notifier,
              )
                  .getImagesByProduct(
                widget.product.id,
              );
            },

            child:
            const Text('Retry'),
          ),
        ],
      ),
    );
  }
}