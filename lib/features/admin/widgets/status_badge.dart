// import 'package:flutter/material.dart';
// import '../models/admin_booking.dart';
// import '../../../core/constants/app_colors.dart';

// /// Colored pill badge showing a booking's status.
// /// Used in booking list rows and detail cards.
// class StatusBadge extends StatelessWidget {
//   final BookingStatusType status;

//   const StatusBadge({super.key, required this.status});

//   @override
//   Widget build(BuildContext context) {
//     // Map each status to background + text color pair
//     final Color bg;
//     final Color textColor;

//     switch (status) {
//       case BookingStatusType.confirmed:
//         bg        = AppColors.successLight;
//         textColor = AppColors.success;
//         break;
//       case BookingStatusType.pending:
//         bg        = AppColors.warningLight;
//         textColor = AppColors.warning;
//         break;
//       case BookingStatusType.cancelled:
//         bg        = const Color(0xFFF3F4F6); // Gray-100
//         textColor = AppColors.textSecondary;
//         break;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         status.label,
//         style: TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w700,
//           color: textColor,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/admin_booking.dart';
import '../../../core/constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final BookingStatusType status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color textColor;

    switch (status) {
      case BookingStatusType.confirmed:
        // Eucalyptus green tones
        bg = const Color(0xFFE9EFED);
        textColor = AppColors.primary;
        break;
      case BookingStatusType.pending:
        // Terracotta amber tones
        bg = const Color(0xFFF9EFE9);
        textColor = AppColors.secondary;
        break;
      case BookingStatusType.cancelled:
        // Neutral stone tones
        bg = AppColors.borderLight;
        textColor = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100), // Full pill shape
      ),
      child: Text(
        status.label.toUpperCase(), // Caps for a more premium, structured look
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
