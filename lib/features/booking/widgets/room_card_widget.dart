import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../../../core/constants/app_colors.dart';

/// Card showing one room's details on the Available Rooms screen.
///
/// Contains: colored banner, room name + type badge, price, capacity, total,
/// and a "Select this room" button.
class RoomCardWidget extends StatelessWidget {
  final RoomModel room;
  final int nights;       // Passed from state so total price can be computed
  final VoidCallback onSelect;

  const RoomCardWidget({
    super.key,
    required this.room,
    required this.nights,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      // clipBehavior ensures the banner respects the card's rounded corners
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Colored banner at the top ────────────────────────
          _RoomBanner(room: room),

          // ── Content padding ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + price in one row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: room name and type badge
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 5),
                          _TypeBadge(type: room.type),
                        ],
                      ),
                    ),

                    // Right: nightly price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${room.pricePerNight.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: room.type.accentColor,
                          ),
                        ),
                        const Text(
                          'per night',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Capacity + total cost for selected nights
                Text(
                  'Up to ${room.capacity} guests  ·  Total: \$${room.totalPrice(nights).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                // Select button — full width
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSelect,
                    child: const Text('Select this room'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Private: Colored Banner ─────────────────────────────────────────────────

/// Top section of the card with the room type's background color
class _RoomBanner extends StatelessWidget {
  final RoomModel room;

  const _RoomBanner({required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: room.type.backgroundColor,
      alignment: Alignment.center,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          // Semi-transparent accent icon — replace with an Image.network for photos
          color: room.type.accentColor.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// ─── Private: Type Badge ─────────────────────────────────────────────────────

/// Pill badge showing the room type (e.g. "Suite", "Deluxe")
class _TypeBadge extends StatelessWidget {
  final RoomType type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: type.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: type.accentColor,
        ),
      ),
    );
  }
}
