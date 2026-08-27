import 'package:flutter/material.dart';

class TrackingSearchCard extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onTrack;

  const TrackingSearchCard({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE8E8EC),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Track Your Order',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF202124),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Enter your tracking number to check the current shipment status.',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF7A7A84),
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: controller,
            enabled: !isLoading,
            textCapitalization:
            TextCapitalization.characters,
            onSubmitted: (_) {
              if (!isLoading) {
                onTrack();
              }
            },
            decoration: InputDecoration(
              hintText:
              'Enter tracking number',
              prefixIcon: const Icon(
                Icons.local_shipping_outlined,
                color: Color(0xFF965DC2),
              ),
              filled: true,
              fillColor:
              const Color(0xFFFAFAFC),
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE4E4E9),
                ),
              ),
              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE4E4E9),
                ),
              ),
              focusedBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF965DC2),
                  width: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed:
              isLoading ? null : onTrack,
              icon: isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
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
                Icons.search_rounded,
              ),
              label: Text(
                isLoading
                    ? 'TRACKING...'
                    : 'TRACK ORDER',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF965DC2),
                foregroundColor:
                Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}