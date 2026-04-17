import 'dart:math';
import 'package:flutter_riverpod/legacy.dart';
import '../models/room_model.dart';
import '../models/booking_state.dart';

// ─── Mock Data: Australian Boutique Selection ───────────────────
final List<RoomModel> _mockRooms = [
  RoomModel(
    id: '1',
    name: 'The Arbour Guest House',
    location: 'Byron Bay, NSW',
    type: RoomType.deluxe,
    pricePerNight: 185,
    capacity: 4,
    rating: 4.9,
    reviewCount: 38,
    amenities: ['WiFi', 'Parking', 'Breakfast', 'Pet OK'],
    description:
        'A beautifully restored Queenslander nestled among lush hinterland gardens...',
  ),
  RoomModel(
    id: '2',
    name: 'Blue Gum Cottage',
    location: 'Daylesford, VIC',
    type: RoomType.standard,
    pricePerNight: 140,
    capacity: 2,
    rating: 4.7,
    reviewCount: 22,
    amenities: ['WiFi', 'Fireplace', 'Breakfast'],
    description: 'A cozy escape in the heart of the spa country...',
  ),
];

class BookingViewModel extends StateNotifier<BookingState> {
  BookingViewModel() : super(const BookingState());

  // ─── Date Selection (Fixed for HomeScreen) ─────────────────────
  void setCheckIn(DateTime date) {
    state = state.copyWith(checkInDate: date);
  }

  /// Resets the booking flow to its initial state
  void reset() {
    state = const BookingState();
  }

  void setGuestName(String name) {
    state = state.copyWith(guestName: name);
  }

  void setGuestPhone(String phone) {
    state = state.copyWith(guestPhone: phone);
  }

  void setGuestEmail(String email) {
    state = state.copyWith(guestEmail: email);
  }

  void setCheckOut(DateTime date) {
    state = state.copyWith(checkOutDate: date);
  }

  // ─── Guest Count ──────────────────────────────────────────────
  void incrementGuests() {
    if (state.guests < 4) {
      state = state.copyWith(guests: state.guests + 1);
    }
  }

  void decrementGuests() {
    if (state.guests > 1) {
      state = state.copyWith(guests: state.guests - 1);
    }
  }

  // ─── Business Logic ───────────────────────────────────────────
  List<RoomModel> getAvailableRooms() {
    return _mockRooms.where((r) => r.capacity >= state.guests).toList();
  }

  void selectRoom(RoomModel room) {
    state = state.copyWith(selectedRoom: room);
  }

  Future<void> confirmBooking() async {
    state = state.copyWith(status: BookingStatus.loading);
    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      state = state.copyWith(
        status: BookingStatus.confirmed,
        bookingReference: 'AU-${_generateRef()}',
      );
    } catch (e) {
      state = state.copyWith(status: BookingStatus.error);
    }
  }

  String _generateRef() {
    return Random().nextInt(999999).toString().padLeft(6, '0');
  }
}

final bookingProvider = StateNotifierProvider<BookingViewModel, BookingState>(
  (ref) => BookingViewModel(),
);
