import 'package:flutter/material.dart';

class CreateShipmentDialog
    extends StatefulWidget {
  final int orderId;
  final String orderNumber;

  final Future<void> Function(
      String deliveryPartner,
      ) onCreate;

  const CreateShipmentDialog({
    super.key,
    required this.orderId,
    required this.orderNumber,
    required this.onCreate,
  });

  @override
  State<CreateShipmentDialog> createState() =>
      _CreateShipmentDialogState();
}

class _CreateShipmentDialogState
    extends State<CreateShipmentDialog> {
  String selectedDeliveryPartner =
      'DELHIVERY';

  bool isCreating = false;

  final List<String> deliveryPartners = [
    'DELHIVERY',
    'SHIPROCKET',
    'BLUEDART',
    'DTDC',
    'EKART',
  ];

  Future<void> _createShipment() async {
    if (isCreating) {
      return;
    }

    setState(() {
      isCreating = true;
    });

    try {
      await widget.onCreate(
        selectedDeliveryPartner,
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
          isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
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
              'Create Shipment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),

      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Number',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF7A7A84),
              ),
            ),

            const SizedBox(height: 5),

            Text(
              widget.orderNumber,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF965DC2),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Delivery Partner',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value:
              selectedDeliveryPartner,
              isExpanded: true,

              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                ),

                enabledBorder:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(
                    color: Color(0xFFE0E0E5),
                  ),
                ),
              ),

              items: deliveryPartners.map(
                    (partner) {
                  return DropdownMenuItem(
                    value: partner,
                    child: Text(partner),
                  );
                },
              ).toList(),

              onChanged: isCreating
                  ? null
                  : (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedDeliveryPartner =
                      value;
                });
              },
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5FA),
                borderRadius:
                BorderRadius.circular(10),
              ),
              child: const Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: Color(0xFF965DC2),
                  ),

                  SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      'Tracking number, AWB number and shipment ID will be generated automatically.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B6B74),
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
          onPressed: isCreating
              ? null
              : () {
            Navigator.pop(context);
          },
          child: const Text(
            'CANCEL',
          ),
        ),

        ElevatedButton(
          onPressed: isCreating
              ? null
              : _createShipment,

          style: ElevatedButton.styleFrom(
            backgroundColor:
            const Color(0xFF965DC2),
            foregroundColor: Colors.white,
            elevation: 0,
          ),

          child: isCreating
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
            'CREATE SHIPMENT',
          ),
        ),
      ],
    );
  }
}
