import 'package:flutter_riverpod/legacy.dart';
import 'package:tap_reservation/features/admin/models/admin_booking.dart';
import 'package:tap_reservation/features/booking/models/room_model.dart';

// ─── Admin Bookings State ─────────────────────────────────────────────────────

class AdminBookingsState {
  final List<AdminBooking> bookings;
  final bool isLoading;
  final String? errorMessage;
  // Which status filter tab is active: null = all
  final BookingStatusType? filterStatus;

  const AdminBookingsState({
    this.bookings = const [],
    this.isLoading = false,
    this.errorMessage,
    this.filterStatus,
  });

  // Bookings after the active filter is applied
  List<AdminBooking> get filtered {
    if (filterStatus == null) return bookings;
    return bookings.where((b) => b.status == filterStatus).toList();
  }

  // ── Dashboard metrics ──────────────────────────────────────────────────────

  int get totalBookings => bookings.length;

  int get pendingCount =>
      bookings.where((b) => b.status == BookingStatusType.pending).length;

  int get confirmedCount =>
      bookings.where((b) => b.status == BookingStatusType.confirmed).length;

  // Total revenue from confirmed bookings only
  double get totalRevenue => bookings
      .where((b) => b.status == BookingStatusType.confirmed)
      .fold(0.0, (sum, b) => sum + b.totalRevenue);

  AdminBookingsState copyWith({
    List<AdminBooking>? bookings,
    bool? isLoading,
    String? errorMessage,
    BookingStatusType? filterStatus,
    bool clearFilter = false, // Pass true to set filterStatus → null
  }) {
    return AdminBookingsState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      filterStatus: clearFilter ? null : (filterStatus ?? this.filterStatus),
    );
  }
}

// ─── Admin Bookings ViewModel ─────────────────────────────────────────────────

class AdminBookingsViewModel extends StateNotifier<AdminBookingsState> {
  AdminBookingsViewModel() : super(const AdminBookingsState()) {
    // Auto-load on creation
    loadBookings();
  }

  // ── Load all bookings ─────────────────────────────────────────────────────
  //
  // TODO: Replace with Supabase query:
  //   final rows = await supabase
  //     .from('bookings')
  //     .select('*, rooms(name, price_per_night)')
  //     .order('created_at', ascending: false);
  //   return rows.map(AdminBooking.fromMap).toList();

  Future<void> loadBookings() async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 600)); // Mock delay

      // ── Mock data — remove when connecting Supabase ───────────────────────
      final now = DateTime.now();
      state = state.copyWith(
        isLoading: false,
        bookings: [
          AdminBooking(
            id: 'b001',
            roomId: '1',
            roomName: 'Garden Suite',
            customerName: 'Ahmed Khan',
            customerPhone: '+1 555-0101',
            customerEmail: 'ahmed@example.com',
            checkInDate: now.add(const Duration(days: 2)),
            checkOutDate: now.add(const Duration(days: 5)),
            status: BookingStatusType.pending,
            createdAt: now.subtract(const Duration(hours: 3)),
            pricePerNight: 45,
          ),
          AdminBooking(
            id: 'b002',
            roomId: '2',
            roomName: 'Family Deluxe',
            customerName: 'Sara Malik',
            customerPhone: '+1 555-0202',
            customerEmail: 'sara@example.com',
            checkInDate: now.add(const Duration(days: 1)),
            checkOutDate: now.add(const Duration(days: 4)),
            status: BookingStatusType.confirmed,
            createdAt: now.subtract(const Duration(days: 1)),
            pricePerNight: 32,
          ),
          AdminBooking(
            id: 'b003',
            roomId: '3',
            roomName: 'Standard Double',
            customerName: 'Ali Raza',
            customerPhone: '+1 555-0303',
            customerEmail: '',
            checkInDate: now.subtract(const Duration(days: 2)),
            checkOutDate: now,
            status: BookingStatusType.confirmed,
            createdAt: now.subtract(const Duration(days: 5)),
            pricePerNight: 21,
          ),
          AdminBooking(
            id: 'b004',
            roomId: '4',
            roomName: 'Executive Twin',
            customerName: 'Zara Hussain',
            customerPhone: '+1 555-0404',
            customerEmail: 'zara@example.com',
            checkInDate: now.add(const Duration(days: 6)),
            checkOutDate: now.add(const Duration(days: 9)),
            status: BookingStatusType.cancelled,
            createdAt: now.subtract(const Duration(days: 2)),
            pricePerNight: 58,
          ),
          AdminBooking(
            id: 'b005',
            roomId: '1',
            roomName: 'Garden Suite',
            customerName: 'Omar Sheikh',
            customerPhone: '+1 555-0505',
            customerEmail: 'omar@example.com',
            checkInDate: now.add(const Duration(days: 10)),
            checkOutDate: now.add(const Duration(days: 13)),
            status: BookingStatusType.pending,
            createdAt: now.subtract(const Duration(hours: 1)),
            pricePerNight: 45,
          ),
        ],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load bookings.',
      );
    }
  }

  // ── Confirm booking ───────────────────────────────────────────────────────
  //
  // TODO: await supabase.from('bookings').update({'status': 'confirmed'}).eq('id', id);

  Future<void> confirmBooking(String id) async {
    _updateStatus(id, BookingStatusType.confirmed);
  }

  // ── Cancel booking ────────────────────────────────────────────────────────
  //
  // TODO: await supabase.from('bookings').update({'status': 'cancelled'}).eq('id', id);

  Future<void> cancelBooking(String id) async {
    _updateStatus(id, BookingStatusType.cancelled);
  }

  // Shared helper — replaces the booking in the list with an updated copy
  void _updateStatus(String id, BookingStatusType newStatus) {
    final updated = state.bookings.map((b) {
      return b.id == id ? b.copyWithStatus(newStatus) : b;
    }).toList();
    state = state.copyWith(bookings: updated);
  }

  // ── Filter ────────────────────────────────────────────────────────────────

  void setFilter(BookingStatusType? status) {
    if (status == null) {
      state = state.copyWith(clearFilter: true);
    } else {
      state = state.copyWith(filterStatus: status);
    }
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final adminBookingsProvider =
    StateNotifierProvider<AdminBookingsViewModel, AdminBookingsState>(
      (ref) => AdminBookingsViewModel(),
    );

// ─── Admin Rooms ViewModel ────────────────────────────────────────────────────
//
// Manages the Rooms CRUD list shown in the admin panel.

class AdminRoomsState {
  final List<RoomModel> rooms;
  final bool isLoading;

  const AdminRoomsState({this.rooms = const [], this.isLoading = false});

  AdminRoomsState copyWith({List<RoomModel>? rooms, bool? isLoading}) {
    return AdminRoomsState(
      rooms: rooms ?? this.rooms,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AdminRoomsViewModel extends StateNotifier<AdminRoomsState> {
  AdminRoomsViewModel() : super(const AdminRoomsState()) {
    loadRooms();
  }

  // TODO: Replace with: await supabase.from('rooms').select().order('name');

  Future<void> loadRooms() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 400));
    state = state.copyWith(
      isLoading: false,
      rooms: const [
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
      ],
    );
  }

  // TODO: await supabase.from('rooms').delete().eq('id', id);
  void deleteRoom(String id) {
    state = state.copyWith(
      rooms: state.rooms.where((r) => r.id != id).toList(),
    );
  }
}

final adminRoomsProvider =
    StateNotifierProvider<AdminRoomsViewModel, AdminRoomsState>(
      (ref) => AdminRoomsViewModel(),
    );
