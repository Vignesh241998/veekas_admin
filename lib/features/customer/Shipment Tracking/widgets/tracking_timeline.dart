import 'package:flutter/material.dart';

class TrackingTimeline extends StatelessWidget {
  final String currentStatus;

  const TrackingTimeline({
    super.key,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      'ORDER_PLACED',
      'CONFIRMED',
      'PACKED',
      'SHIPMENT_CREATED',
      'SHIPPED',
      'OUT_FOR_DELIVERY',
      'DELIVERED',
    ];

    final currentIndex =
    _getCurrentIndex(currentStatus);

    return Column(
      children: List.generate(
        steps.length,
            (index) {
          final step = steps[index];

          final isCompleted =
              currentIndex >= index;

          final isCurrent =
              currentIndex == index;

          return _buildStep(
            title: _getDisplayName(step),
            isCompleted: isCompleted,
            isCurrent: isCurrent,
            isLast:
            index == steps.length - 1,
          );
        },
      ),
    );
  }

  int _getCurrentIndex(
      String status,
      ) {
    final normalized =
    status.toUpperCase().trim();

    switch (normalized) {
      case 'PENDING':
      case 'ORDER_PLACED':
        return 0;

      case 'CONFIRMED':
        return 1;

      case 'PACKED':
        return 2;

      case 'SHIPMENT_CREATED':
        return 3;

      case 'SHIPPED':
        return 4;

      case 'OUT_FOR_DELIVERY':
        return 5;

      case 'DELIVERED':
        return 6;

      default:
        return -1;
    }
  }

  String _getDisplayName(
      String status,
      ) {
    switch (status) {
      case 'ORDER_PLACED':
        return 'Order Placed';

      case 'CONFIRMED':
        return 'Order Confirmed';

      case 'PACKED':
        return 'Order Packed';

      case 'SHIPMENT_CREATED':
        return 'shipment Created';

      case 'SHIPPED':
        return 'shipment Shipped';

      case 'OUT_FOR_DELIVERY':
        return 'Out for Delivery';

      case 'DELIVERED':
        return 'Delivered';

      default:
        return status.replaceAll('_', ' ');
    }
  }

  Widget _buildStep({
    required String title,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(
                      0xFF965DC2,
                    )
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted
                          ? const Color(
                        0xFF965DC2,
                      )
                          : const Color(
                        0xFFD7D7DE,
                      ),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_rounded
                        : Icons.circle,
                    size:
                    isCompleted ? 16 : 7,
                    color: isCompleted
                        ? Colors.white
                        : const Color(
                      0xFFD7D7DE,
                    ),
                  ),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets
                          .symmetric(
                        vertical: 4,
                      ),
                      color: isCompleted
                          ? const Color(
                        0xFF965DC2,
                      )
                          : const Color(
                        0xFFE5E5EA,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          Padding(
            padding:
            const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isCurrent
                        ? FontWeight.w800
                        : FontWeight.w600,
                    color: isCompleted
                        ? const Color(
                      0xFF202124,
                    )
                        : const Color(
                      0xFF9A9AA3,
                    ),
                  ),
                ),

                if (isCurrent) ...[
                  const SizedBox(height: 4),

                  const Text(
                    'Current shipment status',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(
                        0xFF965DC2,
                      ),
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}