import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modal/order_modal.dart';
import '../viewmodal/order_view_modal.dart';

import '../../shipment/viewmodal/shipment_view_modal.dart';

import '../widgets/order_detail_dialog.dart';
import '../widgets/order_table.dart';
import '../widgets/update_order_dialog.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({
    super.key,
  });

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(
        orderViewModelProvider.notifier,
      )
          .getOrders();
    });
  }

  // ============================================================
  // VIEW ORDER DETAILS
  // ============================================================

  Future<void> _viewOrderDetails(
      OrderListModel order,
      ) async {
    bool loaderOpened = false;

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

      loaderOpened = true;

      final details = await ref
          .read(
        orderViewModelProvider.notifier,
      )
          .getOrderDetails(
        order.id,
      );

      if (!mounted) return;

      if (loaderOpened) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pop();

        loaderOpened = false;
      }

      await showDialog(
        context: context,
        builder: (dialogContext) {
          return OrderDetailDialog(
            order: details,
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      if (loaderOpened) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
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
  // UPDATE ORDER STATUS
  // ============================================================

  Future<void> _showUpdateStatusDialog(
      OrderListModel order,
      ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return UpdateOrderStatusDialog(
          order: order,
          onUpdate: (status) async {
            await ref
                .read(
              orderViewModelProvider.notifier,
            )
                .updateOrderStatus(
              orderId: order.id,
              orderStatus: status,
            );
          },
        );
      },
    );
  }

  // ============================================================
  // CREATE SHIPMENT
  // ============================================================

  Future<void> _showCreateShipmentDialog(
      OrderListModel order,
      ) async {
    String selectedDeliveryPartner = 'DELHIVERY';

    bool isCreating = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {
            Future<void> createShipment() async {
              if (isCreating) {
                return;
              }

              setDialogState(() {
                isCreating = true;
              });

              try {
                await ref
                    .read(
                  shipmentViewModelProvider.notifier,
                )
                    .createShipment(
                  orderId: order.id,
                  deliveryPartner:
                  selectedDeliveryPartner,
                );

                // Refresh order list
                await ref
                    .read(
                  orderViewModelProvider.notifier,
                )
                    .getOrders();

                if (!mounted) return;

                Navigator.of(
                  dialogContext,
                  rootNavigator: true,
                ).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor:
                    const Color(0xFF16A34A),
                    content: Text(
                      'shipment created successfully for ${order.orderNumber}',
                    ),
                  ),
                );
              } catch (e) {
                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
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
                  setDialogState(() {
                    isCreating = false;
                  });
                }
              }
            }

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
                      color: Color(0xFFE8F7EE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined,
                      color: Color(0xFF16A34A),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      'Create shipment',
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
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7A7A84),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      order.orderNumber,
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
                      value: selectedDeliveryPartner,
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
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E5),
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

                      items: const [
                        DropdownMenuItem(
                          value: 'DELHIVERY',
                          child: Text('Delhivery'),
                        ),
                      ],

                      onChanged: isCreating
                          ? null
                          : (value) {
                        if (value == null) {
                          return;
                        }

                        setDialogState(() {
                          selectedDeliveryPartner =
                              value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F5FA),
                        borderRadius:
                        BorderRadius.circular(10),
                        border: Border.all(
                          color:
                          const Color(0xFFE8E8EC),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: Color(0xFF965DC2),
                          ),

                          SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              'shipment details such as tracking number and AWB number will be generated automatically.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: Color(0xFF66666F),
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
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text(
                    'CANCEL',
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: isCreating
                      ? null
                      : createShipment,

                  icon: isCreating
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
                      : const Icon(
                    Icons.local_shipping_outlined,
                    size: 18,
                  ),

                  label: Text(
                    isCreating
                        ? 'CREATING...'
                        : 'CREATE SHIPMENT',
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
                      horizontal: 16,
                      vertical: 13,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final orderState =
    ref.watch(orderViewModelProvider);

    return Scaffold(
      backgroundColor:
      const Color(0xFFF6F7FB),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: orderState.when(
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

          data: (orders) {
            final filteredOrders =
            _filterOrders(orders);

            return Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  orders.length,
                ),

                const SizedBox(height: 24),

                _buildSearch(),

                const SizedBox(height: 20),

                Expanded(
                  child: filteredOrders.isEmpty
                      ? _buildEmpty()
                      : RefreshIndicator(
                    color:
                    const Color(0xFF965DC2),

                    onRefresh: () {
                      return ref
                          .read(
                        orderViewModelProvider
                            .notifier,
                      )
                          .getOrders();
                    },

                    child: SingleChildScrollView(
                      physics:
                      const AlwaysScrollableScrollPhysics(),

                      child: OrderTable(
                        orders:
                        filteredOrders,

                        onView:
                        _viewOrderDetails,

                        onUpdateStatus:
                        _showUpdateStatusDialog,

                        onCreateShipment:
                        _showCreateShipmentDialog,
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
      int totalOrders,
      ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Orders',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF202124),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                '$totalOrders customer order${totalOrders == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7A7A84),
                ),
              ),
            ],
          ),
        ),

        ElevatedButton.icon(
          onPressed: () {
            ref
                .read(
              orderViewModelProvider.notifier,
            )
                .getOrders();
          },

          icon: const Icon(
            Icons.refresh_rounded,
          ),

          label: const Text(
            'REFRESH',
          ),

          style: ElevatedButton.styleFrom(
            backgroundColor:
            const Color(0xFF965DC2),
            foregroundColor: Colors.white,
            elevation: 0,
            padding:
            const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 15,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(10),
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
        maxWidth: 450,
      ),

      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },

        decoration: InputDecoration(
          hintText:
          'Search order, customer or mobile',

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

          enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFE4E4E9),
            ),
          ),

          focusedBorder: OutlineInputBorder(
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

  List<OrderListModel> _filterOrders(
      List<OrderListModel> orders,
      ) {
    final query =
    searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return orders;
    }

    return orders.where(
          (order) {
        return order.orderNumber
            .toLowerCase()
            .contains(query) ||
            order.userName
                .toLowerCase()
                .contains(query) ||
            order.mobile
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: const BoxDecoration(
              color: Color(0xFFF0E5F7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 42,
              color: Color(0xFF965DC2),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'No orders found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Customer orders will appear here.',
            style: TextStyle(
              color: Color(0xFF85858D),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 55,
            color: Colors.redAccent,
          ),

          const SizedBox(height: 15),

          const Text(
            'Unable to load orders',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            error.replaceFirst(
              'Exception: ',
              '',
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF85858D),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              ref
                  .read(
                orderViewModelProvider.notifier,
              )
                  .getOrders();
            },

            style: ElevatedButton.styleFrom(
              backgroundColor:
              const Color(0xFF965DC2),
              foregroundColor: Colors.white,
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