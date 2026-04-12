import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/admin_booking.dart';
import '../widgets/status_badge.dart';
import '../../../core/constants/app_colors.dart';

/// A single row in the admin bookings list.
/// Shows guest name, room, dates, status, and action buttons.
///
/// [onConfirm] and [onCancel] are null when the action is not applicable
/// (e.g. can't confirm an already-confirmed booking).
class BookingListTile extends StatelessWidget {
  final AdminBooking booking;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final VoidCallback? onTap; // Opens detail bottom sheet

  const BookingListTile({
    super.key,
    required this.booking,
    this.onConfirm,
    this.onCancel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: name + status badge ──────────────────
            Row(
              children: [
                // Guest initials avatar
                _InitialsAvatar(name: booking.customerName),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.customerName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        booking.roomName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                StatusBadge(status: booking.status),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(height: 0.5, thickness: 0.5, color: AppColors.border),
            const SizedBox(height: 10),

            // ── Bottom row: dates + total + actions ───────────
            Row(
              children: [
                // Date range
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${fmt.format(booking.checkInDate)} – ${fmt.format(booking.checkOutDate)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${booking.nights} nights · \$${booking.totalRevenue.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons — only show when applicable
                if (onConfirm != null) ...[
                  _ActionButton(
                    label: 'Confirm',
                    color: AppColors.success,
                    onTap: onConfirm!,
                  ),
                  const SizedBox(width: 6),
                ],
                if (onCancel != null)
                  _ActionButton(
                    label: 'Cancel',
                    color: AppColors.error,
                    onTap: onCancel!,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Private: Initials Avatar ─────────────────────────────────────────────────

class _InitialsAvatar extends StatelessWidget {
  final String name;

  const _InitialsAvatar({required this.name});

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        // Light blue background
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          _initials,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.primary.withValues(alpha: 0.85),
          ),
        ),
      ),
    );
  }
}

// ─── Private: Small Action Button ────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}
