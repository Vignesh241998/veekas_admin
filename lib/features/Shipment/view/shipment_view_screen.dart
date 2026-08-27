import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modal/shipment_modal.dart';
import '../viewmodal/shipment_view_modal.dart';
import '../widgets/cancel_shipment_dialog.dart';
import '../widgets/shipment_detail_dialog.dart';
import '../widgets/shipment_dialog.dart';
import '../widgets/shipment_table.dart';
import '../widgets/update_shipment_dialog.dart';

class ShipmentScreen
    extends ConsumerStatefulWidget {
  final int? orderId;
  final String? orderNumber;

  const ShipmentScreen({
    super.key,
    this.orderId,
    this.orderNumber,
  });

  @override
  ConsumerState<ShipmentScreen> createState() =>
      _ShipmentScreenState();
}

class _ShipmentScreenState
    extends ConsumerState<ShipmentScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(
        shipmentViewModelProvider
            .notifier,
      )
          .getShipments();
    });
  }

// ============================================================
// CREATE SHIPMENT
// ============================================================

  Future<void> _showCreateShipmentDialog() async {
    if (widget.orderId == null ||
        widget.orderNumber == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please create the shipment from the Orders screen.',
          ),
        ),
      );

      return;
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return CreateShipmentDialog(
          orderId: widget.orderId!,
          orderNumber: widget.orderNumber!,
          onCreate: (
              deliveryPartner,
              ) async {
            await ref
                .read(
              shipmentViewModelProvider
                  .notifier,
            )
                .createShipment(
              orderId: widget.orderId!,
              deliveryPartner:
              deliveryPartner,
            );
          },
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Shipment created successfully.',
          ),
        ),
      );
    }
  }

// ============================================================
// VIEW SHIPMENT DETAILS
// ============================================================

  Future<void> _viewShipmentDetails(
      ShipmentListModel shipment,
      ) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF965DC2),
            ),
          );
        },
      );

      final details = await ref
          .read(
        shipmentViewModelProvider
            .notifier,
      )
          .getShipmentDetails(
        shipment.id,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(
        context,
        rootNavigator: true,
      ).pop();

      await showDialog(
        context: context,
        builder: (dialogContext) {
          return ShipmentDetailDialog(
            shipment: details,
          );
        },
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      Navigator.of(
        context,
        rootNavigator: true,
      ).pop();

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
    }
  }

// ============================================================
// UPDATE SHIPPING STATUS
// ============================================================

  Future<void> _showUpdateStatusDialog(
      ShipmentListModel shipment,
      ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return UpdateShipmentStatusDialog(
          shipment: shipment,
          onUpdate: (
              shippingStatus,
              ) async {
            await ref
                .read(
              shipmentViewModelProvider
                  .notifier,
            )
                .updateShippingStatus(
              shipmentId: shipment.id,
              shippingStatus:
              shippingStatus,
            );
          },
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Shipping status updated successfully.',
          ),
        ),
      );
    }
  }

// ============================================================
// CANCEL SHIPMENT
// ============================================================

  Future<void> _showCancelShipmentDialog(
      ShipmentListModel shipment,
      ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return CancelShipmentDialog(
          shipment: shipment,
          onCancelShipment: () async {
            await ref
                .read(
              shipmentViewModelProvider
                  .notifier,
            )
                .cancelShipment(
              shipment.id,
            );
          },
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Shipment cancelled successfully.',
          ),
        ),
      );
    }
  }

// ============================================================
// BUILD
// ============================================================

  @override
  Widget build(BuildContext context) {
    final shipmentState =
    ref.watch(
      shipmentViewModelProvider,
    );

    return Scaffold(
      backgroundColor:
      const Color(0xFFF6F7FB),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: shipmentState.when(
// ====================================================
// LOADING
// ====================================================

          loading: () {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF965DC2),
              ),
            );
          },

// ====================================================
// ERROR
// ====================================================

          error: (
              error,
              stackTrace,
              ) {
            return _buildError(
              error.toString(),
            );
          },

// ====================================================
// DATA
// ====================================================

          data: (shipments) {
            final filteredShipments =
            _filterShipments(
              shipments,
            );

            return Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  shipments.length,
                ),

                const SizedBox(height: 24),

                _buildSearch(),

                const SizedBox(height: 20),

                Expanded(
                  child: filteredShipments.isEmpty
                      ? RefreshIndicator(
                    color: const Color(
                      0xFF965DC2,
                    ),
                    onRefresh: () {
                      return ref
                          .read(
                        shipmentViewModelProvider
                            .notifier,
                      )
                          .getShipments();
                    },
                    child: ListView(
                      physics:
                      const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 400,
                          child:
                          _buildEmpty(),
                        ),
                      ],
                    ),
                  )
                      : RefreshIndicator(
                    color: const Color(
                      0xFF965DC2,
                    ),
                    onRefresh: () {
                      return ref
                          .read(
                        shipmentViewModelProvider
                            .notifier,
                      )
                          .getShipments();
                    },
                    child:
                    SingleChildScrollView(
                      physics:
                      const AlwaysScrollableScrollPhysics(),
                      child: ShipmentTable(
                        shipments:
                        filteredShipments,

                        onView:
                        _viewShipmentDetails,

                        onUpdateStatus:
                        _showUpdateStatusDialog,

                        onCancel:
                        _showCancelShipmentDialog,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

// ============================================================
// HEADER
// ============================================================

  Widget _buildHeader(
      int totalShipments,
      ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Shipments',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight:
                  FontWeight.w800,
                  color:
                  Color(0xFF202124),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                '$totalShipments shipment${totalShipments == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 13,
                  color:
                  Color(0xFF7A7A84),
                ),
              ),
            ],
          ),
        ),

        if (widget.orderId != null &&
            widget.orderNumber != null)
          ElevatedButton.icon(
            onPressed:
            _showCreateShipmentDialog,
            icon: const Icon(
              Icons.add_rounded,
            ),
            label: const Text(
              'CREATE SHIPMENT',
            ),
            style:
            ElevatedButton.styleFrom(
              backgroundColor:
              const Color(0xFF965DC2),
              foregroundColor:
              Colors.white,
              elevation: 0,
              padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                  10,
                ),
              ),
            ),
          ),

        if (widget.orderId != null &&
            widget.orderNumber != null)
          const SizedBox(width: 12),

        ElevatedButton.icon(
          onPressed: () {
            ref
                .read(
              shipmentViewModelProvider
                  .notifier,
            )
                .getShipments();
          },
          icon: const Icon(
            Icons.refresh_rounded,
          ),
          label: const Text(
            'REFRESH',
          ),
          style:
          ElevatedButton.styleFrom(
            backgroundColor:
            Colors.white,
            foregroundColor:
            const Color(0xFF965DC2),
            elevation: 0,
            padding:
            const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 15,
            ),
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                10,
              ),
              side: const BorderSide(
                color: Color(0xFFE4E4E9),
              ),
            ),
          ),
        ),
      ],
    );
  }

// ============================================================
// SEARCH
// ============================================================

  Widget _buildSearch() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 500,
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText:
          'Search order, tracking, AWB or delivery partner',
          prefixIcon: const Icon(
            Icons.search_rounded,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFE4E4E9),
            ),
          ),
          enabledBorder:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFE4E4E9),
            ),
          ),
          focusedBorder:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF965DC2),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

// ============================================================
// FILTER
// ============================================================

  List<ShipmentListModel> _filterShipments(
      List<ShipmentListModel> shipments,
      ) {
    final query =
    searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return shipments;
    }

    return shipments.where(
          (shipment) {
        return shipment.orderNumber
            .toLowerCase()
            .contains(query) ||
            shipment.deliveryPartner
                .toLowerCase()
                .contains(query) ||
            shipment.trackingNumber
                .toLowerCase()
                .contains(query) ||
            shipment.awbNumber
                .toLowerCase()
                .contains(query) ||
            shipment.shipmentId
                .toLowerCase()
                .contains(query) ||
            shipment.shippingStatus
                .toLowerCase()
                .contains(query);
      },
    ).toList();
  }

// ============================================================
// EMPTY
// ============================================================

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Container(
            height: 90,
            width: 90,
            decoration:
            const BoxDecoration(
              color: Color(0xFFF0E5F7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              size: 42,
              color:
              Color(0xFF965DC2),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'No shipments found',
            style: TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Created shipments will appear here.',
            style: TextStyle(
              color:
              Color(0xFF85858D),
            ),
          ),

          if (widget.orderId != null)
            Padding(
              padding:
              const EdgeInsets.only(
                top: 20,
              ),
              child: ElevatedButton.icon(
                onPressed:
                _showCreateShipmentDialog,
                icon: const Icon(
                  Icons.add_rounded,
                ),
                label: const Text(
                  'CREATE SHIPMENT',
                ),
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(
                    0xFF965DC2,
                  ),
                  foregroundColor:
                  Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

// ============================================================
// ERROR
// ============================================================

  Widget _buildError(
      String error,
      ) {
    return Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 55,
            color: Colors.redAccent,
          ),

          const SizedBox(height: 15),

          const Text(
            'Unable to load shipments',
            style: TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            error.replaceFirst(
              'Exception: ',
              '',
            ),
            textAlign:
            TextAlign.center,
            style: const TextStyle(
              color:
              Color(0xFF85858D),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              ref
                  .read(
                shipmentViewModelProvider
                    .notifier,
              )
                  .getShipments();
            },
            style:
            ElevatedButton.styleFrom(
              backgroundColor:
              const Color(0xFF965DC2),
              foregroundColor:
              Colors.white,
            ),
            child: const Text(
              'RETRY',
            ),
          ),
        ],
      ),
    );
  }
}
