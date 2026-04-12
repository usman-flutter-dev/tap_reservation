import 'room_model.dart';

// ─── Booking Status ────────────────────────────────────────────────────────────

/// Tracks where in the booking lifecycle we are.
/// Views use this to show loading spinners or navigate forward.
enum BookingStatus {
  idle,       // Default — nothing has been submitted
  loading,    // Booking is being sent to the server
  confirmed,  // Booking succeeded — reference number generated
  error,      // Something went wrong
}

// ─── Booking State ────────────────────────────────────────────────────────────

/// The single source of truth for the entire booking flow.
///
/// This is an immutable value class — instead of mutating fields,
/// you call [copyWith] to create a new state with the updated fields.
/// Riverpod's StateNotifier then replaces the old state with the new one,
/// which triggers a UI rebuild automatically.
class BookingState {
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int guests;
  final RoomModel? selectedRoom;
  final String guestName;
  final String guestPhone;
  final String guestEmail;
  final BookingStatus status;
  final String? bookingReference;
  final String? errorMessage;

  const BookingState({
    this.checkInDate,
    this.checkOutDate,
    this.guests = 2,          // Default to 2 guests
    this.selectedRoom,
    this.guestName = '',
    this.guestPhone = '',
    this.guestEmail = '',
    this.status = BookingStatus.idle,
    this.bookingReference,
    this.errorMessage,
  });

  // ─── Computed Properties ─────────────────────────────────────

  /// Number of nights between check-in and check-out
  int get nights {
    if (checkInDate == null || checkOutDate == null) return 0;
    return checkOutDate!.difference(checkInDate!).inDays;
  }

  /// True only when both dates are selected and check-out is after check-in
  bool get hasValidDates {
    if (checkInDate == null || checkOutDate == null) return false;
    return checkOutDate!.isAfter(checkInDate!);
  }

  /// Total cost = price per night × number of nights
  double get totalCost {
    if (selectedRoom == null || nights == 0) return 0;
    return selectedRoom!.totalPrice(nights);
  }

  // ─── Copy With ───────────────────────────────────────────────

  /// Returns a new BookingState with only the specified fields replaced.
  /// Any field you don't pass will keep its current value.
  ///
  /// Example:
  ///   state = state.copyWith(guests: 3); // only guests changes
  BookingState copyWith({
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? guests,
    RoomModel? selectedRoom,
    String? guestName,
    String? guestPhone,
    String? guestEmail,
    BookingStatus? status,
    String? bookingReference,
    String? errorMessage,
  }) {
    return BookingState(
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      guests: guests ?? this.guests,
      selectedRoom: selectedRoom ?? this.selectedRoom,
      guestName: guestName ?? this.guestName,
      guestPhone: guestPhone ?? this.guestPhone,
      guestEmail: guestEmail ?? this.guestEmail,
      status: status ?? this.status,
      bookingReference: bookingReference ?? this.bookingReference,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
