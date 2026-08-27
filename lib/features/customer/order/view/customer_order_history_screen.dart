/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veekas_ecommerce_app/features/customer/shipment%20Tracking/view/shipment_tracking_screen.dart';

import '../../../orders/modal/order_modal.dart';
import '../viewmodal/order_view_modal.dart';

class CustomerOrderHistoryScreen extends ConsumerWidget {
  const CustomerOrderHistoryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(
      customerOrderListViewModelProvider,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),

      appBar: AppBar(
        title: const Text(
          'My Orders',
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF202124),
        elevation: 0,
        centerTitle: true,
      ),

      body: ordersState.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF965DC2),
            ),
          );
        },

        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 50,
                    color: Colors.red,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    error
                        .toString()
                        .replaceFirst(
                      'Exception: ',
                      '',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(
                        customerOrderListViewModelProvider
                            .notifier,
                      )
                          .getCustomerOrders();
                    },
                    child: const Text(
                      'Retry',
                    ),
                  ),
                ],
              ),
            ),
          );
        },

        data: (orders) {
          if (orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 60,
                    color: Color(0xFF9CA3AF),
                  ),

                  SizedBox(height: 12),

                  Text(
                    'No orders found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFF965DC2),

            onRefresh: () {
              return ref
                  .read(
                customerOrderListViewModelProvider
                    .notifier,
              )
                  .getCustomerOrders();
            },

            child: ListView.separated(
              padding: const EdgeInsets.all(16),

              itemCount: orders.length,

              separatorBuilder: (
                  context,
                  index,
                  ) {
                return const SizedBox(
                  height: 12,
                );
              },

              itemBuilder: (
                  context,
                  index,
                  ) {
                final order = orders[index];

                return _OrderCard(
                  order: order,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderListModel order;

  const _OrderCard({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE8E8EC),
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // ======================================================
          // ORDER NUMBER + STATUS
          // ======================================================

          Row(
            children: [
              Expanded(
                child: Text(
                  order.orderNumber,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF965DC2),
                  ),
                ),
              ),

              _OrderStatusChip(
                status: order.orderStatus,
              ),
              if (order.trackingNumber != null &&
                  order.trackingNumber!.isNotEmpty)
                TrackOrderChip(
                  text: "Track Your Order",
                  trackno: order.trackingNumber!,
                ),
            ],
          ),

          const SizedBox(height: 14),

          const Divider(
            color: Color(0xFFE8E8EC),
          ),

          const SizedBox(height: 10),

          // ======================================================
          // TOTAL
          // ======================================================

          _InfoRow(
            icon: Icons.currency_rupee_rounded,
            label: 'Total',
            value:
            '₹${order.grandTotal.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 10),

          // ======================================================
          // PAYMENT METHOD
          // ======================================================

          _InfoRow(
            icon: Icons.payment_outlined,
            label: 'Payment',
            value: order.paymentMethod,
          ),

          const SizedBox(height: 10),

          // ======================================================
          // PAYMENT STATUS
          // ======================================================

          _InfoRow(
            icon: Icons.check_circle_outline,
            label: 'Payment Status',
            value: order.paymentStatus,
          ),

          const SizedBox(height: 10),

          // ======================================================
          // MOBILE
          // ======================================================

          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Mobile',
            value: order.mobile,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF965DC2),
        ),

        const SizedBox(width: 10),

        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B6B74),
          ),
        ),

        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF202124),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderStatusChip extends StatelessWidget {
  final String status;

  const _OrderStatusChip({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final normalized =
    status.toUpperCase();

    Color backgroundColor;
    Color textColor;

    switch (normalized) {
      case 'DELIVERED':
        backgroundColor =
        const Color(0xFFE8F7EE);
        textColor =
        const Color(0xFF16A34A);
        break;

      case 'CANCELLED':
      case 'RETURNED':
        backgroundColor =
        const Color(0xFFFFEEEE);
        textColor =
        const Color(0xFFDC2626);
        break;

      case 'SHIPPED':
      case 'OUT_FOR_DELIVERY':
        backgroundColor =
        const Color(0xFFEAF2FF);
        textColor =
        const Color(0xFF2563EB);
        break;

      case 'PACKED':
      case 'CONFIRMED':
        backgroundColor =
        const Color(0xFFF3E8FF);
        textColor =
        const Color(0xFF7C3AED);
        break;

      default:
        backgroundColor =
        const Color(0xFFFFF7E6);
        textColor =
        const Color(0xFFD97706);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Text(
        normalized.replaceAll(
          '_',
          ' ',
        ),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }
}
class _TrackOrderChip extends StatelessWidget {
  final String text;
  final String trackno;

  const _TrackOrderChip({
    required this.text,
    required this.trackno,
  });

  @override
  Widget build(BuildContext context) {


    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ShipmentTrackingScreen(trackno: trackno,)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),

        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius:
          BorderRadius.circular(20),
        ),

        child: Text(
          text.toString(),style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.purple,
        ),
          ),

      ),
    );
  }
}*/



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:veekas_ecommerce_app/features/customer/Shipment%20Tracking/view/shipment_tracking_screen.dart';

import '../customer_order_model.dart';
import '../viewmodal/order_view_modal.dart';
import '../../../orders/modal/order_modal.dart';

class CustomerOrderHistoryScreen extends ConsumerWidget {
  const CustomerOrderHistoryScreen({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final ordersState = ref.watch(
      customerOrderListViewModelProvider,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),

      appBar: AppBar(
        title: const Text(
          'My Orders',
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF202124),
        elevation: 0,
        centerTitle: true,
      ),

      body: ordersState.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF965DC2),
            ),
          );
        },

        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 50,
                    color: Colors.red,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    error
                        .toString()
                        .replaceFirst(
                      'Exception: ',
                      '',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(
                        customerOrderListViewModelProvider
                            .notifier,
                      )
                          .getCustomerOrders();
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF965DC2),
                      foregroundColor: Colors.white,
                    ),

                    child: const Text(
                      'Retry',
                    ),
                  ),
                ],
              ),
            ),
          );
        },

        data: (orders) {
          if (orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 60,
                    color: Color(0xFF9CA3AF),
                  ),

                  SizedBox(height: 12),

                  Text(
                    'No orders found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFF965DC2),

            onRefresh: () async {
              await ref
                  .read(
                customerOrderListViewModelProvider
                    .notifier,
              )
                  .getCustomerOrders();
            },

            child: ListView.separated(
              padding: const EdgeInsets.all(16),

              itemCount: orders.length,

              separatorBuilder: (
                  context,
                  index,
                  ) {
                return const SizedBox(
                  height: 12,
                );
              },

              itemBuilder: (
                  context,
                  index,
                  ) {
                final order = orders[index];

                return _OrderCard(
                  order: order,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// ORDER CARD
// ============================================================

class _OrderCard extends StatelessWidget {
  final CustomerOrderResponseModel order;

  const _OrderCard({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final hasTrackingNumber =
        order.trackingNumber != null &&
            order.trackingNumber!.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: const Color(0xFFE8E8EC),
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
// ======================================================
// ORDER NUMBER + STATUS
// ======================================================

          Row(
            children: [
              Expanded(
                child: Text(
                  order.orderNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF965DC2),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              _OrderStatusChip(
                status: order.orderStatus,
              ),
            ],
          ),

// ======================================================
// TRACK ORDER BUTTON
// ======================================================

          if (hasTrackingNumber) ...[
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerLeft,
              child: _TrackOrderChip(
                text: 'Track Your Order',
                trackno: order.trackingNumber!,
              ),
            ),
          ],

          const SizedBox(height: 14),

          const Divider(
            color: Color(0xFFE8E8EC),
          ),

          const SizedBox(height: 10),

// ======================================================
// TOTAL
// ======================================================

          _InfoRow(
            icon: Icons.currency_rupee_rounded,
            label: 'Total',
            value:
            '₹${order.grandTotal.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 10),

// ======================================================
// PAYMENT METHOD
// ======================================================

          _InfoRow(
            icon: Icons.payment_outlined,
            label: 'Payment',
            value: order.paymentMethod,
          ),

          const SizedBox(height: 10),

// ======================================================
// PAYMENT STATUS
// ======================================================

          _InfoRow(
            icon: Icons.check_circle_outline,
            label: 'Payment Status',
            value: order.paymentStatus,
          ),

          const SizedBox(height: 10),

// ======================================================
// MOBILE
// ======================================================

          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Mobile',
            value: order.mobile,
          ),

// ======================================================
// TRACKING NUMBER DISPLAY
// ======================================================

          if (hasTrackingNumber) ...[
            const SizedBox(height: 10),

            _InfoRow(
              icon: Icons.local_shipping_outlined,
              label: 'Tracking No',
              value: order.trackingNumber!,
            ),
          ],

// ======================================================
// CREATED DATE
// ======================================================

          if (order.createdAt != null) ...[
            const SizedBox(height: 10),

            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Order Date',
              value: _formatDate(
                order.createdAt!,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(
      DateTime date,
      ) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

// ============================================================
// INFO ROW
// ============================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF965DC2),
        ),

        const SizedBox(width: 10),

        Text(
          '$label: ',

          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B6B74),
          ),
        ),

        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF202124),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ORDER STATUS CHIP
// ============================================================

class _OrderStatusChip extends StatelessWidget {
  final String status;

  const _OrderStatusChip({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final normalized =
    status.toUpperCase().trim();

    Color backgroundColor;
    Color textColor;

    switch (normalized) {
      case 'DELIVERED':
        backgroundColor =
        const Color(0xFFE8F7EE);

        textColor =
        const Color(0xFF16A34A);

        break;

      case 'CANCELLED':
      case 'RETURNED':
        backgroundColor =
        const Color(0xFFFFEEEE);

        textColor =
        const Color(0xFFDC2626);

        break;

      case 'SHIPPED':
      case 'OUT_FOR_DELIVERY':
        backgroundColor =
        const Color(0xFFEAF2FF);

        textColor =
        const Color(0xFF2563EB);

        break;

      case 'PACKED':
      case 'CONFIRMED':
        backgroundColor =
        const Color(0xFFF3E8FF);

        textColor =
        const Color(0xFF7C3AED);

        break;

      default:
        backgroundColor =
        const Color(0xFFFFF7E6);

        textColor =
        const Color(0xFFD97706);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Text(
        normalized.replaceAll(
          '_',
          ' ',
        ),

        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }
}

// ============================================================
// TRACK ORDER CHIP
// ============================================================

class _TrackOrderChip extends StatelessWidget {
  final String text;
  final String trackno;

  const _TrackOrderChip({
    required this.text,
    required this.trackno,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius:
      BorderRadius.circular(20),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ShipmentTrackingScreen(
                  trackno: trackno,
                ),
          ),
        );
      },

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),

        decoration: BoxDecoration(
          color:
          const Color(0xFFEDE4F5),

          borderRadius:
          BorderRadius.circular(20),

          border: Border.all(
            color:
            const Color(0xFF965DC2),
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Icon(
              Icons.local_shipping_outlined,
              size: 15,
              color: Color(0xFF965DC2),
            ),

            const SizedBox(width: 6),

            Text(
              text,

              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF965DC2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}