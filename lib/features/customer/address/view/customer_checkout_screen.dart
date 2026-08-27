import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../orders/viewmodal/order_view_modal.dart';
import '../../cart/model/cart_model.dart';
import '../../cart/viewmodal/cart_view_modal.dart';

import '../../address/modal/address_model.dart';
import '../../address/viewmodal/address_view_modal.dart';

import '../../order/customer_order_model.dart';
import '../../order/viewmodal/order_view_modal.dart';

class CustomerCheckoutScreen extends ConsumerStatefulWidget {
  final double grandTotal;
  final int totalItems;

  // ============================================================
  // BUY NOW ITEM
  // ============================================================

  final CartModel? buyNowItem;

  const CustomerCheckoutScreen({
    super.key,
    required this.grandTotal,
    required this.totalItems,
    this.buyNowItem,
  });

  @override
  ConsumerState<CustomerCheckoutScreen> createState() =>
      _CustomerCheckoutScreenState();
}

class _CustomerCheckoutScreenState
    extends ConsumerState<CustomerCheckoutScreen> {
  // ============================================================
  // SELECTED ADDRESS
  // ============================================================

  AddressModel? selectedAddress;

  // ============================================================
  // PAYMENT METHOD
  // ============================================================

  String selectedPaymentMethod = 'COD';

  // ============================================================
  // LOADING
  // ============================================================

  bool isPlacingOrder = false;

  // ============================================================
  // BUY NOW CHECK
  // ============================================================

  bool get isBuyNow => widget.buyNowItem != null;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref
    //       .read(addressViewModelProvider.notifier)
    //       .getAddresses();
    // });
  }


  Widget _buildAddressTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF965DC2),
            width: 1.5,
          ),
        ),
      ),
    );
  }
  // ============================================================
  // GET CURRENT USER ID
  // ============================================================

  Future<int?> _getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return prefs.getInt('user_id');
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // CONFIRM ORDER
  // ============================================================

  Future<void> _confirmOrder() async {
    // ==========================================================
    // PREVENT MULTIPLE CLICKS
    // ==========================================================

    if (isPlacingOrder) {
      return;
    }

    // ==========================================================
    // ADDRESS VALIDATION
    // ==========================================================

    if (selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a delivery address.',
          ),
        ),
      );

      return;
    }

    // ==========================================================
    // USER ID
    // ==========================================================

    final userId = await _getCurrentUserId();

    if (userId == null || userId <= 0) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'User session not found. Please login again.',
          ),
        ),
      );

      return;
    }

    // ==========================================================
    // CONFIRMATION DIALOG
    // ==========================================================

    final shouldPlaceOrder =
    await _showOrderConfirmationDialog();

    if (shouldPlaceOrder != true) {
      return;
    }

    if (!mounted) return;

    setState(() {
      isPlacingOrder = true;
    });

    try {
      // ========================================================
      // PLACE ORDER API
      // ========================================================

      final result = await ref
          .read(customerOrderViewModelProvider.notifier)
          .placeOrder(
        // userId: userId,
        addressId: selectedAddress!.id,
        paymentMethod: selectedPaymentMethod,
      );

      if (!mounted) return;

      // ========================================================
      // RESPONSE VALIDATION
      // ========================================================

      if (result == null || result.status != true) {
        throw Exception(
          result?.message ??
              'Unable to place order.',
        );
      }

      // ========================================================
      // REFRESH CART
      // ========================================================

      await ref
          .read(cartViewModelProvider.notifier)
          .getCart();

      if (!mounted) return;

      // ========================================================
      // ORDER SUCCESS
      // ========================================================

      await _showOrderSuccessDialog(
        result.data,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e
                .toString()
                .replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isPlacingOrder = false;
        });
      }
    }
  }

  // ============================================================
  // ORDER CONFIRMATION DIALOG
  // ============================================================

  Future<bool?> _showOrderConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Confirm Order',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            selectedPaymentMethod == 'COD'
                ? 'Are you sure you want to place this Cash on Delivery order?'
                : 'Are you sure you want to place this UPI order?',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B6B74),
              height: 1.4,
            ),
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
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF965DC2),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(9),
                ),
              ),
              child: const Text(
                'Confirm',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SUCCESS DIALOG
  // ============================================================

  Future<void> _showOrderSuccessDialog(
      OrderDataModel? order,
      ) async
  {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 68,
                width: 68,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF8EE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF16A34A),
                  size: 42,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Order Placed!',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight:
                  FontWeight.w800,
                  color: Color(0xFF202124),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                order != null &&
                    order.orderNumber.isNotEmpty
                    ? 'Your order ${order.orderNumber} has been placed successfully.'
                    : 'Your order has been placed successfully.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B6B74),
                  height: 1.5,
                ),
              ),

              if (order != null) ...[
                const SizedBox(height: 10),

                Text(
                  selectedPaymentMethod == 'COD'
                      ? 'Payment: Cash on Delivery'
                      : 'Payment: UPI',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                    color: Color(0xFF965DC2),
                  ),
                ),
              ],

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/customer-home',
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF965DC2),
                    foregroundColor:
                    Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'CONTINUE SHOPPING',
                    style: TextStyle(
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final addressState =
    ref.watch(addressViewModelProvider);

    return Scaffold(
      backgroundColor:
      const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: addressState.when(
                loading: () => _buildLoading(),

                error: (error, stackTrace) =>
                    _buildAddressError(),

                data: (addresses) {
                  _handleInitialAddressSelection(
                    addresses,
                  );

                  return _buildContent(
                    addresses,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // AUTO SELECT ADDRESS
  // ============================================================

  void _handleInitialAddressSelection(
      List<AddressModel> addresses,
      ) {
    if (addresses.isEmpty) {
      selectedAddress = null;
      return;
    }

    if (selectedAddress != null) {
      return;
    }

    AddressModel? defaultAddress;

    for (final address in addresses) {
      if (address.isDefault) {
        defaultAddress = address;
        break;
      }
    }

    selectedAddress =
        defaultAddress ?? addresses.first;
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
            color:
            Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius:
            BorderRadius.circular(10),
            onTap: isPlacingOrder
                ? null
                : () {
              Navigator.pop(context);
            },
            child: Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color:
                const Color(0xFFF7F7F8),
                borderRadius:
                BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF3F3F46),
              ),
            ),
          ),

          const SizedBox(width: 18),

          const Text(
            'Checkout',
            style: TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.w800,
              color: Color(0xFF202124),
            ),
          ),

          const Spacer(),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color:
              const Color(0xFFEDE4F5),
              borderRadius:
              BorderRadius.circular(20),
            ),
            child: Text(
              isBuyNow
                  ? 'BUY NOW'
                  : 'CART CHECKOUT',
              style: const TextStyle(
                fontSize: 11,
                fontWeight:
                FontWeight.w800,
                color: Color(0xFF965DC2),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent(
      List<AddressModel> addresses,
      ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints:
          const BoxConstraints(
            maxWidth: 1100,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // =================================================
              // ADDRESS
              // =================================================

              _buildSectionTitle(
                icon:
                Icons.location_on_outlined,
                title:
                'Delivery Address',
              ),

              const SizedBox(height: 14),

              _buildAddressSection(
                addresses,
              ),

              const SizedBox(height: 28),

              // =================================================
              // ORDER SUMMARY
              // =================================================

              _buildSectionTitle(
                icon:
                Icons.shopping_bag_outlined,
                title:
                'Order Summary',
              ),

              const SizedBox(height: 14),

              if (isBuyNow)
                _buildBuyNowSummary(
                  widget.buyNowItem!,
                )
              else
                _buildCartSummary(),

              const SizedBox(height: 28),

              // =================================================
              // PRICE DETAILS
              // =================================================

              _buildSectionTitle(
                icon:
                Icons.receipt_long_outlined,
                title:
                'Price Details',
              ),

              const SizedBox(height: 14),

              _buildPriceDetails(),

              const SizedBox(height: 28),

              // =================================================
              // PAYMENT METHOD
              // =================================================

              _buildSectionTitle(
                icon:
                Icons.payment_outlined,
                title:
                'Payment Method',
              ),

              const SizedBox(height: 14),

              _buildPaymentMethod(),

              const SizedBox(height: 28),

              // =================================================
              // CONFIRM ORDER
              // =================================================

              _buildConfirmOrderButton(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration:
          const BoxDecoration(
            color: Color(0xFFEDE4F5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color:
            const Color(0xFF965DC2),
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight:
            FontWeight.w800,
            color: Color(0xFF202124),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ADDRESS SECTION
  // ============================================================

  Widget _buildAddressSection(
      List<AddressModel> addresses,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color:
          const Color(0xFFE7E7EC),
        ),
      ),
      child: Column(
        children: [
          if (addresses.isEmpty)
            _buildNoAddress()
          else
            ...addresses.map(
                  (address) {
                final isSelected =
                    selectedAddress?.id ==
                        address.id;

                return Padding(
                  padding:
                  const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: _buildAddressCard(
                    address: address,
                    isSelected: isSelected,
                  ),
                );
              },
            ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: isPlacingOrder
                  ? null
                  : _showAddAddressDialog,
              icon: const Icon(
                Icons.add_location_alt_outlined,
              ),
              label: const Text(
                'ADD NEW ADDRESS',
              ),
              style:
              OutlinedButton.styleFrom(
                foregroundColor:
                const Color(0xFF965DC2),
                side: const BorderSide(
                  color:
                  Color(0xFF965DC2),
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADDRESS CARD
  // ============================================================

  Widget _buildAddressCard({
    required AddressModel address,
    required bool isSelected,
  }) {
    return InkWell(
      borderRadius:
      BorderRadius.circular(12),
      onTap: isPlacingOrder
          ? null
          : () {
        setState(() {
          selectedAddress = address;
        });
      },
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF8F5FB)
              : Colors.white,
          borderRadius:
          BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF965DC2)
                : const Color(0xFFE4E4E9),
            width:
            isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Radio<int>(
              value: address.id,
              groupValue:
              selectedAddress?.id,
              activeColor:
              const Color(0xFF965DC2),
              onChanged: isPlacingOrder
                  ? null
                  : (value) {
                setState(() {
                  selectedAddress =
                      address;
                });
              },
            ),

            const SizedBox(width: 6),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          address.fullName,
                          style:
                          const TextStyle(
                            fontSize: 15,
                            fontWeight:
                            FontWeight.w700,
                            color:
                            Color(0xFF202124),
                          ),
                        ),
                      ),

                      if (address.isDefault)
                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration:
                          BoxDecoration(
                            color:
                            const Color(0xFFE8F7EE),
                            borderRadius:
                            BorderRadius.circular(
                              20,
                            ),
                          ),
                          child: const Text(
                            'DEFAULT',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight:
                              FontWeight.w800,
                              color:
                              Color(0xFF16A34A),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    address.mobile,
                    style: const TextStyle(
                      fontSize: 13,
                      color:
                      Color(0xFF6B6B74),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _getFullAddress(address),
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color:
                      Color(0xFF5F5F68),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                      const Color(0xFFEDE4F5),
                      borderRadius:
                      BorderRadius.circular(6),
                    ),
                    child: Text(
                      address.addressType,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        Color(0xFF965DC2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // NO ADDRESS
  // ============================================================

  Widget _buildNoAddress() {
    return Column(
      children: [
        const Icon(
          Icons.location_off_outlined,
          size: 42,
          color:
          Color(0xFFB0B0B8),
        ),

        const SizedBox(height: 12),

        const Text(
          'No delivery address found',
          style: TextStyle(
            fontSize: 15,
            fontWeight:
            FontWeight.w700,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Please add an address to continue.',
          style: TextStyle(
            fontSize: 13,
            color:
            Color(0xFF7A7A84),
          ),
        ),

        const SizedBox(height: 18),
      ],
    );
  }

  // ============================================================
  // BUY NOW SUMMARY
  // ============================================================

  Widget _buildBuyNowSummary(
      CartModel item,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color:
          const Color(0xFFE7E7EC),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            height: 82,
            width: 82,
            decoration: BoxDecoration(
              color:
              const Color(0xFFF7F7F9),
              borderRadius:
              BorderRadius.circular(12),
            ),
            child:
            item.thumbnailImage != null &&
                item.thumbnailImage!
                    .isNotEmpty
                ? ClipRRect(
              borderRadius:
              BorderRadius.circular(
                12,
              ),
              child: Image.network(
                item.thumbnailImage!,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) {
                  return _fallbackProductIcon();
                },
              ),
            )
                : _fallbackProductIcon(),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    Color(0xFF202124),
                  ),
                ),

                const SizedBox(height: 5),

                if (item.productCode.isNotEmpty)
                  Text(
                    'Code: ${item.productCode}',
                    style: const TextStyle(
                      fontSize: 12,
                      color:
                      Color(0xFF8A8A93),
                    ),
                  ),

                const SizedBox(height: 10),

                if (item.variant != null &&
                    item.variant!
                        .attributes
                        .isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: item
                        .variant!
                        .attributes
                        .map(
                          (attribute) =>
                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration:
                            BoxDecoration(
                              color:
                              const Color(
                                0xFFF5F1F8,
                              ),
                              borderRadius:
                              BorderRadius.circular(
                                5,
                              ),
                            ),
                            child: Text(
                              '${attribute.attributeName}: ${attribute.attributeValue}',
                              style:
                              const TextStyle(
                                fontSize: 10,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                          ),
                    )
                        .toList(),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 15),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [
              Text(
                '₹${item.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight:
                  FontWeight.w800,
                  color:
                  Color(0xFF965DC2),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'Qty: ${item.quantity}',
                style: const TextStyle(
                  fontSize: 12,
                  color:
                  Color(0xFF6B6B74),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CART SUMMARY
  // ============================================================

  Widget _buildCartSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color:
          const Color(0xFFE7E7EC),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration:
            const BoxDecoration(
              color: Color(0xFFEDE4F5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color:
              Color(0xFF965DC2),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.totalItems} item${widget.totalItems == 1 ? '' : 's'} in your cart',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    Color(0xFF202124),
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Your cart items will be processed for this order.',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                    Color(0xFF7A7A84),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRICE DETAILS
  // ============================================================

  Widget _buildPriceDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color:
          const Color(0xFFE7E7EC),
        ),
      ),
      child: Column(
        children: [
          _buildPriceRow(
            'Total Items',
            widget.totalItems.toString(),
          ),

          const SizedBox(height: 14),

          _buildPriceRow(
            'Subtotal',
            '₹${widget.grandTotal.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 14),

          _buildPriceRow(
            'Delivery Charges',
            '₹0.00',
          ),

          const Padding(
            padding:
            EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: Divider(),
          ),

          Row(
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                  FontWeight.w800,
                  color:
                  Color(0xFF202124),
                ),
              ),

              const Spacer(),

              Text(
                '₹${widget.grandTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight:
                  FontWeight.w800,
                  color:
                  Color(0xFF965DC2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
      String title,
      String value,
      ) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color:
            Color(0xFF6B6B74),
          ),
        ),

        const Spacer(),

        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight:
            FontWeight.w600,
            color:
            Color(0xFF3F3F46),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PAYMENT METHOD
  // ============================================================

  Widget _buildPaymentMethod() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color:
          const Color(0xFFE8E8EC),
        ),
      ),
      child: Column(
        children: [
          _buildPaymentOption(
            title: 'Cash on Delivery',
            subtitle: 'Pay when your order is delivered',
            value: 'COD',
            icon: Icons.payments_outlined,
          ),

          const SizedBox(height: 12),

          _buildPaymentOption(
            title: 'UPI',
            subtitle: 'Pay securely using your UPI app',
            value: 'UPI',
            icon:
            Icons.account_balance_wallet_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
  }) {
    final isSelected =
        selectedPaymentMethod == value;

    return InkWell(
      borderRadius:
      BorderRadius.circular(12),
      onTap: isPlacingOrder
          ? null
          : () {
        setState(() {
          selectedPaymentMethod =
              value;
        });
      },
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        padding:
        const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF8F5FB)
              : Colors.white,
          borderRadius:
          BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF965DC2)
                : const Color(0xFFE2E2E6),
            width:
            isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFEDE4F5)
                    : const Color(0xFFF6F6F8),
                borderRadius:
                BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF965DC2)
                    : const Color(0xFF6B6B74),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color:
                      const Color(0xFF29292E),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color:
                      Color(0xFF85858D),
                    ),
                  ),
                ],
              ),
            ),

            Radio<String>(
              value: value,
              groupValue:
              selectedPaymentMethod,
              activeColor:
              const Color(0xFF965DC2),
              onChanged: isPlacingOrder
                  ? null
                  : (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedPaymentMethod =
                      value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CONFIRM ORDER BUTTON
  // ============================================================

  Widget _buildConfirmOrderButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isPlacingOrder
            ? null
            : _confirmOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor:
          const Color(0xFF965DC2),
          foregroundColor: Colors.white,
          disabledBackgroundColor:
          const Color(0xFFCDB8DE),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
        ),
        child: isPlacingOrder
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
            : Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              selectedPaymentMethod == 'COD'
                  ? Icons.shopping_bag_outlined
                  : Icons.payment_outlined,
              size: 20,
            ),

            const SizedBox(width: 9),

            Text(
              selectedPaymentMethod == 'COD'
                  ? 'CONFIRM COD ORDER'
                  : 'PAY WITH UPI',
              style: const TextStyle(
                fontSize: 14,
                fontWeight:
                FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ADD ADDRESS DIALOG
  // ============================================================

  // Future<void> _showAddAddressDialog() async {
  //   // ==========================================================
  //   // IMPORTANT
  //   // ==========================================================
  //   //
  //   // Replace this method with your existing Add Address dialog.
  //   //
  //   // After successfully adding an address, call:
  //   //
  //   // await ref
  //   //     .read(addressViewModelProvider.notifier)
  //   //     .getAddresses();
  //   //
  //   // ==========================================================
  //
  //   showDialog(
  //     context: context,
  //     builder: (dialogContext) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius:
  //           BorderRadius.circular(16),
  //         ),
  //         title: const Text(
  //           'Add New Address',
  //         ),
  //         content: const Text(
  //           'Connect your existing Add Address form here.',
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(
  //                 dialogContext,
  //               );
  //             },
  //             child: const Text(
  //               'CLOSE',
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  Future<void> _showAddAddressDialog() async {
    final fullNameController = TextEditingController();
    final mobileController = TextEditingController();
    final alternateMobileController = TextEditingController();
    final addressLine1Controller = TextEditingController();
    final addressLine2Controller = TextEditingController();
    final landmarkController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final countryController = TextEditingController(text: 'India');
    final pincodeController = TextEditingController();

    String addressType = 'Home';
    bool isDefault = false;
    bool isLoading = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              title: const Text(
                'Add New Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              content: SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // ========================================================
                      // FULL NAME
                      // ========================================================

                      _buildAddressTextField(
                        controller: fullNameController,
                        label: 'Full Name *',
                      ),

                      const SizedBox(height: 12),

                      // ========================================================
                      // MOBILE
                      // ========================================================

                      _buildAddressTextField(
                        controller: mobileController,
                        label: 'Mobile Number *',
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 12),

                      // ========================================================
                      // ALTERNATE MOBILE
                      // ========================================================

                      _buildAddressTextField(
                        controller: alternateMobileController,
                        label: 'Alternate Mobile Number',
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 12),

                      // ========================================================
                      // ADDRESS LINE 1
                      // ========================================================

                      _buildAddressTextField(
                        controller: addressLine1Controller,
                        label: 'Address Line 1 *',
                      ),

                      const SizedBox(height: 12),

                      // ========================================================
                      // ADDRESS LINE 2
                      // ========================================================

                      _buildAddressTextField(
                        controller: addressLine2Controller,
                        label: 'Address Line 2',
                      ),

                      const SizedBox(height: 12),

                      // ========================================================
                      // LANDMARK
                      // ========================================================

                      _buildAddressTextField(
                        controller: landmarkController,
                        label: 'Landmark',
                      ),

                      const SizedBox(height: 12),

                      // ========================================================
                      // CITY + STATE
                      // ========================================================

                      Row(
                        children: [
                          Expanded(
                            child: _buildAddressTextField(
                              controller: cityController,
                              label: 'City *',
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _buildAddressTextField(
                              controller: stateController,
                              label: 'State *',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ========================================================
                      // COUNTRY + PINCODE
                      // ========================================================

                      Row(
                        children: [
                          Expanded(
                            child: _buildAddressTextField(
                              controller: countryController,
                              label: 'Country *',
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _buildAddressTextField(
                              controller: pincodeController,
                              label: 'Pincode *',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ========================================================
                      // ADDRESS TYPE
                      // ========================================================

                      DropdownButtonFormField<String>(
                        value: addressType,
                        decoration: InputDecoration(
                          labelText: 'Address Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Home',
                            child: Text('Home'),
                          ),
                          DropdownMenuItem(
                            value: 'Work',
                            child: Text('Work'),
                          ),
                          DropdownMenuItem(
                            value: 'Other',
                            child: Text('Other'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setDialogState(() {
                            addressType = value;
                          });
                        },
                      ),

                      const SizedBox(height: 8),

                      // ========================================================
                      // DEFAULT ADDRESS
                      // ========================================================

                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Set as default address',
                        ),
                        value: isDefault,
                        activeColor: const Color(0xFF965DC2),
                        onChanged: (value) {
                          setDialogState(() {
                            isDefault = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              actions: [

                // ==============================================================
                // CANCEL
                // ==============================================================

                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('CANCEL'),
                ),

                // ==============================================================
                // SAVE ADDRESS
                // ==============================================================

                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {

                    // ======================================================
                    // VALIDATION
                    // ======================================================

                    if (fullNameController.text.trim().isEmpty ||
                        mobileController.text.trim().isEmpty ||
                        addressLine1Controller.text.trim().isEmpty ||
                        cityController.text.trim().isEmpty ||
                        stateController.text.trim().isEmpty ||
                        countryController.text.trim().isEmpty ||
                        pincodeController.text.trim().isEmpty) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill all required fields.',
                          ),
                        ),
                      );

                      return;
                    }

                    setDialogState(() {
                      isLoading = true;
                    });

                    try {

                      // ====================================================
                      // CALL EXISTING ADD ADDRESS METHOD
                      // ====================================================

                      final newAddress = await ref
                          .read(
                        addressViewModelProvider.notifier,
                      )
                          .addAddress(
                        fullName:
                        fullNameController.text.trim(),

                        mobile:
                        mobileController.text.trim(),

                        alternateMobile:
                        alternateMobileController.text.trim().isEmpty
                            ? null
                            : alternateMobileController.text.trim(),

                        addressLine1:
                        addressLine1Controller.text.trim(),

                        addressLine2:
                        addressLine2Controller.text.trim().isEmpty
                            ? null
                            : addressLine2Controller.text.trim(),

                        landmark:
                        landmarkController.text.trim().isEmpty
                            ? null
                            : landmarkController.text.trim(),

                        city:
                        cityController.text.trim(),

                        state:
                        stateController.text.trim(),

                        country:
                        countryController.text.trim(),

                        pincode:
                        pincodeController.text.trim(),

                        addressType:
                        addressType,

                        isDefault:
                        isDefault,
                      );

                      if (!mounted) return;

                      // ====================================================
                      // CLOSE ADD ADDRESS DIALOG
                      // ====================================================

                      Navigator.pop(dialogContext);

                      // ====================================================
                      // IMPORTANT:
                      // SELECT THE NEWLY CREATED ADDRESS
                      // ====================================================

                      setState(() {
                        selectedAddress = newAddress;
                      });

                      // ====================================================
                      // ADDRESS LIST IS ALREADY REFRESHED INSIDE addAddress()
                      // BUT WAIT FOR UI TO UPDATE
                      // ====================================================

                      await ref
                          .read(
                        addressViewModelProvider.notifier,
                      )
                          .getAddresses();

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Address added successfully.',
                          ),
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

                    } finally {

                      if (mounted) {
                        setDialogState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF965DC2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),

                  child: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'SAVE ADDRESS',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    // ============================================================
    // DISPOSE CONTROLLERS
    // ============================================================

    fullNameController.dispose();
    mobileController.dispose();
    alternateMobileController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    landmarkController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pincodeController.dispose();
  }
  // ============================================================
  // ADDRESS ERROR
  // ============================================================

  Widget _buildAddressError() {
    return Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 42,
            color: Colors.red,
          ),

          const SizedBox(height: 12),

          const Text(
            'Unable to load addresses',
          ),

          const SizedBox(height: 10),

          TextButton(
            onPressed: () {
              ref
                  .read(
                addressViewModelProvider
                    .notifier,
              )
                  .getAddresses();
            },
            child: const Text(
              'Retry',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _buildLoading() {
    return const Center(
      child: SizedBox(
        height: 30,
        width: 30,
        child:
        CircularProgressIndicator(
          strokeWidth: 2.5,
          color: Color(0xFF965DC2),
        ),
      ),
    );
  }

  // ============================================================
  // FULL ADDRESS
  // ============================================================

  String _getFullAddress(
      AddressModel address,
      ) {
    final parts = <String>[
      address.addressLine1,
    ];

    if (address.addressLine2.isNotEmpty) {
      parts.add(address.addressLine2);
    }

    if (address.landmark.isNotEmpty) {
      parts.add(address.landmark);
    }

    parts.add(
      '${address.city}, ${address.state}',
    );

    parts.add(
      '${address.country} - ${address.pincode}',
    );

    return parts.join(', ');
  }

  // ============================================================
  // FALLBACK PRODUCT IMAGE
  // ============================================================

  Widget _fallbackProductIcon() {
    return const Center(
      child: Icon(
        Icons.shopping_bag_outlined,
        size: 32,
        color:
        Color(0xFFC0C0C8),
      ),
    );
  }
}