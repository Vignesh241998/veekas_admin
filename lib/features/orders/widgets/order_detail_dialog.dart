import 'package:flutter/material.dart';

import '../modal/order_modal.dart';

class OrderDetailDialog extends StatelessWidget {
  final OrderDetailModel order;

  const OrderDetailDialog({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:
      const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints:
        const BoxConstraints(
          maxWidth: 900,
          maxHeight: 750,
        ),
        child: Column(
          children: [

            _buildHeader(context),

            const Divider(
              height: 1,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    _buildOrderInformation(),

                    const SizedBox(height: 24),

                    _buildCustomerInformation(),

                    const SizedBox(height: 24),

                    _buildDeliveryAddress(),

                    const SizedBox(height: 24),

                    _buildOrderedItems(),

                    const SizedBox(height: 24),

                    _buildPriceDetails(),
                  ],
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

  Widget _buildHeader(
      BuildContext context,
      ) {
    return Padding(
      padding:
      const EdgeInsets.all(20),
      child: Row(
        children: [

          Container(
            height: 46,
            width: 46,
            decoration:
            const BoxDecoration(
              color: Color(0xFFF0E5F7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: Color(0xFF965DC2),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                const Text(
                  'Order Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  order.orderNumber,
                  style: const TextStyle(
                    fontSize: 13,
                    color:
                    Color(0xFF7A7A84),
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close_rounded,
            ),
          ),
        ],
      ),
    );
  }

// ============================================================
// ORDER INFORMATION
// ============================================================

  Widget _buildOrderInformation() {
    return _buildSection(
      title: 'Order Information',
      icon: Icons.shopping_bag_outlined,
      child: Column(
        children: [

          _buildInfoRow(
            'Order Number',
            order.orderNumber,
          ),

          _buildInfoRow(
            'Order Status',
            order.orderStatus
                .replaceAll('_', ' '),
          ),

          _buildInfoRow(
            'Payment Method',
            order.paymentMethod,
          ),

// READ ONLY PAYMENT STATUS

          _buildInfoRow(
            'Payment Status',
            order.paymentStatus,
          ),
        ],
      ),
    );
  }

// ============================================================
// CUSTOMER INFORMATION
// ============================================================

  Widget _buildCustomerInformation() {
    final user = order.user;

    return _buildSection(
      title: 'Customer Information',
      icon: Icons.person_outline_rounded,
      child: Column(
        children: [

          _buildInfoRow(
            'Name',
            user?.fullName ?? '-',
          ),

          _buildInfoRow(
            'Mobile',
            user?.mobile ?? '-',
          ),

          _buildInfoRow(
            'Email',
            user?.email ?? '-',
          ),
        ],
      ),
    );
  }

// ============================================================
// DELIVERY ADDRESS
// ============================================================

  Widget _buildDeliveryAddress() {
    final address = order.address;

    return _buildSection(
      title: 'Delivery Address',
      icon: Icons.location_on_outlined,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Text(
            address?.fullName ?? '-',
            style: const TextStyle(
              fontSize: 15,
              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            address?.mobile ?? '-',
            style: const TextStyle(
              fontSize: 13,
              color:
              Color(0xFF6B6B74),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            address?.fullAddress ??
                'Address not available',
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color:
              Color(0xFF55555D),
            ),
          ),
        ],
      ),
    );
  }

// ============================================================
// ORDERED ITEMS
// ============================================================

  Widget _buildOrderedItems() {
    return _buildSection(
      title: 'Ordered Items',
      icon: Icons.inventory_2_outlined,
      child: Column(
        children: order.items.map(
              (item) {
            return Container(
              width: double.infinity,
              margin:
              const EdgeInsets.only(
                bottom: 12,
              ),
              padding:
              const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                const Color(0xFFF9F9FB),
                borderRadius:
                BorderRadius.circular(10),
                border: Border.all(
                  color:
                  const Color(0xFFE7E7EC),
                ),
              ),
              child: Row(
                children: [

                  Container(
                    height: 42,
                    width: 42,
                    decoration:
                    const BoxDecoration(
                      color:
                      Color(0xFFEDE4F5),
                      shape:
                      BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 20,
                      color:
                      Color(0xFF965DC2),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          item.product
                              ?.productName ??
                              'Product',
                          style:
                          const TextStyle(
                            fontSize: 14,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        if (item.product
                            ?.productCode
                            .isNotEmpty ==
                            true)
                          Text(
                            'Code: ${item.product!.productCode}',
                            style:
                            const TextStyle(
                              fontSize: 11,
                              color:
                              Color(
                                0xFF85858D,
                              ),
                            ),
                          ),

                        if (item.variant
                            ?.sku
                            .isNotEmpty ==
                            true)
                          Padding(
                            padding:
                            const EdgeInsets.only(
                              top: 4,
                            ),
                            child: Text(
                              'Variant: ${item.variant!.sku}',
                              style:
                              const TextStyle(
                                fontSize: 11,
                                color:
                                Color(
                                  0xFF85858D,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.end,
                    children: [

                      Text(
                        'Qty: ${item.quantity}',
                        style:
                        const TextStyle(
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        '₹${item.totalPrice.toStringAsFixed(2)}',
                        style:
                        const TextStyle(
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w800,
                          color:
                          Color(
                            0xFF965DC2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }

// ============================================================
// PRICE DETAILS
// ============================================================

  Widget _buildPriceDetails() {
    return _buildSection(
      title: 'Price Details',
      icon: Icons.currency_rupee_outlined,
      child: Column(
        children: [

          _buildPriceRow(
            'Subtotal',
            order.subtotal,
          ),

          const SizedBox(height: 12),

          _buildPriceRow(
            'Delivery Charge',
            order.deliveryCharge,
          ),

          const SizedBox(height: 12),

          _buildPriceRow(
            'Discount',
            order.discount,
          ),

          const Padding(
            padding:
            EdgeInsets.symmetric(
              vertical: 14,
            ),
            child: Divider(),
          ),

          _buildPriceRow(
            'Grand Total',
            order.grandTotal,
            isTotal: true,
          ),
        ],
      ),
    );
  }

// ============================================================
// COMMON SECTION
// ============================================================

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color:
          const Color(0xFFE7E7EC),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Icon(
                icon,
                size: 20,
                color:
                const Color(0xFF965DC2),
              ),

              const SizedBox(width: 9),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      String title,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          SizedBox(
            width: 150,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color:
                Color(0xFF7A7A84),
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight:
                FontWeight.w600,
                color:
                Color(0xFF3F3F46),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
      String title,
      double amount, {
        bool isTotal = false,
      }) {
    return Row(
      children: [

        Text(
          title,
          style: TextStyle(
            fontSize:
            isTotal ? 16 : 13,
            fontWeight: isTotal
                ? FontWeight.w800
                : FontWeight.w500,
            color:
            const Color(0xFF55555D),
          ),
        ),

        const Spacer(),

        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize:
            isTotal ? 18 : 14,
            fontWeight:
            FontWeight.w800,
            color: isTotal
                ? const Color(0xFF965DC2)
                : const Color(0xFF3F3F46),
          ),
        ),
      ],
    );
  }
}
