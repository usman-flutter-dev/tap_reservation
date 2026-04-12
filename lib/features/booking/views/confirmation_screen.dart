import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../viewmodels/booking_viewmodel.dart';
import '../widgets/booking_reference_card.dart';
import '../../../core/constants/app_colors.dart';
import 'home_screen.dart';

/// ── Screen 4: Confirmation ────────────────────────────────────────────────────
///
/// Shown after a successful booking. Displays:
///   - Green success icon + title
///   - Booking reference code
///   - Full booking summary
///   - Pending status notice
///   - Button to start a new booking
class ConfirmationScreen extends ConsumerWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingProvider);
    final vm    = ref.read(bookingProvider.notifier);

    // Pre-format dates for the reference card
    final fmt = DateFormat('MMM d, yyyy');
    final checkIn  = state.checkInDate  != null ? fmt.format(state.checkInDate!)  : '—';
    final checkOut = state.checkOutDate != null ? fmt.format(state.checkOutDate!) : '—';

    return Scaffold(
      // No AppBar — this is a terminal screen, back is intentionally blocked
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
          child: Column(
            children: [
              // ── Success icon ─────────────────────────────────
              const _SuccessIcon(),
              const SizedBox(height: 16),

              // ── Heading ──────────────────────────────────────
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your room has been reserved successfully.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // ── Reference card with full summary ─────────────
              BookingReferenceCard(
                reference: state.bookingReference ?? '—',
                guestName: state.guestName,
                roomName:  state.selectedRoom?.name ?? '—',
                checkIn:  checkIn,
                checkOut: checkOut,
                nights: state.nights,
                total:  state.totalCost,
              ),
              const SizedBox(height: 14),

              // ── Pending status notice ─────────────────────────
              const _PendingNotice(),
              const SizedBox(height: 24),

              // ── New booking button ────────────────────────────
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    // Reset all booking state, then go back to Home
                    // offAll() clears the navigation stack completely
                    vm.reset();
                    Get.offAll(() => const HomeScreen());
                  },
                  child: const Text('Make Another Booking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Private: Success Icon ────────────────────────────────────────────────────

/// Green circle with a checkmark, shown at the top of the confirmation
class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        color: AppColors.successLight,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_rounded,
        color: AppColors.success,
        size: 38,
      ),
    );
  }
}

// ─── Private: Pending Notice ─────────────────────────────────────────────────

/// Amber info box explaining that the booking still needs admin approval
class _PendingNotice extends StatelessWidget {
  const _PendingNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.warning.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Your booking is pending — the guest house admin will review and confirm it shortly.',
              style: TextStyle(
                fontSize: 12,
                // Amber-800 for readable text on the yellow background
                color: Color(0xFF92400E),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
