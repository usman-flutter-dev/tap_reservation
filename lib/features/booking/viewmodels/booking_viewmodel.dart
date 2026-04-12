import 'dart:math';
import 'package:flutter_riverpod/legacy.dart';

import '../models/room_model.dart';
import '../models/booking_state.dart';

// ─── Mock Data ─────────────────────────────────────────────────────────────────
// Replace with a Supabase query when connecting the backend:
//   final rooms = await supabase.from('rooms').select();
//   return rooms.map((r) => RoomModel.fromMap(r)).toList();

final List<RoomModel> _mockRooms = const [
  RoomModel(
    id: '1',
    name: 'Garden Suite',
    type: RoomType.suite,
    pricePerNight: 45,
    capacity: 2,
  ),
  RoomModel(
    id: '2',
    name: 'Family Deluxe',
    type: RoomType.deluxe,
    pricePerNight: 32,
    capacity: 4,
  ),
  RoomModel(
    id: '3',
    name: 'Standard Double',
    type: RoomType.standard,
    pricePerNight: 21,
    capacity: 2,
  ),
  RoomModel(
    id: '4',
    name: 'Executive Twin',
    type: RoomType.executive,
    pricePerNight: 58,
    capacity: 2,
  ),
];

// ─── ViewModel ─────────────────────────────────────────────────────────────────

/// The ViewModel in MVVM.
///
/// Responsibilities:
///   - Holds all booking logic (NO UI code here)
///   - Updates BookingState immutably using copyWith
///   - Views call methods here, they never touch Supabase directly
///
// / Extends StateNotifier<BookingState> from Riverpod:
///   - [state] is the current BookingState
///   - Set [state = ...] to trigger a rebuild in all watching widgets
class BookingViewModel extends StateNotifier<BookingState> {
  // Start with a default/empty state
  BookingViewModel() : super(const BookingState());

  // ─── Date Selection ───────────────────────────────────────────

  void setCheckIn(DateTime date) {
    state = state.copyWith(checkInDate: date);
  }

  void setCheckOut(DateTime date) {
    state = state.copyWith(checkOutDate: date);
  }

  // ─── Guest Count ──────────────────────────────────────────────

  void incrementGuests() {
    // Guard: never go above 8 guests
    if (state.guests < 8) {
      state = state.copyWith(guests: state.guests + 1);
    }
  }

  void decrementGuests() {
    // Guard: minimum 1 guest
    if (state.guests > 1) {
      state = state.copyWith(guests: state.guests - 1);
    }
  }

  // ─── Room Availability ────────────────────────────────────────

  /// Returns rooms whose capacity fits the selected guest count.
  ///
  /// Production replacement:
  ///   final rows = await supabase
  ///     .from('bookings')
  ///     .select('room_id')
  ///     .eq('status', 'confirmed')
  ///     .lte('check_in_date', checkOut)
  ///     .gte('check_out_date', checkIn);
  ///   final bookedIds = rows.map((r) => r['room_id']).toSet();
  ///   return allRooms.where((r) => !bookedIds.contains(r.id)).toList();
  List<RoomModel> getAvailableRooms() {
    return _mockRooms.where((r) => r.capacity >= state.guests).toList();
  }

  // ─── Room Selection ───────────────────────────────────────────

  /// Called when user taps "Select this room" on Screen 2
  void selectRoom(RoomModel room) {
    state = state.copyWith(selectedRoom: room);
  }

  // ─── Form Input ───────────────────────────────────────────────

  /// Each method is called via onChanged on the TextFormFields in Screen 3
  void setGuestName(String v) => state = state.copyWith(guestName: v);
  void setGuestPhone(String v) => state = state.copyWith(guestPhone: v);
  void setGuestEmail(String v) => state = state.copyWith(guestEmail: v);

  // ─── Booking Submission ───────────────────────────────────────

  /// Submits the booking and sets status to confirmed.
  ///
  /// Production replacement — swap the Future.delayed with:
  ///   await supabase.from('bookings').insert({
  ///     'room_id': state.selectedRoom!.id,
  ///     'customer_name': state.guestName,
  ///     'customer_phone': state.guestPhone,
  ///     'customer_email': state.guestEmail,
  ///     'check_in_date': state.checkInDate!.toIso8601String(),
  ///     'check_out_date': state.checkOutDate!.toIso8601String(),
  ///     'status': 'pending',
  ///   });
  Future<void> confirmBooking() async {
    // Show loading spinner in the UI
    state = state.copyWith(status: BookingStatus.loading);

    try {
      // TODO: Replace with real Supabase insert
      await Future.delayed(const Duration(milliseconds: 900));

      final ref = 'GH-${_generateRef()}';

      state = state.copyWith(
        status: BookingStatus.confirmed,
        bookingReference: ref,
      );
    } catch (e) {
      // If the DB constraint fires (double-booking), land here
      state = state.copyWith(
        status: BookingStatus.error,
        errorMessage: 'Room is no longer available. Please try another.',
      );
    }
  }

  // ─── Reset ────────────────────────────────────────────────────

  /// Clears all state — called after user taps "Make Another Booking"
  void reset() {
    state = const BookingState();
  }

  // ─── Private Helpers ─────────────────────────────────────────

  /// Generates a random 6-character alphanumeric reference code
  String _generateRef() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
  }
}

// ─── Riverpod Provider ────────────────────────────────────────────────────────

/// The global provider. Import this in any widget that needs booking state.
///
/// Usage in a widget:
///   final state = ref.watch(bookingProvider);         // rebuilds on change
///   final vm    = ref.read(bookingProvider.notifier); // call methods only
final bookingProvider = StateNotifierProvider<BookingViewModel, BookingState>(
  (ref) => BookingViewModel(),
);
