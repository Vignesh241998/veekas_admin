import 'package:flutter/material.dart';

import '../modal/shipment_modal.dart';

class ShipmentDetailDialog extends StatelessWidget {
  final ShipmentDetailModel shipment;

  const ShipmentDetailDialog({
    super.key,
    required this.shipment,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 850,
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShipmentInformation(),

                    const SizedBox(height: 24),

                    _buildTrackingInformation(),

                    const SizedBox(height: 24),

                    _buildOrderInformation(),

                    const SizedBox(height: 24),

                    _buildCustomerInformation(),

                    const SizedBox(height: 24),

                    _buildDeliveryAddress(),
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
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: const BoxDecoration(
              color: Color(0xFFF0E5F7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: Color(0xFF965DC2),
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Text(
              'shipment Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
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
// SHIPMENT INFORMATION
// ============================================================

  Widget _buildShipmentInformation() {
    return _buildSection(
      title: 'shipment Information',
      icon: Icons.local_shipping_outlined,
      child: Column(
        children: [
          _buildInfoRow(
            'Delivery Partner',
            shipment.deliveryPartner,
          ),

          _buildInfoRow(
            'Shipping Status',
            shipment.shippingStatus.replaceAll(
              '_',
              ' ',
            ),
          ),

          _buildInfoRow(
            'Status',
            shipment.status,
          ),

          _buildInfoRow(
            'shipment ID',
            shipment.shipmentId,
          ),
        ],
      ),
    );
  }

// ============================================================
// TRACKING INFORMATION
// ============================================================

  Widget _buildTrackingInformation() {
    return _buildSection(
      title: 'Tracking Information',
      icon: Icons.location_searching_outlined,
      child: Column(
        children: [
          _buildInfoRow(
            'Tracking Number',
            shipment.trackingNumber,
          ),

          _buildInfoRow(
            'AWB Number',
            shipment.awbNumber,
          ),

          _buildInfoRow(
            'Pickup Date',
            _formatDateTime(
              shipment.pickupDate,
            ),
          ),

          _buildInfoRow(
            'Expected Delivery',
            _formatDate(
              shipment.expectedDeliveryDate,
            ),
          ),

          _buildInfoRow(
            'Label URL',
            shipment.labelUrl.isEmpty
                ? '-'
                : shipment.labelUrl,
          ),
        ],
      ),
    );
  }

// ============================================================
// ORDER INFORMATION
// ============================================================

  Widget _buildOrderInformation() {
    final order = shipment.order;

    return _buildSection(
      title: 'Order Information',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          _buildInfoRow(
            'Order Number',
            order?.orderNumber ?? '-',
          ),

          _buildInfoRow(
            'Order Status',
            order?.orderStatus
                .replaceAll('_', ' ') ??
                '-',
          ),

          _buildInfoRow(
            'Order Total',
            order != null
                ? '₹${order.grandTotal.toStringAsFixed(2)}'
                : '-',
          ),
        ],
      ),
    );
  }

// ============================================================
// CUSTOMER INFORMATION
// ============================================================

  Widget _buildCustomerInformation() {
    final customer = shipment.order?.user;

    return _buildSection(
      title: 'Customer Information',
      icon: Icons.person_outline_rounded,
      child: Column(
        children: [
          _buildInfoRow(
            'Name',
            customer?.fullName ?? '-',
          ),

          _buildInfoRow(
            'Mobile',
            customer?.mobile ?? '-',
          ),

          _buildInfoRow(
            'Email',
            customer?.email ?? '-',
          ),
        ],
      ),
    );
  }

// ============================================================
// DELIVERY ADDRESS
// ============================================================

  Widget _buildDeliveryAddress() {
    final address = shipment.order?.address;

    return _buildSection(
      title: 'Delivery Address',
      icon: Icons.location_on_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address?.fullName ?? '-',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            address?.mobile ?? '-',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B6B74),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            address?.fullAddress ??
                'Address not available',
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF55555D),
            ),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE7E7EC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: const Color(0xFF965DC2),
              ),

              const SizedBox(width: 9),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
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

// ============================================================
// INFO ROW
// ============================================================

  Widget _buildInfoRow(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF7A7A84),
              ),
            ),
          ),

          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3F3F46),
              ),
            ),
          ),
        ],
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

// ============================================================
// FORMAT DATE TIME
// ============================================================

  String _formatDateTime(
      DateTime? date,
      ) {
    if (date == null) {
      return '-';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
