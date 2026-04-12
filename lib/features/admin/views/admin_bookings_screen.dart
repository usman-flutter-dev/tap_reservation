import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../models/admin_booking.dart';
import '../viewmodels/admin_bookings_viewmodel.dart';
import '../widgets/booking_list_tile.dart';
import '../widgets/status_badge.dart';
import '../../../core/constants/app_colors.dart';

/// ── Admin Screen 3: Bookings List ─────────────────────────────────────────────
///
/// Shows all bookings with filter tabs (All / Pending / Confirmed / Cancelled).
/// Admin can confirm or cancel pending bookings inline.
/// Tapping a row opens a detail bottom sheet.
class AdminBookingsScreen extends ConsumerWidget {
  const AdminBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminBookingsProvider);
    final vm = ref.read(adminBookingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: Get.back,
        ),
      ),
      body: Column(
        children: [
          // ── Filter tabs ──────────────────────────────────
          _FilterTabs(active: state.filterStatus, onSelect: vm.setFilter),

          const Divider(height: 0.5, thickness: 0.5, color: AppColors.border),

          // ── Bookings list ────────────────────────────────
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.filtered.isEmpty
                ? const _EmptyBookings()
                : ListView.separated(
                    padding: const EdgeInsets.all(14),
                    itemCount: state.filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) {
                      final booking = state.filtered[i];
                      return BookingListTile(
                        booking: booking,
                        // Only pending bookings can be confirmed
                        onConfirm: booking.status == BookingStatusType.pending
                            ? () => vm.confirmBooking(booking.id)
                            : null,
                        // Confirmed and pending bookings can be cancelled
                        onCancel: booking.status != BookingStatusType.cancelled
                            ? () => _confirmCancel(ctx, ref, booking.id)
                            : null,
                        onTap: () => _showDetail(ctx, booking),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog before cancelling (destructive action)
  void _confirmCancel(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Cancel booking?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'This will mark the booking as cancelled and free the room.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(adminBookingsProvider.notifier).cancelBooking(id);
            },
            child: const Text(
              'Cancel booking',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  /// Slide-up bottom sheet with full booking details
  void _showDetail(BuildContext context, AdminBooking booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => _BookingDetailSheet(booking: booking),
    );
  }
}

// ─── Private: Filter Tabs ─────────────────────────────────────────────────────

class _FilterTabs extends StatelessWidget {
  final BookingStatusType? active;
  final ValueChanged<BookingStatusType?> onSelect;

  const _FilterTabs({required this.active, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    // Tab definitions: null = show all
    final tabs = <MapEntry<BookingStatusType?, String>>[
      const MapEntry(null, 'All'),
      const MapEntry(BookingStatusType.pending, 'Pending'),
      const MapEntry(BookingStatusType.confirmed, 'Confirmed'),
      const MapEntry(BookingStatusType.cancelled, 'Cancelled'),
    ];

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.map((tab) {
            final isActive = tab.key == active;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onSelect(tab.key),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive ? AppColors.primary : AppColors.border,
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    tab.value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─── Private: Empty State ─────────────────────────────────────────────────────

class _EmptyBookings extends StatelessWidget {
  const _EmptyBookings();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 48, color: AppColors.textMuted),
          SizedBox(height: 12),
          Text(
            'No bookings found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Try a different filter',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─── Private: Booking Detail Bottom Sheet ────────────────────────────────────

class _BookingDetailSheet extends StatelessWidget {
  final AdminBooking booking;

  const _BookingDetailSheet({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title + status badge
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.customerName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              StatusBadge(status: booking.status),
            ],
          ),
          const SizedBox(height: 16),

          // Detail rows
          _DetailRow(label: 'Room', value: booking.roomName),
          _DetailRow(label: 'Phone', value: booking.customerPhone),
          if (booking.customerEmail.isNotEmpty)
            _DetailRow(label: 'Email', value: booking.customerEmail),
          _DetailRow(
            label: 'Check-in',
            value:
                '${booking.checkInDate.day}/${booking.checkInDate.month}/${booking.checkInDate.year}',
          ),
          _DetailRow(
            label: 'Check-out',
            value:
                '${booking.checkOutDate.day}/${booking.checkOutDate.month}/${booking.checkOutDate.year}',
          ),
          _DetailRow(label: 'Nights', value: '${booking.nights}'),
          _DetailRow(
            label: 'Total',
            value: '\$${booking.totalRevenue.toStringAsFixed(0)}',
            valueColor: AppColors.success,
            isBold: true,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

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
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isBold ? 14 : 13,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                  color: valueColor ?? AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFF3F4F6)),
      ],
    );
  }
}
