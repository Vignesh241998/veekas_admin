import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Address/view/customer_checkout_screen.dart';
import '../viewmodal/cart_view_modal.dart';
import '../model/cart_model.dart';

class CustomerCartScreen extends ConsumerStatefulWidget {
  const CustomerCartScreen({
    super.key,
  });

  @override
  ConsumerState<CustomerCartScreen> createState() =>
      _CustomerCartScreenState();
}

class _CustomerCartScreenState
    extends ConsumerState<CustomerCartScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(cartViewModelProvider.notifier).getCart();
    });
  }

  // ============================================================
  // UPDATE QUANTITY
  // ============================================================

  Future<void> _updateQuantity(
      CartModel item,
      int quantity,
      ) async {
    if (quantity < 1) {
      return;
    }

    try {
      await ref
          .read(cartViewModelProvider.notifier)
          .updateCart(
        cartId: item.cartId,
        quantity: quantity,
      );
    } catch (e) {
      if (!mounted) return;

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
  // DELETE CONFIRMATION DIALOG
  // ============================================================
  Future<bool> _showDeleteConfirmation(
      BuildContext context,
      ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            16,
          ),
          titlePadding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            4,
          ),

          title: Row(
            children: const [
              Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
                size: 23,
              ),
              SizedBox(width: 9),
              Text(
                'Remove Item?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          content: const Text(
            'Do you want to remove this item from your cart?',
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF666666),
            ),
          ),

          actionsPadding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            12,
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 4),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: const Text(
                'Remove',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
  Future<void> _confirmRemoveItem(
      CartModel item,
      ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // ==================================================
                // ICON
                // ==================================================

                Container(
                  height: 64,
                  width: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEEEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFF04444),
                    size: 32,
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // TITLE
                // ==================================================

                const Text(
                  'Remove Item?',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF29292E),
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // MESSAGE
                // ==================================================

                Text(
                  'Are you sure you want to remove\n'
                      '"${item.productName}" from your cart?',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF85858D),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 26),

                // ==================================================
                // BUTTONS
                // ==================================================

                Row(
                  children: [

                    // CANCEL
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(
                              dialogContext,
                              false,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                            const Color(0xFF55555D),
                            side: const BorderSide(
                              color: Color(0xFFE1E1E6),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(11),
                            ),
                          ),
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // REMOVE
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                              dialogContext,
                              true,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFFF04444),
                            foregroundColor:
                            Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(11),
                            ),
                          ),
                          child: const Text(
                            'REMOVE',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    // User cancelled
    if (confirmed != true) {
      return;
    }

    await _removeItem(item);
  }

  // ============================================================
  // REMOVE ITEM
  // ============================================================

  Future<void> _removeItem(
      CartModel item,
      ) async {
    try {
      await ref
          .read(cartViewModelProvider.notifier)
          .deleteCart(item.cartId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Item removed from cart',
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

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
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final cartState =
    ref.watch(cartViewModelProvider);

    return Scaffold(
      backgroundColor:
      const Color(0xFFF6F7FB),

      body: cartState.when(

        // ======================================================
        // LOADING
        // ======================================================

        loading: () {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF965DC2),
            ),
          );
        },

        // ======================================================
        // ERROR
        // ======================================================

        error: (error, stack) {
          return _buildError(
            error.toString(),
          );
        },

        // ======================================================
        // DATA
        // ======================================================

        data: (cart) {
          if (cart == null ||
              cart.items.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [

              _buildHeader(
                cart.totalItems,
              ),

              Expanded(
                child: LayoutBuilder(
                  builder:
                      (context, constraints) {

                    final isSmall =
                        constraints.maxWidth < 900;

                    if (isSmall) {
                      return SingleChildScrollView(
                        padding:
                        const EdgeInsets.all(24),
                        child: Column(
                          children: [

                            _buildCartItems(
                              cart.items,
                            ),

                            const SizedBox(
                              height: 24,
                            ),

                            _buildOrderSummary(
                              cart,
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding:
                      const EdgeInsets.fromLTRB(
                        32,
                        28,
                        32,
                        40,
                      ),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Expanded(
                            flex: 7,
                            child: _buildCartItems(
                              cart.items,
                            ),
                          ),

                          const SizedBox(
                            width: 28,
                          ),

                          SizedBox(
                            width: 380,
                            child:
                            _buildOrderSummary(
                              cart,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
      int totalItems,
      ) {
    return Container(
      height: 76,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      decoration:
      const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [

          InkWell(
            borderRadius:
            BorderRadius.circular(12),
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 44,
              width: 44,
              decoration:
              BoxDecoration(
                color:
                const Color(0xFFF7F7F9),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color:
                Color(0xFF303038),
                size: 22,
              ),
            ),
          ),

          const SizedBox(width: 18),

          const Text(
            'My Cart',
            style: TextStyle(
              fontSize: 22,
              fontWeight:
              FontWeight.w800,
              color:
              Color(0xFF202124),
            ),
          ),

          const SizedBox(width: 12),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration:
            BoxDecoration(
              color:
              const Color(0xFFF0E5F7),
              borderRadius:
              BorderRadius.circular(20),
            ),
            child: Text(
              '$totalItems Items',
              style: const TextStyle(
                fontSize: 12,
                fontWeight:
                FontWeight.w800,
                color:
                Color(0xFF965DC2),
              ),
            ),
          ),

          const Spacer(),

          Row(
            children: [

              Container(
                height: 42,
                width: 42,
                decoration:
                const BoxDecoration(
                  color:
                  Color(0xFFF0E5F7),
                  shape:
                  BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color:
                  Color(0xFF965DC2),
                  size: 22,
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                'Veekas',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                  FontWeight.w800,
                  color:
                  Color(0xFF29292E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CART ITEMS
  // ============================================================

  Widget _buildCartItems(
      List<CartModel> items,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [

        const Text(
          'Cart Items',
          style: TextStyle(
            fontSize: 19,
            fontWeight:
            FontWeight.w800,
            color:
            Color(0xFF29292E),
          ),
        ),

        const SizedBox(height: 16),

        ...items.map(
              (item) => Padding(
            padding:
            const EdgeInsets.only(
              bottom: 16,
            ),
            child:
            _buildCartItem(item),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CART ITEM
  // ============================================================

  Widget _buildCartItem(
      CartModel item,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(20),
      decoration:
      BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border:
        Border.all(
          color:
          const Color(0xFFE8E8ED),
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.center,
        children: [

          _buildProductImage(
            item.thumbnailImage,
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  item.brand.toUpperCase(),
                  style:
                  const TextStyle(
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w800,
                    color:
                    Color(0xFF965DC2),
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  item.productName,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  const TextStyle(
                    fontSize: 17,
                    fontWeight:
                    FontWeight.w800,
                    color:
                    Color(0xFF27272A),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Code: ${item.productCode}',
                  style:
                  const TextStyle(
                    fontSize: 12,
                    color:
                    Color(0xFF96969E),
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                if (item.variant != null &&
                    item.variant!.attributes.isNotEmpty)
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: item
                        .variant!
                        .attributes
                        .map(
                          (attribute) =>
                          _buildAttributeChip(
                            attribute.attributeName,
                            attribute.attributeValue,
                          ),
                    )
                        .toList(),
                  ),

                const SizedBox(height: 14),

                Text(
                  '₹${item.price.toStringAsFixed(2)}',
                  style:
                  const TextStyle(
                    fontSize: 19,
                    fontWeight:
                    FontWeight.w800,
                    color:
                    Color(0xFF965DC2),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [

              // ==================================================
              // DELETE WITH CONFIRMATION
              // ==================================================

              InkWell(
                borderRadius:
                BorderRadius.circular(10),
                onTap: () async{
                  final confirmed =
                      await _showDeleteConfirmation(context);

                  if (!confirmed || !mounted) {
                    return;
                  }

                  await ref
                      .read(cartViewModelProvider.notifier)
                      .deleteCart(item.cartId);
                  // _confirmRemoveItem(item);
                },
                child: Container(
                  height: 38,
                  width: 38,
                  decoration:
                  BoxDecoration(
                    color:
                    const Color(0xFFFFF0F0),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color:
                    Color(0xFFF04444),
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              _buildQuantityControl(
                item,
              ),

              const SizedBox(height: 18),

              Text(
                '₹${item.totalPrice.toStringAsFixed(2)}',
                style:
                const TextStyle(
                  fontSize: 17,
                  fontWeight:
                  FontWeight.w800,
                  color:
                  Color(0xFF27272A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCT IMAGE
  // ============================================================

  Widget _buildProductImage(
      String? imageUrl,
      ) {
    return Container(
      height: 136,
      width: 136,
      padding:
      const EdgeInsets.all(8),
      decoration:
      BoxDecoration(
        color:
        const Color(0xFFF9F9FB),
        borderRadius:
        BorderRadius.circular(15),
        border:
        Border.all(
          color:
          const Color(0xFFE7E7EC),
        ),
      ),
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(11),
        child:
        imageUrl != null &&
            imageUrl.isNotEmpty
            ? Image.network(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder:
              (
              context,
              error,
              stackTrace,
              ) {
            return _imagePlaceholder();
          },
        )
            : _imagePlaceholder(),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return const Center(
      child: Icon(
        Icons.image_outlined,
        size: 42,
        color:
        Color(0xFFB5B5BD),
      ),
    );
  }

  // ============================================================
  // ATTRIBUTE CHIP
  // ============================================================

  Widget _buildAttributeChip(
      String name,
      String value,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration:
      BoxDecoration(
        color:
        const Color(0xFFF8F5FA),
        borderRadius:
        BorderRadius.circular(7),
      ),
      child: RichText(
        text: TextSpan(
          children: [

            TextSpan(
              text: '$name: ',
              style:
              const TextStyle(
                fontSize: 11,
                fontWeight:
                FontWeight.w600,
                color:
                Color(0xFF77727C),
              ),
            ),

            TextSpan(
              text: value,
              style:
              const TextStyle(
                fontSize: 11,
                fontWeight:
                FontWeight.w800,
                color:
                Color(0xFF68616F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // QUANTITY CONTROL
  // ============================================================

  Widget _buildQuantityControl(
      CartModel item,
      ) {
    return Container(
      height: 42,
      decoration:
      BoxDecoration(
        color:
        const Color(0xFFF8F8FA),
        borderRadius:
        BorderRadius.circular(11),
        border:
        Border.all(
          color:
          const Color(0xFFE3E3E8),
        ),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [

          InkWell(
            onTap: item.quantity > 1
                ? () {
              _updateQuantity(
                item,
                item.quantity - 1,
              );
            }
                : null,
            child: SizedBox(
              width: 40,
              height: 42,
              child: Icon(
                Icons.remove_rounded,
                size: 18,
                color: item.quantity > 1
                    ? const Color(0xFF55555D)
                    : const Color(0xFFBDBDC3),
              ),
            ),
          ),

          Container(
            constraints:
            const BoxConstraints(
              minWidth: 34,
            ),
            alignment:
            Alignment.center,
            child: Text(
              item.quantity.toString(),
              style:
              const TextStyle(
                fontSize: 14,
                fontWeight:
                FontWeight.w800,
                color:
                Color(0xFF303038),
              ),
            ),
          ),

          InkWell(
            onTap: () {
              _updateQuantity(
                item,
                item.quantity + 1,
              );
            },
            child: const SizedBox(
              width: 40,
              height: 42,
              child: Icon(
                Icons.add_rounded,
                size: 18,
                color:
                Color(0xFF55555D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ORDER SUMMARY
  // ============================================================

  Widget _buildOrderSummary(
      CartResponseModel cart,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(24),
      decoration:
      BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border:
        Border.all(
          color:
          const Color(0xFFE4E4E9),
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.025),
            blurRadius: 14,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.w800,
              color:
              Color(0xFF29292E),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [

              const Text(
                'Items',
                style: TextStyle(
                  fontSize: 14,
                  color:
                  Color(0xFF85858D),
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              Text(
                cart.totalItems.toString(),
                style:
                const TextStyle(
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w800,
                  color:
                  Color(0xFF35353C),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Divider(
            color:
            Color(0xFFE8E8EC),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [

              const Text(
                'Grand Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w800,
                  color:
                  Color(0xFF3B3B42),
                ),
              ),

              Text(
                '₹${cart.grandTotal.toStringAsFixed(2)}',
                style:
                const TextStyle(
                  fontSize: 22,
                  fontWeight:
                  FontWeight.w900,
                  color:
                  Color(0xFF965DC2),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CustomerCheckoutScreen(
                          grandTotal:
                          cart.grandTotal,
                          totalItems:
                          cart.totalItems,
                        ),
                  ),
                );
              },
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF965DC2),
                foregroundColor:
                Colors.white,
                elevation: 0,
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'PROCEED TO CHECKOUT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY CART
  // ============================================================

  Widget _buildEmptyCart() {
    return Column(
      children: [

        _buildHeader(0),

        Expanded(
          child: Center(
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              children: [

                Container(
                  height: 100,
                  width: 100,
                  decoration:
                  const BoxDecoration(
                    color:
                    Color(0xFFF0E5F7),
                    shape:
                    BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 48,
                    color:
                    Color(0xFF965DC2),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Your cart is empty',
                  style:
                  TextStyle(
                    fontSize: 22,
                    fontWeight:
                    FontWeight.w800,
                    color:
                    Color(0xFF29292E),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Add products to your cart and they will appear here.',
                  textAlign:
                  TextAlign.center,
                  style:
                  TextStyle(
                    fontSize: 14,
                    color:
                    Color(0xFF85858D),
                  ),
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF965DC2),
                    foregroundColor:
                    Colors.white,
                    elevation: 0,
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 15,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(11),
                    ),
                  ),
                  child:
                  const Text(
                    'CONTINUE SHOPPING',
                    style: TextStyle(
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(
      String error,
      ) {
    return Column(
      children: [

        _buildHeader(0),

        Expanded(
          child: Center(
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              children: [

                const Icon(
                  Icons.error_outline_rounded,
                  size: 55,
                  color:
                  Colors.redAccent,
                ),

                const SizedBox(height: 16),

                const Text(
                  'Unable to load cart',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  error.replaceFirst(
                    'Exception: ',
                    '',
                  ),
                  textAlign:
                  TextAlign.center,
                  style:
                  const TextStyle(
                    color:
                    Color(0xFF85858D),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(
                      cartViewModelProvider
                          .notifier,
                    )
                        .getCart();
                  },
                  child:
                  const Text('RETRY'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}