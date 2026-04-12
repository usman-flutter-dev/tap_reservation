import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/admin_booking.dart';
import '../viewmodels/admin_bookings_viewmodel.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/status_badge.dart';
import '../../../core/constants/app_colors.dart';

/// ── Admin Screen 5: Calendar View ─────────────────────────────────────────────
///
/// Month grid showing which dates have bookings (color-coded by status).
/// Tapping a date shows a list of bookings for that day in a bottom sheet.
class AdminCalendarScreen extends ConsumerWidget {
  const AdminCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: Get.back,
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Month calendar widget ────────────────────
                  CalendarWidget(
                    bookings: state.bookings,
                    onDateSelected: (bookingsOnDate) =>
                        _showDayDetail(context, bookingsOnDate),
                  ),

                  const SizedBox(height: 20),

                  // ── Upcoming confirmed stays list ────────────
                  const Text(
                    'UPCOMING CONFIRMED STAYS',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Filter to only confirmed, sorted by check-in
                  ..._upcomingConfirmed(state.bookings)
                      .map((b) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _UpcomingTile(booking: b),
                          )),

                  if (_upcomingConfirmed(state.bookings).isEmpty)
                    const Text(
                      'No upcoming confirmed stays.',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                ],
              ),
            ),
    );
  }

  /// Returns confirmed bookings whose check-in is in the future, sorted soonest first
  List<AdminBooking> _upcomingConfirmed(List<AdminBooking> all) {
    final now = DateTime.now();
    return all
        .where((b) =>
            b.status == BookingStatusType.confirmed &&
            b.checkInDate.isAfter(now))
        .toList()
      ..sort((a, b) => a.checkInDate.compareTo(b.checkInDate));
  }

  /// Shows which bookings fall on the tapped date
  void _showDayDetail(BuildContext context, List<AdminBooking> bookings) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => _DayDetailSheet(bookings: bookings),
    );
  }
}

// ─── Private: Day Detail Bottom Sheet ────────────────────────────────────────

class _DayDetailSheet extends StatelessWidget {
  final List<AdminBooking> bookings;

  const _DayDetailSheet({required this.bookings});

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
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: AppColors.border, borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            '${bookings.length} booking${bookings.length > 1 ? 's' : ''} on this date',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 14),

          ...bookings.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.customerName,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text(b.roomName,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  StatusBadge(status: b.status),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}

// ─── Private: Upcoming Confirmed Tile ────────────────────────────────────────

class _UpcomingTile extends StatelessWidget {
  final AdminBooking booking;

  const _UpcomingTile({required this.booking});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d');
    // Days until check-in
    final daysUntil = booking.checkInDate.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          // Green check-in countdown bubble
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$daysUntil',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
                const Text(
                  'days',
                  style: TextStyle(fontSize: 9, color: AppColors.success),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.customerName,
                  style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${booking.roomName}  ·  ${fmt.format(booking.checkInDate)} – ${fmt.format(booking.checkOutDate)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          Text(
            '\$${booking.totalRevenue.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
