import 'package:flutter/material.dart';

import '../shipment_tracking_modal.dart';
import 'tracking_timeline.dart';

class TrackingStatusCard extends StatelessWidget {
  final ShipmentTrackingModel shipment;

  const TrackingStatusCard({
    super.key,
    required this.shipment,
  });

  @override
  Widget build(BuildContext context) {
    final status =
    shipment.shippingStatus
        .toUpperCase()
        .trim();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: const Color(
            0xFFE8E8EC,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Shipment Status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.w800,
                    color: Color(
                      0xFF202124,
                    ),
                  ),
                ),
              ),

              _buildStatusChip(status),
            ],
          ),

          const SizedBox(height: 24),

          _buildInfoRow(
            icon:
            Icons.confirmation_number_outlined,
            label: 'Tracking Number',
            value: shipment.trackingNumber,
          ),

          const SizedBox(height: 16),

          _buildInfoRow(
            icon:
            Icons.local_shipping_outlined,
            label: 'Delivery Partner',
            value: shipment.deliveryPartner,
          ),

          const SizedBox(height: 16),

          _buildInfoRow(
            icon:
            Icons.calendar_month_outlined,
            label: 'Expected Delivery',
            value: _formatDate(
              shipment.expectedDeliveryDate,
            ),
          ),

          const SizedBox(height: 28),

          const Divider(),

          const SizedBox(height: 24),

          const Text(
            'Tracking Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.w800,
              color: Color(0xFF202124),
            ),
          ),

          const SizedBox(height: 24),

          TrackingTimeline(
            currentStatus:
            shipment.shippingStatus,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
      String status,
      ) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'DELIVERED':
        backgroundColor =
        const Color(0xFFE8F7EE);
        textColor =
        const Color(0xFF16A34A);
        break;

      case 'OUT_FOR_DELIVERY':
        backgroundColor =
        const Color(0xFFEAF2FF);
        textColor =
        const Color(0xFF2563EB);
        break;

      case 'SHIPPED':
        backgroundColor =
        const Color(0xFFE0F2FE);
        textColor =
        const Color(0xFF0284C7);
        break;

      case 'CANCELLED':
        backgroundColor =
        const Color(0xFFFFEEEE);
        textColor =
        const Color(0xFFDC2626);
        break;

      default:
        backgroundColor =
        const Color(0xFFF3E8FF);
        textColor =
        const Color(0xFF7C3AED);
    }

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(
          fontSize: 11,
          fontWeight:
          FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color:
            const Color(0xFFF8F5FA),
            borderRadius:
            BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(
              0xFF965DC2,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color:
                  Color(0xFF7A7A84),
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value.isEmpty
                    ? '-'
                    : value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w700,
                  color:
                  Color(0xFF202124),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(
      DateTime? date,
      ) {
    if (date == null) {
      return 'Not available';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}