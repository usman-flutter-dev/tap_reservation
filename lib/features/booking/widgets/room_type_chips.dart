// import 'package:flutter/material.dart';
// import '../models/room_model.dart';
// import '../../../core/constants/app_colors.dart';

// /// A row of decorative chips previewing the four room types.
// /// Shown at the bottom of the Home screen for visual discovery.
// class RoomTypeChips extends StatelessWidget {
//   const RoomTypeChips({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Section heading
//         const Text(
//           'OUR ROOM TYPES',
//           style: TextStyle(
//             fontSize: 10,
//             color: AppColors.textMuted,
//             fontWeight: FontWeight.w700,
//             letterSpacing: 1.0,
//           ),
//         ),
//         const SizedBox(height: 10),

//         // One chip per room type — fills available width evenly
//         Row(
//           children: RoomType.values.map((type) {
//             return Expanded(
//               child: Padding(
//                 // Right padding except for the last chip
//                 padding: EdgeInsets.only(
//                   right: type != RoomType.values.last ? 8 : 0,
//                 ),
//                 child: _RoomTypeChip(type: type),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }

// // ─── Private: Single Chip ────────────────────────────────────────────────────

// class _RoomTypeChip extends StatelessWidget {
//   final RoomType type;

//   const _RoomTypeChip({required this.type});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       decoration: BoxDecoration(
//         color: type.backgroundColor,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Colored square icon (replace with an Icon widget if desired)
//           Container(
//             width: 22,
//             height: 22,
//             decoration: BoxDecoration(
//               // withValues(alpha:) is the updated API — avoids deprecation warning
//               color: type.accentColor.withValues(alpha: 0.7),
//               borderRadius: BorderRadius.circular(6),
//             ),
//           ),
//           const SizedBox(height: 6),

//           // Label
//           Text(
//             type.label,
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w700,
//               color: type.accentColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../../../core/constants/app_colors.dart';

class RoomTypeChips extends StatelessWidget {
  const RoomTypeChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EXPERIENCE OUR ROOMS',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: RoomType.values.map((type) {
            final isLast = type == RoomType.values.last;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 12),
                child: _RoomTypeChip(type: type),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _RoomTypeChip extends StatelessWidget {
  final RoomType type;
  const _RoomTypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: type.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: type.accentColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.layers_outlined,
            size: 20,
            color: type.accentColor.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 8),
          Text(
            type.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: type.accentColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
