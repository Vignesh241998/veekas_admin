import 'package:flutter/material.dart';

import '../modal/order_modal.dart';

class UpdateOrderStatusDialog
    extends StatefulWidget {
  final OrderListModel order;
  final Future<void> Function(
      String status,
      ) onUpdate;

  const UpdateOrderStatusDialog({
    super.key,
    required this.order,
    required this.onUpdate,
  });

  @override
  State<UpdateOrderStatusDialog>
  createState() =>
      _UpdateOrderStatusDialogState();
}

class _UpdateOrderStatusDialogState
    extends State<UpdateOrderStatusDialog> {
  late String selectedStatus;

  bool isUpdating = false;

  final List<String> statuses = [
    'PENDING',
    'CONFIRMED',
    'PACKED',
    'SHIPMENT_CREATED',
    'SHIPPED',
    'OUT_FOR_DELIVERY',
    'DELIVERED',
    'CANCELLED',
    'RETURN_REQUESTED',
    'RETURNED',
  ];

  @override
  void initState() {
    super.initState();

    selectedStatus =
        widget.order.orderStatus;
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

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

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
            decoration:
            const BoxDecoration(
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
              'Update Order Status',
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
              widget.order.orderNumber,
              style: const TextStyle(
                fontSize: 13,
                fontWeight:
                FontWeight.w700,
                color:
                Color(0xFF965DC2),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Order Status',
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

            const SizedBox(height: 20),

// PAYMENT STATUS IS READ ONLY

            const Text(
              'Payment Status (Read Only)',
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                FontWeight.w700,
                color:
                Color(0xFF7A7A84),
              ),
            ),

            const SizedBox(height: 6),

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color:
                const Color(0xFFF7F7F9),
                borderRadius:
                BorderRadius.circular(
                  9,
                ),
                border: Border.all(
                  color:
                  const Color(0xFFE4E4E9),
                ),
              ),
              child: Text(
                widget.order.paymentStatus,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w700,
                  color:
                  Color(0xFF6B6B74),
                ),
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
