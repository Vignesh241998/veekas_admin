import 'package:flutter/material.dart';

import '../modal/order_modal.dart';

class OrderTable extends StatelessWidget {
  final List<OrderListModel> orders;

  final Function(OrderListModel order) onView;

  final Function(OrderListModel order) onUpdateStatus;

  final Function(OrderListModel order) onCreateShipment;

  const OrderTable({
    super.key,
    required this.orders,
    required this.onView,
    required this.onUpdateStatus,
    required this.onCreateShipment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE8E8EC),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              const Color(0xFFF8F5FA),
            ),

            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF3A3A42),
              fontSize: 13,
            ),

            columns: const [
              DataColumn(
                label: Text('ORDER'),
              ),

              DataColumn(
                label: Text('CUSTOMER'),
              ),

              DataColumn(
                label: Text('MOBILE'),
              ),

              DataColumn(
                label: Text('TOTAL'),
              ),

              DataColumn(
                label: Text('PAYMENT'),
              ),

              DataColumn(
                label: Text('PAYMENT STATUS'),
              ),

              DataColumn(
                label: Text('ORDER STATUS'),
              ),

              DataColumn(
                label: Text('ACTIONS'),
              ),
            ],

            rows: orders.map(
                  (order) {
                final canCreateShipment =
                    order.orderStatus.toUpperCase() == 'PACKED';

                final shipmentAlreadyCreated =
                    order.orderStatus.toUpperCase() ==
                        'SHIPMENT_CREATED' ||
                        order.orderStatus.toUpperCase() == 'SHIPPED' ||
                        order.orderStatus.toUpperCase() ==
                            'OUT_FOR_DELIVERY' ||
                        order.orderStatus.toUpperCase() == 'DELIVERED';

                return DataRow(
                  cells: [
                    // ============================================================
                    // ORDER NUMBER
                    // ============================================================

                    DataCell(
                      Text(
                        order.orderNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF965DC2),
                        ),
                      ),
                    ),

                    // ============================================================
                    // CUSTOMER
                    // ============================================================

                    DataCell(
                      Text(
                        order.userName,
                      ),
                    ),

                    // ============================================================
                    // MOBILE
                    // ============================================================

                    DataCell(
                      Text(
                        order.mobile,
                      ),
                    ),

                    // ============================================================
                    // TOTAL
                    // ============================================================

                    DataCell(
                      Text(
                        '₹${order.grandTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    // ============================================================
                    // PAYMENT METHOD
                    // ============================================================

                    DataCell(
                      _buildPaymentMethodChip(
                        order.paymentMethod,
                      ),
                    ),

                    // ============================================================
                    // PAYMENT STATUS
                    // ============================================================

                    DataCell(
                      _buildPaymentStatusChip(
                        order.paymentStatus,
                      ),
                    ),

                    // ============================================================
                    // ORDER STATUS
                    // ============================================================

                    DataCell(
                      _buildOrderStatusChip(
                        order.orderStatus,
                      ),
                    ),

                    // ============================================================
                    // ACTIONS
                    // ============================================================

                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ======================================================
                          // VIEW ORDER
                          // ======================================================

                          Tooltip(
                            message: 'view Order',
                            child: IconButton(
                              onPressed: () {
                                onView(order);
                              },
                              icon: const Icon(
                                Icons.visibility_outlined,
                              ),
                              color: const Color(
                                0xFF965DC2,
                              ),
                            ),
                          ),

                          // ======================================================
                          // UPDATE ORDER STATUS
                          // ======================================================

                          Tooltip(
                            message: 'Update Order Status',
                            child: IconButton(
                              onPressed: () {
                                onUpdateStatus(order);
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                              ),
                              color: const Color(
                                0xFF2563EB,
                              ),
                            ),
                          ),

                          // ======================================================
                          // CREATE SHIPMENT
                          // ONLY WHEN ORDER IS PACKED
                          // ======================================================

                          if (canCreateShipment)
                            Tooltip(
                              message: 'Create Shipment',
                              child: IconButton(
                                onPressed: () {
                                  onCreateShipment(order);
                                },
                                icon: const Icon(
                                  Icons.local_shipping_outlined,
                                ),
                                color: const Color(
                                  0xFF16A34A,
                                ),
                              ),
                            ),

                          // ======================================================
                          // SHIPMENT ALREADY CREATED
                          // ======================================================

                          if (shipmentAlreadyCreated)
                            const Tooltip(
                              message: 'Shipment Already Created',
                              child: Icon(
                                Icons.local_shipping_rounded,
                                color: Color(0xFF9CA3AF),
                                size: 22,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PAYMENT METHOD
  // ============================================================

  Widget _buildPaymentMethodChip(
      String method,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        method,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF4B5563),
        ),
      ),
    );
  }

  // ============================================================
  // PAYMENT STATUS
  // ============================================================

  Widget _buildPaymentStatusChip(
      String status,
      ) {
    final normalized = status.toUpperCase();

    Color backgroundColor;
    Color textColor;

    switch (normalized) {
      case 'PAID':
        backgroundColor = const Color(0xFFE8F7EE);
        textColor = const Color(0xFF16A34A);
        break;

      case 'FAILED':
        backgroundColor = const Color(0xFFFFEEEE);
        textColor = const Color(0xFFDC2626);
        break;

      case 'REFUNDED':
        backgroundColor = const Color(0xFFFFF4E5);
        textColor = const Color(0xFFEA580C);
        break;

      default:
        backgroundColor = const Color(0xFFFFF7E6);
        textColor = const Color(0xFFD97706);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        normalized,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }

  // ============================================================
  // ORDER STATUS
  // ============================================================

  Widget _buildOrderStatusChip(
      String status,
      ) {
    final normalized = status.toUpperCase();

    Color backgroundColor;
    Color textColor;

    switch (normalized) {
      case 'DELIVERED':
        backgroundColor = const Color(0xFFE8F7EE);
        textColor = const Color(0xFF16A34A);
        break;

      case 'CANCELLED':
      case 'RETURNED':
        backgroundColor = const Color(0xFFFFEEEE);
        textColor = const Color(0xFFDC2626);
        break;

      case 'SHIPPED':
      case 'OUT_FOR_DELIVERY':
        backgroundColor = const Color(0xFFEAF2FF);
        textColor = const Color(0xFF2563EB);
        break;

      case 'SHIPMENT_CREATED':
        backgroundColor = const Color(0xFFE0F2FE);
        textColor = const Color(0xFF0284C7);
        break;

      case 'PACKED':
      case 'CONFIRMED':
        backgroundColor = const Color(0xFFF3E8FF);
        textColor = const Color(0xFF7C3AED);
        break;

      default:
        backgroundColor = const Color(0xFFFFF7E6);
        textColor = const Color(0xFFD97706);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        normalized.replaceAll(
          '_',
          ' ',
        ),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }
}