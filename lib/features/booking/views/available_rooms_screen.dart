import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../viewmodels/booking_viewmodel.dart';
import '../widgets/room_card_widget.dart';
import '../../../core/constants/app_colors.dart';
import 'booking_form_screen.dart';

/// ── Screen 2: Available Rooms ─────────────────────────────────────────────────
///
/// Lists rooms filtered by the guest count chosen on Screen 1.
/// User taps a room card to proceed to the booking form.
class AvailableRoomsScreen extends ConsumerWidget {
  const AvailableRoomsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingProvider);
    final vm = ref.read(bookingProvider.notifier);

    // Filter rooms based on selected guest count
    final availableRooms = vm.getAvailableRooms();

    // Build the date label shown in the sub-header (e.g. "May 15 – May 18 · 3 nights")
    final fmt = DateFormat('MMM d');
    final dateLabel = state.hasValidDates
        ? '${fmt.format(state.checkInDate!)} – ${fmt.format(state.checkOutDate!)} '
              '· ${state.nights} night${state.nights > 1 ? 's' : ''}'
        : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Rooms'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          // GetX: go back to the previous screen
          onPressed: Get.back,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Summary header ───────────────────────────────────
          _SearchSummaryHeader(
            count: availableRooms.length,
            dateLabel: dateLabel,
            guests: state.guests,
          ),

          const Divider(height: 0.5, thickness: 0.5, color: AppColors.border),

          // ── Room list ────────────────────────────────────────
          Expanded(
            child: availableRooms.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: availableRooms.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final room = availableRooms[index];
                      return RoomCardWidget(
                        room: room,
                        nights: state.nights,
                        onSelect: () {
                          // Save selected room to state, then navigate
                          vm.selectRoom(room);
                          Get.to(() => const BookingFormScreen());
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Private: Summary Header ─────────────────────────────────────────────────

class _SearchSummaryHeader extends StatelessWidget {
  final int count;
  final String dateLabel;
  final int guests;

  const _SearchSummaryHeader({
    required this.count,
    required this.dateLabel,
    required this.guests,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count room${count != 1 ? 's' : ''} available',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$dateLabel  ·  $guests guest${guests > 1 ? 's' : ''}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Private: Empty State ────────────────────────────────────────────────────

/// Shown when no rooms can accommodate the selected guest count
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bed_outlined,
              size: 52,
              color: AppColors.textMuted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 14),
            const Text(
              'No rooms available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try reducing the number of guests\nor adjusting your dates.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            TextButton(
              // Go back to adjust the search
              onPressed: Get.back,
              child: const Text('Go back and adjust'),
            ),
          ],
        ),
      ),
    );
  }
}
