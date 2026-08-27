import 'package:flutter/material.dart';

import '../modal/shipment_modal.dart';

class ShipmentTable extends StatelessWidget {
  final List<ShipmentListModel> shipments;

  final Function(ShipmentListModel shipment) onView;

  final Function(ShipmentListModel shipment) onUpdateStatus;

  final Function(ShipmentListModel shipment) onCancel;

  const ShipmentTable({
    super.key,
    required this.shipments,
    required this.onView,
    required this.onUpdateStatus,
    required this.onCancel,
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
                label: Text('DELIVERY PARTNER'),
              ),

              DataColumn(
                label: Text('TRACKING NUMBER'),
              ),

              DataColumn(
                label: Text('AWB NUMBER'),
              ),

              DataColumn(
                label: Text('SHIPMENT ID'),
              ),

              DataColumn(
                label: Text('DELIVERY STATUS'),
              ),

              DataColumn(
                label: Text('EXPECTED DELIVERY'),
              ),

              DataColumn(
                label: Text('ACTIONS'),
              ),
            ],

            rows: shipments.map(
                  (shipment) {
                return DataRow(
                  cells: [
// ========================================================
// ORDER NUMBER
// ========================================================

                    DataCell(
                      Text(
                        shipment.orderNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF965DC2),
                        ),
                      ),
                    ),

// ========================================================
// DELIVERY PARTNER
// ========================================================

                    DataCell(
                      _buildDeliveryPartnerChip(
                        shipment.deliveryPartner,
                      ),
                    ),

// ========================================================
// TRACKING NUMBER
// ========================================================

                    DataCell(
                      Text(
                        shipment.trackingNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

// ========================================================
// AWB NUMBER
// ========================================================

                    DataCell(
                      Text(
                        shipment.awbNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

// ========================================================
// SHIPMENT ID
// ========================================================

                    DataCell(
                      Text(
                        shipment.shipmentId,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B6B74),
                        ),
                      ),
                    ),

// ========================================================
// SHIPPING STATUS
// ========================================================

                    DataCell(
                      _buildShippingStatusChip(
                        shipment.shippingStatus,
                      ),
                    ),

// ========================================================
// EXPECTED DELIVERY DATE
// ========================================================

                    DataCell(
                      Text(
                        _formatDate(
                          shipment.expectedDeliveryDate,
                        ),
                      ),
                    ),

// ========================================================
// ACTIONS
// ========================================================

                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Tooltip(
                            message: 'View Shipment',
                            child: IconButton(
                              onPressed: () {
                                onView(shipment);
                              },
                              icon: const Icon(
                                Icons.visibility_outlined,
                              ),
                              color: const Color(
                                0xFF965DC2,
                              ),
                            ),
                          ),

                          Tooltip(
                            message: 'Update Shipping Status',
                            child: IconButton(
                              onPressed: () {
                                onUpdateStatus(
                                  shipment,
                                );
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                              ),
                              color: const Color(
                                0xFF2563EB,
                              ),
                            ),
                          ),

                          Tooltip(
                            message: 'Cancel Shipment',
                            child: IconButton(
                              onPressed: shipment
                                  .shippingStatus
                                  .toUpperCase() ==
                                  'CANCELLED'
                                  ? null
                                  : () {
                                onCancel(
                                  shipment,
                                );
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                              ),
                              color: Colors.redAccent,
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
// DELIVERY PARTNER CHIP
// ============================================================

  Widget _buildDeliveryPartnerChip(
      String partner,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        partner.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Color(0xFF7C3AED),
        ),
      ),
    );
  }

// ============================================================
// SHIPPING STATUS CHIP
// ============================================================

  Widget _buildShippingStatusChip(
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
        backgroundColor = const Color(0xFFFFEEEE);
        textColor = const Color(0xFFDC2626);
        break;

      case 'OUT_FOR_DELIVERY':
        backgroundColor = const Color(0xFFEAF2FF);
        textColor = const Color(0xFF2563EB);
        break;

      case 'SHIPPED':
        backgroundColor = const Color(0xFFF3E8FF);
        textColor = const Color(0xFF7C3AED);
        break;

      case 'SHIPMENT_CREATED':
        backgroundColor = const Color(0xFFFFF7E6);
        textColor = const Color(0xFFD97706);
        break;

      default:
        backgroundColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF4B5563);
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
        normalized.replaceAll('_', ' '),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }

// ============================================================
// FORMAT DATE
// ============================================================

  String _formatDate(
      DateTime? date,
      ) {
    if (date == null) {
      return '-';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
