import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Blue card showing price breakdown: per-night rate, number of nights, total.
/// Shown on Screen 3 (Booking Form) so the guest knows the exact cost.
class PriceSummaryCard extends StatelessWidget {
  final double pricePerNight;
  final int nights;
  final double total;

  const PriceSummaryCard({
    super.key,
    required this.pricePerNight,
    required this.nights,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // Very light blue tint using withValues(alpha:) instead of withOpacity
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // Row 1 — price per night
          _PriceRow(
            label: 'Price per night',
            value: '\$${pricePerNight.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 6),

          // Row 2 — nights
          _PriceRow(
            label: 'Nights',
            value: '$nights night${nights > 1 ? 's' : ''}',
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              height: 0.5,
              thickness: 0.5,
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),

          // Row 3 — total (larger text, heavier weight)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Private: Label + Value Row ───────────────────────────────────────────────

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;

  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.primary.withValues(alpha: 0.8),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
