import 'package:flutter/material.dart';

import '../modal/shipment_modal.dart';

class UpdateShipmentStatusDialog
    extends StatefulWidget {
  final ShipmentListModel shipment;

  final Future<void> Function(
      String shippingStatus,
      ) onUpdate;

  const UpdateShipmentStatusDialog({
    super.key,
    required this.shipment,
    required this.onUpdate,
  });

  @override
  State<UpdateShipmentStatusDialog>
  createState() =>
      _UpdateShipmentStatusDialogState();
}

class _UpdateShipmentStatusDialogState
    extends State<UpdateShipmentStatusDialog> {
  late String selectedStatus;

  bool isUpdating = false;

  final List<String> statuses = [
    'SHIPMENT_CREATED',
    'SHIPPED',
    'OUT_FOR_DELIVERY',
    'DELIVERED',
    'CANCELLED',
  ];

  @override
  void initState() {
    super.initState();

    selectedStatus =
        widget.shipment.shippingStatus;

    if (!statuses.contains(
      selectedStatus,
    )) {
      selectedStatus =
      'SHIPMENT_CREATED';
    }
  }

  Future<void> _updateStatus() async {
    if (isUpdating) {
      return;
    }

    setState(() {
      isUpdating = true;
    });

    try {
      await widget.onUpdate(
        selectedStatus,
      );

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
          isUpdating = false;
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
              color: Color(0xFFEDE4F5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: Color(0xFF965DC2),
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              'Update Shipping Status',
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
        width: 420,
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              widget.shipment.orderNumber,
              style: const TextStyle(
                fontSize: 13,
                fontWeight:
                FontWeight.w700,
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
                Color(0xFF7A7A84),
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Shipping Status',
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedStatus,
              isExpanded: true,

              decoration:
              InputDecoration(
                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    10,
                  ),
                ),

                enabledBorder:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    10,
                  ),
                  borderSide:
                  const BorderSide(
                    color:
                    Color(0xFFE0E0E5),
                  ),
                ),
              ),

              items: statuses.map(
                    (status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status.replaceAll(
                        '_',
                        ' ',
                      ),
                    ),
                  );
                },
              ).toList(),

              onChanged: isUpdating
                  ? null
                  : (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedStatus =
                      value;
                });
              },
            ),

            const SizedBox(height: 16),

            Container(
              padding:
              const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                const Color(0xFFF8F5FA),
                borderRadius:
                BorderRadius.circular(
                  10,
                ),
              ),
              child: const Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.sync_alt_rounded,
                    size: 18,
                    color:
                    Color(0xFF965DC2),
                  ),

                  SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      'Updating the shipping status will also update the related order status.',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                        Color(0xFF6B6B74),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: isUpdating
              ? null
              : () {
            Navigator.pop(context);
          },
          child: const Text(
            'CANCEL',
          ),
        ),

        ElevatedButton(
          onPressed: isUpdating
              ? null
              : _updateStatus,

          style:
          ElevatedButton.styleFrom(
            backgroundColor:
            const Color(0xFF965DC2),
            foregroundColor:
            Colors.white,
            elevation: 0,
          ),

          child: isUpdating
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
            'UPDATE',
          ),
        ),
      ],
    );
  }
}
