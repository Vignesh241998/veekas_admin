import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veekas_ecommerce_app/features/customer/Shipment%20Tracking/view/shipment_tracking_screen.dart';
import 'package:veekas_ecommerce_app/features/customer/order/view/customer_order_history_screen.dart';

import '../../../Shipment/view/shipment_view_screen.dart';
import '../../../category/model/category_model.dart';
import '../../../product/Modal/product_modal.dart';
import '../../category/viewmodal/customer_category_ viewmodal.dart';

// ============================================================
// PRODUCT IMPORTS
// ============================================================

import '../../product/view/customer_product_detail_screen.dart';
import '../../product/viewmodal/customer_product_viewmodal.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() =>
      _CustomerHomeScreenState();
}

class _CustomerHomeScreenState
    extends ConsumerState<CustomerHomeScreen> {

  // ============================================================
  // SELECTED CATEGORY
  // ============================================================

  int? selectedCategoryId;

  // ============================================================
  // CATEGORY SELECTION
  // ============================================================

  void selectCategory(int? categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final categoryState =
    ref.watch(customerCategoryViewModelProvider);

    final productState =
    ref.watch(customerProductViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      body: SafeArea(
        child: Column(
          children: [

            // ==================================================
            // HEADER
            // ==================================================

            _buildHeader(),

            // ==================================================
            // EVERYTHING BELOW HEADER
            // GETS REMAINING HEIGHT
            // ==================================================

            Expanded(
              child: categoryState.when(

                // =================================================
                // CATEGORY LOADING
                // =================================================

                loading: () =>
                    _buildCategoryLoading(),

                // =================================================
                // CATEGORY ERROR
                // =================================================

                error: (error, stackTrace) =>
                    _buildCategoryError(),

                // =================================================
                // CATEGORY DATA
                // =================================================

                data: (categories) =>
                    _buildCategoryMenus(
                      categories,
                      productState,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      height: 76,

      padding: const EdgeInsets.symmetric(
        horizontal: 28,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [

          // ====================================================
          // LOGO
          // ====================================================

          Row(
            children: [

              Container(
                height: 42,
                width: 42,

                decoration: BoxDecoration(
                  color: const Color(0xFF965DC2),
                  borderRadius:
                  BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.shopping_bag_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              const Text(
                'Veekas',

                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF202124),
                ),
              ),
            ],
          ),

          const SizedBox(width: 45),

          // ====================================================
          // SEARCH
          // ====================================================

          Expanded(
            child: Container(
              height: 44,

              constraints:
              const BoxConstraints(
                maxWidth: 650,
              ),

              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius:
                BorderRadius.circular(12),
              ),

              child: const TextField(
                decoration: InputDecoration(
                  hintText:
                  'Search products...',

                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),

                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey,
                  ),

                  border: InputBorder.none,

                  contentPadding:
                  EdgeInsets.symmetric(
                    vertical: 13,
                  ),
                ),
              ),
            ),
          ),


          const Spacer(),
          _headerIcon(
            Icons.history,
          ),
          const SizedBox(width: 8),

          _headerIcon(
            Icons.notifications_none_rounded,
          ),


          const SizedBox(width: 8),

          _buildCartIcon(),

          const SizedBox(width: 18),

          // ====================================================
          // PROFILE
          // ====================================================

          Row(
            children: [

              Container(
                height: 38,
                width: 38,

                decoration:
                const BoxDecoration(
                  color: Color(0xFFEDE4F5),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.person_outline,
                  color: Color(0xFF965DC2),
                ),
              ),

              const SizedBox(width: 9),

              const Column(
                mainAxisAlignment:
                MainAxisAlignment.center,

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    'Welcome',

                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),

                  Text(
                    'Customer',

                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER ICON
  // ============================================================

  Widget _headerIcon(
      IconData icon,
      ) {
    return InkWell(
      borderRadius:
      BorderRadius.circular(10),

      onTap: (){
        // Navigator.push(context, MaterialPageRoute(builder: (_)=>ShipmentTrackingScreen()));
        Navigator.push(context, MaterialPageRoute(builder: (_)=>CustomerOrderHistoryScreen()));
      },

      child: Container(
        height: 42,
        width: 42,

        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F8),
          borderRadius:
          BorderRadius.circular(10),
        ),

        child: Icon(
          icon,
          size: 21,
          color: const Color(0xFF3F3F46),
        ),
      ),
    );
  }

  // ============================================================
  // CART ICON
  // ============================================================

  Widget _buildCartIcon() {
    return Stack(
      clipBehavior: Clip.none,

      children: [

        _headerIcon(
          Icons.shopping_cart_outlined,
        ),

        Positioned(
          right: -2,
          top: -2,

          child: Container(
            height: 17,
            width: 17,

            decoration:
            const BoxDecoration(
              color: Color(0xFFEF4444),
              shape: BoxShape.circle,
            ),

            child: const Center(
              child: Text(
                '0',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CATEGORY MENUS
  // ============================================================

  Widget _buildCategoryMenus(
      List<CategoryModel> categories,
      AsyncValue<List<ProductModel>>
      productState,
      ) {
    if (categories.isEmpty) {
      return _buildCategoryEmpty();
    }

    return Column(
      children: [

        // ======================================================
        // HORIZONTAL CATEGORY MENU
        // ======================================================

        _buildHorizontalCategories(
          categories,
        ),

        // ======================================================
        // SIDEBAR + PRODUCT AREA
        // ======================================================

        Expanded(
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // =================================================
              // SIDEBAR
              // =================================================

              _buildSidebar(
                categories,
              ),

              // =================================================
              // PRODUCT AREA
              // =================================================

              Expanded(
                child: _buildProductArea(
                  productState,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HORIZONTAL CATEGORIES
  // ============================================================

  Widget _buildHorizontalCategories(
      List<CategoryModel> categories,
      ) {
    return Container(
      height: 62,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 28,
      ),

      decoration:
      const BoxDecoration(
        color: Colors.white,

        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEAEAEA),
          ),
        ),
      ),

      child: ListView.separated(
        scrollDirection:
        Axis.horizontal,

        itemCount:
        categories.length + 1,

        separatorBuilder:
            (_, __) =>
        const SizedBox(
          width: 8,
        ),

        itemBuilder:
            (context, index) {

          // ==================================================
          // ALL
          // ==================================================

          if (index == 0) {
            final isSelected =
                selectedCategoryId == null;

            return _buildHorizontalCategoryItem(
              title: 'All',

              isSelected:
              isSelected,

              onTap: () {
                selectCategory(
                  null,
                );
              },
            );
          }

          // ==================================================
          // CATEGORY
          // ==================================================

          final category =
          categories[index - 1];

          final isSelected =
              selectedCategoryId ==
                  category.id;

          return _buildHorizontalCategoryItem(
            title:
            category.categoryName,

            isSelected:
            isSelected,

            onTap: () {
              selectCategory(
                category.id,
              );
            },
          );
        },
      ),
    );
  }

  // ============================================================
  // HORIZONTAL CATEGORY ITEM
  // ============================================================

  Widget _buildHorizontalCategoryItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Center(
      child: InkWell(
        borderRadius:
        BorderRadius.circular(10),

        onTap: onTap,

        child: AnimatedContainer(
          duration:
          const Duration(
            milliseconds: 200,
          ),

          padding:
          const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),

          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF965DC2)
                : Colors.transparent,

            borderRadius:
            BorderRadius.circular(10),
          ),

          child: Text(
            title,

            style: TextStyle(
              fontSize: 13,

              fontWeight: isSelected
                  ? FontWeight.w700
                  : FontWeight.w500,

              color: isSelected
                  ? Colors.white
                  : const Color(0xFF55555F),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SIDEBAR
  // ============================================================

  Widget _buildSidebar(
      List<CategoryModel> categories,
      ) {
    return Container(
      width: 235,

      margin:
      const EdgeInsets.all(20),

      padding:
      const EdgeInsets.symmetric(
        vertical: 22,
        horizontal: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: const Color(0xFFE8E8EC),
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          // ==================================================
          // TITLE
          // ==================================================

          const Padding(
            padding:
            EdgeInsets.symmetric(
              horizontal: 12,
            ),

            child: Text(
              'CATEGORIES',

              style: TextStyle(
                fontSize: 12,
                fontWeight:
                FontWeight.w800,
                letterSpacing: 1.1,
                color:
                Color(0xFF8A8A93),
              ),
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          // ==================================================
          // ALL
          // ==================================================

          _buildSidebarItem(
            title: 'All',

            isSelected:
            selectedCategoryId ==
                null,

            onTap: () {
              selectCategory(
                null,
              );
            },
          ),

          // ==================================================
          // CATEGORIES
          // ==================================================

          Expanded(
            child: ListView.builder(
              itemCount:
              categories.length,

              itemBuilder:
                  (context, index) {

                final category =
                categories[index];

                return _buildSidebarItem(
                  title:
                  category.categoryName,

                  isSelected:
                  selectedCategoryId ==
                      category.id,

                  onTap: () {
                    selectCategory(
                      category.id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIDEBAR ITEM
  // ============================================================

  Widget _buildSidebarItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 5,
      ),

      child: InkWell(
        borderRadius:
        BorderRadius.circular(10),

        onTap: onTap,

        child: AnimatedContainer(
          duration:
          const Duration(
            milliseconds: 200,
          ),

          padding:
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),

          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFF1E8F8)
                : Colors.transparent,

            borderRadius:
            BorderRadius.circular(10),
          ),

          child: Row(
            children: [

              Container(
                height: 8,
                width: 8,

                decoration:
                BoxDecoration(
                  color: isSelected
                      ? const Color(
                    0xFF965DC2,
                  )
                      : const Color(
                    0xFFD1D1D6,
                  ),

                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Text(
                  title,

                  style: TextStyle(
                    fontSize: 14,

                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,

                    color: isSelected
                        ? const Color(
                      0xFF965DC2,
                    )
                        : const Color(
                      0xFF4B4B54,
                    ),
                  ),
                ),
              ),

              if (isSelected)
                const Icon(
                  Icons
                      .chevron_right_rounded,

                  size: 19,

                  color:
                  Color(0xFF965DC2),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT AREA
  // ============================================================

  Widget _buildProductArea(
      AsyncValue<List<ProductModel>>
      productState,
      ) {
    return productState.when(

      // ========================================================
      // LOADING
      // ========================================================

      loading: () =>
          _buildProductLoading(),

      // ========================================================
      // ERROR
      // ========================================================

      error: (error, stackTrace) =>
          _buildProductError(),

      // ========================================================
      // DATA
      // ========================================================

      data: (products) =>
          _buildProductGrid(
            products,
          ),
    );
  }

  // ============================================================
  // PRODUCT GRID
  // ============================================================
// ============================================================
// PRODUCT GRID
// ============================================================

  Widget _buildProductGrid(
      List<ProductModel> products,
      ) {
    // ==========================================================
    // FILTER PRODUCTS
    // ==========================================================

    List<ProductModel> filteredProducts;

    if (selectedCategoryId == null) {
      // ALL PRODUCTS
      filteredProducts = products;
    } else {
      // SELECTED CATEGORY
      filteredProducts = products.where((product) {
        return product.categoryId.toString() ==
            selectedCategoryId.toString();
      }).toList();
    }

    // ==========================================================
    // DEBUG
    // ==========================================================

    debugPrint(
      'Selected Category ID: $selectedCategoryId',
    );

    debugPrint(
      'Total Products: ${products.length}',
    );

    debugPrint(
      'Filtered Products: ${filteredProducts.length}',
    );

    // ==========================================================
    // EMPTY
    // ==========================================================

    if (filteredProducts.isEmpty) {
      return _buildProductEmpty();
    }

    // ==========================================================
    // PRODUCT GRID
    // ==========================================================

    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        right: 28,
        bottom: 20,
      ),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: const Color(0xFFE8E8EC),
        ),
      ),

      child: GridView.builder(
        padding: EdgeInsets.zero,

        gridDelegate:
        const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 240,
          mainAxisExtent: 320,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
        ),

        itemCount: filteredProducts.length,

        itemBuilder: (context, index) {
          final product =
          filteredProducts[index];

          return InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CustomerProductDetailScreen(
                        product: product,
                      ),
                ),
              );
            },
            child: _buildProductCard(
              product,
            ),
          );
        },
      ),
    );
  }
  // Widget _buildProductGrid(
  //     List<ProductModel> products,
  //     ) {
  //
  //   // ==========================================================
  //   // CATEGORY FILTER
  //   // ==========================================================
  //
  //   final filteredProducts =
  //   selectedCategoryId == null
  //       ? products
  //       : products
  //       .where(
  //         (product) =>
  //     product.categoryId ==
  //         selectedCategoryId,
  //   )
  //       .toList();
  //
  //   // ==========================================================
  //   // EMPTY
  //   // ==========================================================
  //
  //   if (filteredProducts.isEmpty) {
  //     return _buildProductEmpty();
  //   }
  //
  //   // ==========================================================
  //   // GRID
  //   // ==========================================================
  //
  //   return Container(
  //     margin: const EdgeInsets.only(
  //       top: 20,
  //       right: 28,
  //       bottom: 20,
  //     ),
  //
  //     padding:
  //     const EdgeInsets.all(20),
  //
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //
  //       borderRadius:
  //       BorderRadius.circular(16),
  //
  //       border: Border.all(
  //         color: const Color(0xFFE8E8EC),
  //       ),
  //     ),
  //
  //     child: GridView.builder(
  //       padding: EdgeInsets.zero,
  //
  //       gridDelegate:
  //       const SliverGridDelegateWithMaxCrossAxisExtent(
  //         maxCrossAxisExtent: 240,
  //         mainAxisExtent: 320,
  //         crossAxisSpacing: 18,
  //         mainAxisSpacing: 18,
  //       ),
  //
  //       itemCount:
  //       filteredProducts.length,
  //
  //       itemBuilder:
  //           (context, index) {
  //
  //         final product =
  //         filteredProducts[index];
  //
  //         return _buildProductCard(
  //           product,
  //         );
  //       },
  //     ),
  //   );
  // }

  // ============================================================
  // PRODUCT CARD
  // ============================================================

  Widget _buildProductCard(
      ProductModel product,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color:
          const Color(0xFFE8E8EC),
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          // ====================================================
          // PRODUCT IMAGE
          // ====================================================

          Expanded(
            child: Container(
              width: double.infinity,

              decoration: BoxDecoration(
                color:
                const Color(0xFFF7F7F9),

                borderRadius:
                const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),

              child: _buildProductImage(
                product,
              ),
            ),
          ),

          // ====================================================
          // PRODUCT DETAILS
          // ====================================================

          Padding(
            padding:
            const EdgeInsets.all(14),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // BRAND

                Text(
                  product.brandName,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style:
                  const TextStyle(
                    fontSize: 11,
                    color:
                    Color(0xFF8A8A93),
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                // PRODUCT NAME

                Text(
                  product.productName,

                  maxLines: 2,

                  overflow:
                  TextOverflow.ellipsis,

                  style:
                  const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    Color(0xFF25252A),
                  ),
                ),

                const SizedBox(
                  height: 9,
                ),

                // PRICE

                Row(
                  children: [

                    Text(
                      '₹${product.discountPrice.toStringAsFixed(0)}',

                      style:
                      const TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w800,
                        color:
                        Color(0xFF965DC2),
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    if (product.actualPrice >
                        product.discountPrice)
                      Text(
                        '₹${product.actualPrice.toStringAsFixed(0)}',

                        style:
                        const TextStyle(
                          fontSize: 11,
                          color:
                          Colors.grey,
                          decoration:
                          TextDecoration
                              .lineThrough,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCT IMAGE
  // ============================================================

  Widget _buildProductImage(
      ProductModel product,
      ) {
    final imageUrl =
        product.thumbnailImage;

    if (imageUrl == null ||
        imageUrl.isEmpty) {
      return const Center(
        child: Icon(
          Icons.image_outlined,
          size: 45,
          color:
          Color(0xFFD0D0D5),
        ),
      );
    }

    return ClipRRect(
      borderRadius:
      const BorderRadius.vertical(
        top: Radius.circular(14),
      ),

      child: Image.network(
        imageUrl,

        width: double.infinity,
        height: double.infinity,

        fit: BoxFit.contain,

        errorBuilder:
            (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons
                  .broken_image_outlined,
              size: 42,
              color:
              Color(0xFFD0D0D5),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // CATEGORY LOADING
  // ============================================================

  Widget _buildCategoryLoading() {
    return const Center(
      child: SizedBox(
        height: 22,
        width: 22,

        child:
        CircularProgressIndicator(
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY ERROR
  // ============================================================

  Widget _buildCategoryError() {
    return SizedBox(
      height: 62,

      child: Center(
        child: Row(
          mainAxisSize:
          MainAxisSize.min,

          children: [

            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 20,
            ),

            const SizedBox(
              width: 8,
            ),

            const Text(
              'Unable to load categories',

              style: TextStyle(
                fontSize: 13,
              ),
            ),

            const SizedBox(
              width: 10,
            ),

            TextButton(
              onPressed: () {
                ref
                    .read(
                  customerCategoryViewModelProvider
                      .notifier,
                )
                    .refreshCategories();
              },

              child:
              const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY EMPTY
  // ============================================================

  Widget _buildCategoryEmpty() {
    return const Center(
      child: Text(
        'No categories available',

        style: TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT LOADING
  // ============================================================

  Widget _buildProductLoading() {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        right: 28,
        bottom: 20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color:
          const Color(0xFFE8E8EC),
        ),
      ),

      child: const Center(
        child: SizedBox(
          height: 28,
          width: 28,

          child:
          CircularProgressIndicator(
            strokeWidth: 2.5,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT ERROR
  // ============================================================

  Widget _buildProductError() {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        right: 28,
        bottom: 20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color:
          const Color(0xFFE8E8EC),
        ),
      ),

      child: Center(
        child: Column(
          mainAxisSize:
          MainAxisSize.min,

          children: [

            const Icon(
              Icons.error_outline,
              size: 40,
              color: Colors.redAccent,
            ),

            const SizedBox(
              height: 12,
            ),

            const Text(
              'Unable to load products',

              style: TextStyle(
                fontSize: 15,
                fontWeight:
                FontWeight.w600,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            TextButton(
              onPressed: () {
                ref
                    .read(
                  customerProductViewModelProvider
                      .notifier,
                )
                    .refreshProducts();
              },

              child:
              const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT EMPTY
  // ============================================================

  Widget _buildProductEmpty() {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        right: 28,
        bottom: 20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color:
          const Color(0xFFE8E8EC),
        ),
      ),

      child: Center(
        child: Column(
          mainAxisSize:
          MainAxisSize.min,

          children: [

            Container(
              height: 70,
              width: 70,

              decoration:
              const BoxDecoration(
                color:
                Color(0xFFF1E8F8),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 32,
                color:
                Color(0xFF965DC2),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            const Text(
              'No products available',

              style: TextStyle(
                fontSize: 17,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            const Text(
              'There are no products in this category.',

              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}