// ─── Admin Booking Model ──────────────────────────────────────────────────────
//
// Represents a booking row as seen by the admin panel.
// Includes all customer fields + the room name for display.

enum BookingStatusType { pending, confirmed, cancelled }

extension BookingStatusExtension on BookingStatusType {
  String get label {
    switch (this) {
      case BookingStatusType.pending:   return 'Pending';
      case BookingStatusType.confirmed: return 'Confirmed';
      case BookingStatusType.cancelled: return 'Cancelled';
    }
  }

  // String value sent to / received from Supabase
  String get dbValue {
    switch (this) {
      case BookingStatusType.pending:   return 'pending';
      case BookingStatusType.confirmed: return 'confirmed';
      case BookingStatusType.cancelled: return 'cancelled';
    }
  }

  static BookingStatusType fromString(String s) {
    switch (s) {
      case 'confirmed': return BookingStatusType.confirmed;
      case 'cancelled': return BookingStatusType.cancelled;
      default:          return BookingStatusType.pending;
    }
  }
}

class AdminBooking {
  final String id;
  final String roomId;
  final String roomName;     // Joined from rooms table
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final BookingStatusType status;
  final DateTime createdAt;
  final double pricePerNight; // Needed for revenue calculations

  const AdminBooking({
    required this.id,
    required this.roomId,
    required this.roomName,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    required this.createdAt,
    required this.pricePerNight,
  });

  // Number of nights for this booking
  int get nights => checkOutDate.difference(checkInDate).inDays;

  // Total revenue this booking generates
  double get totalRevenue => pricePerNight * nights;

  // Factory from Supabase joined query result
  factory AdminBooking.fromMap(Map<String, dynamic> map) {
    return AdminBooking(
      id:            map['id'] as String,
      roomId:        map['room_id'] as String,
      roomName:      map['rooms']['name'] as String,     // joined
      customerName:  map['customer_name'] as String,
      customerPhone: map['customer_phone'] as String,
      customerEmail: map['customer_email'] as String? ?? '',
      checkInDate:   DateTime.parse(map['check_in_date'] as String),
      checkOutDate:  DateTime.parse(map['check_out_date'] as String),
      status:        BookingStatusExtension.fromString(map['status'] as String),
      createdAt:     DateTime.parse(map['created_at'] as String),
      pricePerNight: (map['rooms']['price_per_night'] as num).toDouble(),
    );
  }

  // Returns a copy with a new status — used by confirm/cancel actions
  AdminBooking copyWithStatus(BookingStatusType newStatus) {
    return AdminBooking(
      id:            id,
      roomId:        roomId,
      roomName:      roomName,
      customerName:  customerName,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      checkInDate:   checkInDate,
      checkOutDate:  checkOutDate,
      status:        newStatus,
      createdAt:     createdAt,
      pricePerNight: pricePerNight,
    );
  }
}
