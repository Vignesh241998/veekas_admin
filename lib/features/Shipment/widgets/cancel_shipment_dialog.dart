import 'package:flutter/material.dart';

import '../modal/shipment_modal.dart';

class CancelShipmentDialog
    extends StatefulWidget {
  final ShipmentListModel shipment;

  final Future<void> Function() onCancelShipment;

  const CancelShipmentDialog({
    super.key,
    required this.shipment,
    required this.onCancelShipment,
  });

  @override
  State<CancelShipmentDialog> createState() =>
      _CancelShipmentDialogState();
}

class _CancelShipmentDialogState
    extends State<CancelShipmentDialog> {
  bool isCancelling = false;

  Future<void> _cancelShipment() async {
    if (isCancelling) {
      return;
    }

    setState(() {
      isCancelling = true;
    });

    try {
      await widget.onCancelShipment();

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
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
        setState(() {
          isCancelling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(18),
      ),

      title: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFFFEEEE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              'Cancel Shipment?',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w800,
              ),
            ),
          ),
        ],
      ),

      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to cancel this Shipment?',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color:
                Color(0xFF55555D),
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                const Color(0xFFF9F9FB),
                borderRadius:
                BorderRadius.circular(
                  10,
                ),
                border: Border.all(
                  color:
                  const Color(0xFFE7E7EC),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.shipment.orderNumber,
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.w800,
                      color:
                      Color(0xFF965DC2),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Tracking: ${widget.shipment.trackingNumber}',
                    style: const TextStyle(
                      fontSize: 12,
                      color:
                      Color(0xFF6B6B74),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Partner: ${widget.shipment.deliveryPartner}',
                    style: const TextStyle(
                      fontSize: 12,
                      color:
                      Color(0xFF6B6B74),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'The Shipment will become inactive and the related order status will be changed to CANCELLED.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.redAccent,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: isCancelling
              ? null
              : () {
            Navigator.pop(context);
          },
          child: const Text(
            'NO',
          ),
        ),

        ElevatedButton(
          onPressed: isCancelling
              ? null
              : _cancelShipment,

          style:
          ElevatedButton.styleFrom(
            backgroundColor:
            Colors.redAccent,
            foregroundColor:
            Colors.white,
            elevation: 0,
          ),

          child: isCancelling
              ? const SizedBox(
            height: 18,
            width: 18,
            child:
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
              AlwaysStoppedAnimation<
                  Color>(
                Colors.white,
              ),
            ),
          )
              : const Text(
            'YES, CANCEL',
          ),
        ),
      ],
    );
  }
}
