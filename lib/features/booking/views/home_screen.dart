import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../viewmodels/booking_viewmodel.dart';
import '../widgets/date_picker_card.dart';
import '../widgets/guest_counter_widget.dart';
import '../widgets/room_type_chips.dart';
import '../../../core/constants/app_colors.dart';
import 'available_rooms_screen.dart';

/// ── Screen 1: Home ────────────────────────────────────────────────────────────
///
/// The entry screen. User selects dates + guest count, then taps Search.
///
/// Architecture notes:
///   - ConsumerWidget = Riverpod's version of StatelessWidget
///   - ref.watch() reads state AND rebuilds the widget on change
///   - ref.read()  reads state WITHOUT subscribing (used for one-off actions)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state — widget rebuilds whenever dates or guests change
    final state = ref.watch(bookingProvider);

    // Read the ViewModel to call methods (no need to re-read on state change)
    final vm = ref.read(bookingProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Blue hero header ─────────────────────────────
              const _HeroHeader(),

              // ── Search area ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Date picker (check-in + check-out)
                    DatePickerCard(
                      checkIn: state.checkInDate,
                      checkOut: state.checkOutDate,
                      onCheckInSelected: vm.setCheckIn,
                      onCheckOutSelected: vm.setCheckOut,
                    ),
                    const SizedBox(height: 12),

                    // Guest +/- counter
                    GuestCounterWidget(
                      count: state.guests,
                      onIncrement: vm.incrementGuests,
                      onDecrement: vm.decrementGuests,
                    ),
                    const SizedBox(height: 14),

                    // Search button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _onSearchTapped(context, ref),
                        child: const Text('Search Available Rooms'),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Room type preview chips ──────────────────────
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 28),
                child: RoomTypeChips(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Validates date selection before navigating forward.
  void _onSearchTapped(BuildContext context, WidgetRef ref) {
    final state = ref.read(bookingProvider);

    // Check if dates are valid before proceeding
    if (!state.hasValidDates) {
      // GetX snackbar — no need for a ScaffoldMessenger
      Get.snackbar(
        'Invalid Dates',
        'Please select check-in and check-out dates.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error.withValues(alpha: 0.1),
        colorText: AppColors.error,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Navigate to Screen 2
    Get.to(() => const AvailableRoomsScreen());
  }
}

// ─── Private: Hero Header ─────────────────────────────────────────────────────

/// Blue banner at the top of the Home screen
class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property name — small, uppercase, faded
          Text(
            'GUEST HOUSE',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 10),

          // Main headline
          const Text(
            'Find your\nperfect stay',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Melbourne, Australia · Est. 1947',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
