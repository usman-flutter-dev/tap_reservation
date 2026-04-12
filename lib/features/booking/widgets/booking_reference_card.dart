import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Card showing the booking reference code + full summary.
/// Shown on Screen 4 (Confirmation) after successful booking.
class BookingReferenceCard extends StatelessWidget {
  final String reference;
  final String guestName;
  final String roomName;
  final String checkIn;   // Pre-formatted string e.g. "May 15, 2025"
  final String checkOut;
  final int nights;
  final double total;

  const BookingReferenceCard({
    super.key,
    required this.reference,
    required this.guestName,
    required this.roomName,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      // Clip so the blue header respects the rounded top corners
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Blue header: reference code ──────────────────────
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                Text(
                  'BOOKING REFERENCE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  reference,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 4, // Spaced out for a reference-code look
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),

          // ── Detail rows ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Column(
              children: [
                _DetailRow(label: 'Guest',    value: guestName),
                _DetailRow(label: 'Room',     value: roomName),
                _DetailRow(label: 'Check-in', value: checkIn),
                _DetailRow(label: 'Check-out',value: checkOut),
                _DetailRow(
                  label: 'Duration',
                  value: '$nights night${nights > 1 ? 's' : ''}',
                ),
                _DetailRow(
                  label: 'Total',
                  value: '\$${total.toStringAsFixed(0)}',
                  // Green color highlights the final cost
                  valueColor: AppColors.success,
                  isBold: true,
                  isLast: true,   // Suppresses the divider below this row
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Private: Single Detail Row ──────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isBold ? 14 : 12,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                  color: valueColor ?? AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        // Thin separator between rows — omitted after the last row
        if (!isLast)
          const Divider(
            height: 0.5,
            thickness: 0.5,
            color: Color(0xFFF3F4F6),
          ),
      ],
    );
  }
}
