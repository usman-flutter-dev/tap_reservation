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
      case RoomType.standard:  return 'Standard';
      case RoomType.deluxe:    return 'Deluxe';
      case RoomType.suite:     return 'Suite';
      case RoomType.executive: return 'Executive';
    }
  }

  /// Strong accent color used for price, badge text, icons
  Color get accentColor {
    switch (this) {
      case RoomType.standard:  return AppColors.standardAccent;
      case RoomType.deluxe:    return AppColors.deluxeAccent;
      case RoomType.suite:     return AppColors.suiteAccent;
      case RoomType.executive: return AppColors.executiveAccent;
    }
  }

  /// Soft background used for banner, badge background
  Color get backgroundColor {
    switch (this) {
      case RoomType.standard:  return AppColors.standardBg;
      case RoomType.deluxe:    return AppColors.deluxeBg;
      case RoomType.suite:     return AppColors.suiteBg;
      case RoomType.executive: return AppColors.executiveBg;
    }
  }
}

// ─── Room Model ───────────────────────────────────────────────────────────────

/// Represents a single guest house room.
/// In production this will be populated from Supabase's 'rooms' table.
class RoomModel {
  final String id;
  final String name;
  final RoomType type;
  final double pricePerNight; // USD
  final int capacity;         // max guests allowed

  const RoomModel({
    required this.id,
    required this.name,
    required this.type,
    required this.pricePerNight,
    required this.capacity,
  });

  /// Calculates total cost for a number of nights
  double totalPrice(int nights) => pricePerNight * nights;

  /// Creates a RoomModel from a Supabase row map.
  /// Use this when you connect real data: RoomModel.fromMap(row)
  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'] as String,
      name: map['name'] as String,
      type: RoomType.values.firstWhere(
        (t) => t.label.toLowerCase() == (map['type'] as String).toLowerCase(),
        orElse: () => RoomType.standard,
      ),
      pricePerNight: (map['price_per_night'] as num).toDouble(),
      capacity: map['capacity'] as int,
    );
  }
}
