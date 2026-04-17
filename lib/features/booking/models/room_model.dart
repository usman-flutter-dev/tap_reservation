import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

// ─── Room Type Enum ────────────────────────────────────────────────────────────

/// The four room categories available in the guest house
enum RoomType { standard, deluxe, suite, executive }

/// Extension adds display properties to each RoomType.
/// Keeps UI logic out of the model itself.
extension RoomTypeExtension on RoomType {
  /// Human-readable label shown in badges and chips
  String get label {
    switch (this) {
      case RoomType.standard:
        return 'Standard';
      case RoomType.deluxe:
        return 'Deluxe';
      case RoomType.suite:
        return 'Suite';
      case RoomType.executive:
        return 'Executive';
    }
  }

  /// Strong accent color used for price, badge text, icons
  // Color get accentColor {
  //   switch (this) {
  //     case RoomType.standard:  return AppColors.standardAccent;
  //     case RoomType.deluxe:    return AppColors.deluxeAccent;
  //     case RoomType.suite:     return AppColors.suiteAccent;
  //     case RoomType.executive: return AppColors.executiveAccent;
  //   }
  // }
  Color get accentColor {
    switch (this) {
      case RoomType.standard:
        return AppColors.secondary; // Terracotta
      case RoomType.deluxe:
        return AppColors.primary; // Eucalyptus
      case RoomType.suite:
        return AppColors.accent; // Deep Earth
      case RoomType.executive:
        return const Color(0xFF1B2E26); // Forest Shadow
    }
  }

  /// Soft background used for banner, badge background
  // Color get backgroundColor {
  //   switch (this) {
  //     case RoomType.standard:  return AppColors.standardBg;
  //     case RoomType.deluxe:    return AppColors.deluxeBg;
  //     case RoomType.suite:     return AppColors.suiteBg;
  //     case RoomType.executive: return AppColors.executiveBg;
  //   }
  // }
  /// Soft background used for banner, badge background
  Color get backgroundColor {
    switch (this) {
      case RoomType.standard:
        return const Color(0xFFF9EFE9); // Pale Terracotta
      case RoomType.deluxe:
        return const Color(0xFFE9EFED); // Pale Eucalyptus
      case RoomType.suite:
        return AppColors.borderLight; // Neutral Sand
      case RoomType.executive:
        return const Color(0xFFE2E6E4); // Misty Green
    }
  }
}

// ─── Room Model ───────────────────────────────────────────────────────────────

/// Represents a single guest house room.
/// In production this will be populated from Supabase's 'rooms' table.

// class RoomModel {
//   final String id;
//   final String name;
//   final RoomType type;
//   final double pricePerNight; // USD
//   final int capacity; // max guests allowed

//   const RoomModel({
//     required this.id,
//     required this.name,
//     required this.type,
//     required this.pricePerNight,
//     required this.capacity,
//   });

//   /// Calculates total cost for a number of nights
//   double totalPrice(int nights) => pricePerNight * nights;

//   /// Creates a RoomModel from a Supabase row map.
//   /// Use this when you connect real data: RoomModel.fromMap(row)
//   factory RoomModel.fromMap(Map<String, dynamic> map) {
//     return RoomModel(
//       id: map['id'] as String,
//       name: map['name'] as String,
//       type: RoomType.values.firstWhere(
//         (t) => t.label.toLowerCase() == (map['type'] as String).toLowerCase(),
//         orElse: () => RoomType.standard,
//       ),
//       pricePerNight: (map['price_per_night'] as num).toDouble(),
//       capacity: map['capacity'] as int,
//     );
//   }
// }

class RoomModel {
  final String id;
  final String name;
  final String location;
  final RoomType type;
  final double pricePerNight; // AUD
  final int capacity;
  final double rating;
  final int reviewCount;
  final List<String>
  amenities; // e.g., ['WiFi', 'Parking', 'Breakfast', 'Pet OK']
  final String description;

  const RoomModel({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    required this.pricePerNight,
    required this.capacity,
    required this.rating,
    required this.reviewCount,
    required this.amenities,
    required this.description,
  });

  double totalPrice(int nights) => pricePerNight * nights;

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'] as String,
      name: map['name'] as String,
      location: map['location'] ?? 'Byron Bay, NSW',
      type: RoomType.values.firstWhere(
        (t) => t.label.toLowerCase() == (map['type'] as String).toLowerCase(),
        orElse: () => RoomType.standard,
      ),
      pricePerNight: (map['price_per_night'] as num).toDouble(),
      capacity: map['capacity'] as int,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['review_count'] as int? ?? 0,
      amenities: List<String>.from(map['amenities'] ?? []),
      description: map['description'] ?? '',
    );
  }
}
