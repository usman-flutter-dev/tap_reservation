import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/admin_booking.dart';
import '../../../core/constants/app_colors.dart';

/// Month-view calendar grid.
/// Highlights dates that have confirmed (green) or pending (amber) bookings.
/// User taps a date to see which bookings fall on that day.
///
/// This widget is self-contained — it manages its own displayed month
/// using local StatefulWidget state (no Riverpod needed here since it's
/// purely presentational and driven by the passed [bookings] list).
class CalendarWidget extends StatefulWidget {
  final List<AdminBooking> bookings;
  // Called when the user taps a date that has at least one booking
  final ValueChanged<List<AdminBooking>> onDateSelected;

  const CalendarWidget({
    super.key,
    required this.bookings,
    required this.onDateSelected,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  // The month currently displayed in the calendar
  late DateTime _displayedMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Start on the current month
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month);
  }

  // Navigate to previous month
  void _prevMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  // Navigate to next month
  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  // Returns all bookings that overlap with a given date
  List<AdminBooking> _bookingsForDate(DateTime date) {
    return widget.bookings.where((b) {
      // A booking spans from checkIn (inclusive) to checkOut (exclusive)
      return !date.isBefore(b.checkInDate) && date.isBefore(b.checkOutDate);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(_displayedMonth.year, _displayedMonth.month);

    // weekdayOffset: how many empty cells to show before the 1st
    // DateTime.weekday: Mon=1 ... Sun=7. We start grid on Sunday so adjust.
    int weekdayOffset = firstDayOfMonth.weekday % 7; // Sun=0, Mon=1 ... Sat=6

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          // ── Month header with prev / next arrows ──────────
          _MonthHeader(
            month: DateFormat('MMMM yyyy').format(_displayedMonth),
            onPrev: _prevMonth,
            onNext: _nextMonth,
          ),

          const Divider(height: 0.5, thickness: 0.5, color: AppColors.border),

          // ── Day-of-week labels (Sun Mon … Sat) ────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map((d) => Expanded(
                        child: Center(
                          child: Text(
                            d,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMuted,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),

          // ── Date grid ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
            child: GridView.builder(
              // Let the grid size itself to its content
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemCount: weekdayOffset + daysInMonth,
              itemBuilder: (_, index) {
                // Empty cells before the 1st of the month
                if (index < weekdayOffset) return const SizedBox.shrink();

                final day = index - weekdayOffset + 1;
                final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);
                final dayBookings = _bookingsForDate(date);
                final isSelected = _selectedDate != null &&
                    DateUtils.isSameDay(_selectedDate!, date);
                final isToday = DateUtils.isSameDay(DateTime.now(), date);

                return _DayCell(
                  day: day,
                  bookings: dayBookings,
                  isSelected: isSelected,
                  isToday: isToday,
                  onTap: () {
                    setState(() => _selectedDate = date);
                    if (dayBookings.isNotEmpty) {
                      widget.onDateSelected(dayBookings);
                    }
                  },
                );
              },
            ),
          ),

          // ── Legend ────────────────────────────────────────
          const _CalendarLegend(),
        ],
      ),
    );
  }
}

// ─── Private: Month Header ────────────────────────────────────────────────────

class _MonthHeader extends StatelessWidget {
  final String month;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _MonthHeader({
    required this.month,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPrev,
            child: const Icon(
              Icons.chevron_left_rounded,
              size: 22,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              month,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onNext,
            child: const Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Private: Day Cell ────────────────────────────────────────────────────────

class _DayCell extends StatelessWidget {
  final int day;
  final List<AdminBooking> bookings;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.bookings,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  // Determine the dot color based on bookings on this date:
  //  - Confirmed → green
  //  - Pending   → amber
  //  - Mixed     → green (confirmed takes priority)
  Color? get _dotColor {
    if (bookings.isEmpty) return null;
    final hasConfirmed = bookings.any((b) => b.status == BookingStatusType.confirmed);
    return hasConfirmed ? AppColors.success : AppColors.warning;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // Selected date: filled blue circle
          color: isSelected
              ? AppColors.primary
              : isToday
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isToday || isSelected ? FontWeight.w700 : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : isToday
                        ? AppColors.primary
                        : AppColors.textPrimary,
              ),
            ),

            // Colored dot if bookings exist on this date
            if (_dotColor != null) ...[
              const SizedBox(height: 2),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : _dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Private: Legend ─────────────────────────────────────────────────────────

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Row(
        children: [
          _LegendDot(color: AppColors.success, label: 'Confirmed'),
          const SizedBox(width: 16),
          _LegendDot(color: AppColors.warning, label: 'Pending'),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
