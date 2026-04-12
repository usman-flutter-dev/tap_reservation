import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// A +/− counter that lets the user set the number of guests.
///
/// This is a pure presentational (dumb) widget.
/// The parent provides [count] and the two callbacks.
class GuestCounterWidget extends StatelessWidget {
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const GuestCounterWidget({
    super.key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          // Left label
          const Text(
            'Guests',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),

          // ── Counter controls ─────────────────────────────────
          _CircleButton(
            icon: Icons.remove,
            onTap: onDecrement,
            // Disable visually when already at minimum
            enabled: count > 1,
          ),
          const SizedBox(width: 14),

          // Current count — fixed width prevents layout shift
          SizedBox(
            width: 28,
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 14),

          _CircleButton(
            icon: Icons.add,
            onTap: onIncrement,
            // Disable visually when already at maximum
            enabled: count < 8,
          ),
        ],
      ),
    );
  }
}

// ─── Private: Circular Button ─────────────────────────────────────────────────

/// Small circular button used for increment/decrement
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.borderLight,
            width: 0.5,
          ),
          // Dimmed when disabled
          color: enabled ? AppColors.background : AppColors.border,
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? AppColors.textPrimary : AppColors.textMuted,
        ),
      ),
    );
  }
}
