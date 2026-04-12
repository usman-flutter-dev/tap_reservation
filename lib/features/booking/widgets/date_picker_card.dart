import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

/// Displays two tappable date fields: Check-in and Check-out.
///
/// This widget is "dumb" — it holds no state of its own.
/// The parent (HomeScreen) owns the dates via Riverpod and passes
/// them down as parameters. Changes bubble up via callbacks.
class DatePickerCard extends StatelessWidget {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final ValueChanged<DateTime> onCheckInSelected;
  final ValueChanged<DateTime> onCheckOutSelected;

  const DatePickerCard({
    super.key,
    this.checkIn,
    this.checkOut,
    required this.onCheckInSelected,
    required this.onCheckOutSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section label ────────────────────────────────────
          const Text(
            'SELECT DATES',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),

          // ── Two date fields side by side ─────────────────────
          Row(
            children: [
              Expanded(
                child: _DateField(
                  label: 'Check-in',
                  date: checkIn,
                  onTap: () => _openPicker(
                    context,
                    initial: checkIn,
                    // Check-in can't be in the past
                    firstDate: DateTime.now(),
                    onPicked: onCheckInSelected,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DateField(
                  label: 'Check-out',
                  date: checkOut,
                  onTap: () => _openPicker(
                    context,
                    initial: checkOut,
                    // Check-out must be at least 1 day after check-in
                    firstDate: checkIn != null
                        ? checkIn!.add(const Duration(days: 1))
                        : DateTime.now().add(const Duration(days: 1)),
                    onPicked: onCheckOutSelected,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Opens Material's built-in date picker dialog.
  /// The primary color is applied via Theme override.
  Future<void> _openPicker(
    BuildContext context, {
    DateTime? initial,
    required DateTime firstDate,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? firstDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    // Only fire callback if user selected a date (didn't cancel)
    if (picked != null) onPicked(picked);
  }
}

// ─── Private: Single Date Tile ────────────────────────────────────────────────

/// A tappable tile that shows either a formatted date or a placeholder.
class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format the date, or show placeholder when not yet selected
    final displayText = date != null
        ? DateFormat('MMM d, yyyy').format(date!)
        : 'Select';

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label above the box
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),

          // Tappable date display box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.borderLight, width: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              displayText,
              style: TextStyle(
                fontSize: 12,
                color: date != null ? AppColors.textPrimary : AppColors.textMuted,
                fontWeight: date != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
