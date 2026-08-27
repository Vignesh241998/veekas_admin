import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../View Modal/shippment_track_view_modal.dart';
import '../widgets/tracking_search_card.dart';
import '../widgets/tracking_status_card.dart';

class ShipmentTrackingScreen extends ConsumerStatefulWidget {
  final String trackno;


  const ShipmentTrackingScreen({
    super.key,
    required this.trackno
  });

  @override
  ConsumerState<ShipmentTrackingScreen>
  createState() =>
      _ShipmentTrackingScreenState();
}

class _ShipmentTrackingScreenState
    extends ConsumerState<ShipmentTrackingScreen> {

  final TextEditingController
  _trackingController =
  TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref
          .read(
        shipmentTrackingViewModelProvider
            .notifier,
      )
          .trackShipment(
        widget.trackno.toString(),
      );
    });
  }
  @override
  void dispose() {
    _trackingController.dispose();
    super.dispose();
  }

  // ============================================================
  // TRACK SHIPMENT
  // ============================================================

  Future<void> _trackShipment() async {
    final trackingNumber = widget.trackno.toString();
    // _trackingController.text.trim();

    if (trackingNumber.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a tracking number.',
          ),
        ),
      );

      return;
    }

    await ref
        .read(
      shipmentTrackingViewModelProvider
          .notifier,
    )
        .trackShipment(
      trackingNumber,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final trackingState =
    ref.watch(
      shipmentTrackingViewModelProvider,
    );

    final isLoading =
        trackingState.isLoading;

    return Scaffold(
      backgroundColor:
      const Color(0xFFF6F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Track Order',
          style: TextStyle(
            fontWeight:
            FontWeight.w800,
            color:
            Color(0xFF202124),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF202124),
        ),
      ),

      body: SafeArea(
        child: RefreshIndicator(
          color:
          const Color(0xFF965DC2),
          onRefresh: () async {
            final trackingNumber =
            _trackingController.text
                .trim();

            if (trackingNumber.isNotEmpty) {
              await ref
                  .read(
                shipmentTrackingViewModelProvider
                    .notifier,
              )
                  .trackShipment(
                trackingNumber,
              );
            }
          },
          child: ListView(
            physics:
            const AlwaysScrollableScrollPhysics(),
            padding:
            const EdgeInsets.all(16),
            children: [
              // TrackingSearchCard(
              //   controller:
              //   _trackingController,
              //   isLoading: isLoading,
              //   onTrack: _trackShipment,
              // ),

              const SizedBox(height: 20),

              trackingState.when(
                loading: () =>
                const Center(
                  child: Padding(
                    padding:
                    EdgeInsets.all(30),
                    child:
                    CircularProgressIndicator(
                      color:
                      Color(0xFF965DC2),
                    ),
                  ),
                ),

                error: (
                    error,
                    stackTrace,
                    ) =>
                    _buildError(
                      error
                          .toString()
                          .replaceFirst(
                        'Exception: ',
                        '',
                      ),
                    ),

                data: (
                    shipment,
                    ) {
                  if (shipment == null) {
                    return _buildInitialState();
                  }

                  return TrackingStatusCard(
                    shipment: shipment,
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INITIAL STATE
  // ============================================================

  Widget _buildInitialState() {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 40,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color:
          const Color(0xFFE8E8EC),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.location_searching_rounded,
            size: 60,
            color:
            Color(0xFF965DC2),
          ),

          SizedBox(height: 16),

          Text(
            'Track your shipment',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Enter your tracking number above to see the latest shipment status.',
            textAlign:
            TextAlign.center,
            style: TextStyle(
              color:
              Color(0xFF7A7A84),
              height: 1.5,
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
    return Container(
      padding:
      const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color:
          const Color(0xFFFFE0E0),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration:
            const BoxDecoration(
              color:
              Color(0xFFFFEEEE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color:
              Color(0xFFDC2626),
              size: 32,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Shipment not found',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            error.isEmpty
                ? 'Please check your tracking number and try again.'
                : error,
            textAlign:
            TextAlign.center,
            style: const TextStyle(
              color:
              Color(0xFF7A7A84),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          OutlinedButton.icon(
            onPressed: () {
              ref
                  .read(
                shipmentTrackingViewModelProvider
                    .notifier,
              )
                  .reset();

              _trackingController.clear();
            },
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label: const Text(
              'TRY AGAIN',
            ),
            style:
            OutlinedButton.styleFrom(
              foregroundColor:
              const Color(0xFF965DC2),
              side: const BorderSide(
                color:
                Color(0xFF965DC2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}