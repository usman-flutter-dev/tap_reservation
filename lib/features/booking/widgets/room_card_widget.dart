// import 'package:flutter/material.dart';
// import '../models/room_model.dart';
// import '../../../core/constants/app_colors.dart';

// /// Card showing one room's details on the Available Rooms screen.
// ///
// /// Contains: colored banner, room name + type badge, price, capacity, total,
// /// and a "Select this room" button.
// class RoomCardWidget extends StatelessWidget {
//   final RoomModel room;
//   final int nights;       // Passed from state so total price can be computed
//   final VoidCallback onSelect;

//   const RoomCardWidget({
//     super.key,
//     required this.room,
//     required this.nights,
//     required this.onSelect,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: AppColors.border, width: 0.5),
//       ),
//       // clipBehavior ensures the banner respects the card's rounded corners
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Colored banner at the top ────────────────────────
//           _RoomBanner(room: room),

//           // ── Content padding ──────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Name + price in one row
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Left: room name and type badge
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             room.name,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           _TypeBadge(type: room.type),
//                         ],
//                       ),
//                     ),

//                     // Right: nightly price
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           '\$${room.pricePerNight.toStringAsFixed(0)}',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             color: room.type.accentColor,
//                           ),
//                         ),
//                         const Text(
//                           'per night',
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: AppColors.textMuted,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),

//                 // Capacity + total cost for selected nights
//                 Text(
//                   'Up to ${room.capacity} guests  ·  Total: \$${room.totalPrice(nights).toStringAsFixed(0)}',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // Select button — full width
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: onSelect,
//                     child: const Text('Select this room'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Private: Colored Banner ─────────────────────────────────────────────────

// /// Top section of the card with the room type's background color
// class _RoomBanner extends StatelessWidget {
//   final RoomModel room;

//   const _RoomBanner({required this.room});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 80,
//       color: room.type.backgroundColor,
//       alignment: Alignment.center,
//       child: Container(
//         width: 38,
//         height: 38,
//         decoration: BoxDecoration(
//           // Semi-transparent accent icon — replace with an Image.network for photos
//           color: room.type.accentColor.withValues(alpha: 0.6),
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
// }

// // ─── Private: Type Badge ─────────────────────────────────────────────────────

// /// Pill badge showing the room type (e.g. "Suite", "Deluxe")
// class _TypeBadge extends StatelessWidget {
//   final RoomType type;

//   const _TypeBadge({required this.type});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: type.backgroundColor,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         type.label,
//         style: TextStyle(
//           fontSize: 10,
//           fontWeight: FontWeight.w700,
//           color: type.accentColor,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../../../core/constants/app_colors.dart';

class RoomCardWidget extends StatelessWidget {
  final RoomModel room;
  final int nights;
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoomBanner(room: room),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _TypeBadge(type: room.type),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${room.pricePerNight.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const Text(
                          'per night',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline_rounded,
                      size: 16,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Up to ${room.capacity} guests',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Total: \$${room.totalPrice(nights).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onSelect,
                    child: const Text(
                      'Select this Room',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
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

class _RoomBanner extends StatelessWidget {
  final RoomModel room;
  const _RoomBanner({required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: room.type.backgroundColor,
        image: const DecorationImage(
          // Subtle texture or pattern placeholder
          image: NetworkImage(
            'https://www.transparenttextures.com/patterns/cubes.png',
          ),
          opacity: 0.05,
          repeat: ImageRepeat.repeat,
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.king_bed_outlined,
          color: room.type.accentColor,
          size: 32,
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final RoomType type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: type.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: type.accentColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        type.label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: type.accentColor,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
