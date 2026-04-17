// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:tap_reservation/core/constants/app_colors.dart';
// import 'package:tap_reservation/features/booking/models/booking_state.dart';
// import 'package:tap_reservation/features/booking/models/room_model.dart';
// import 'package:tap_reservation/features/booking/viewmodels/booking_viewmodel.dart';
// import 'package:tap_reservation/features/booking/views/confirmation_screen.dart';
// import 'package:tap_reservation/features/booking/widgets/price_summary_card.dart';

// /// ── Screen 3: Booking Form ────────────────────────────────────────────────────
// ///
// /// Guest fills in their name, phone, and optional email.
// /// Shows the selected room + price breakdown before confirming.
// ///
// /// Uses ConsumerStatefulWidget because we need both:
// ///   - Riverpod (ref.watch, ref.read)
// ///   - Local state (TextEditingControllers, FormKey)
// class BookingFormScreen extends ConsumerStatefulWidget {
//   const BookingFormScreen({super.key});

//   @override
//   ConsumerState<BookingFormScreen> createState() => _BookingFormScreenState();
// }

// class _BookingFormScreenState extends ConsumerState<BookingFormScreen> {
//   // Form key — used by Form widget to trigger validation across all fields
//   final _formKey = GlobalKey<FormState>();

//   // Text controllers capture what the user types
//   // They must be disposed to prevent memory leaks
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(bookingProvider);
//     final vm = ref.read(bookingProvider.notifier);

//     // Safety: if no room was selected, this screen shouldn't be reachable,
//     // but guard anyway.
//     if (state.selectedRoom == null) {
//       return const Scaffold(body: Center(child: Text('No room selected.')));
//     }

//     final isLoading = state.status == BookingStatus.loading;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Booking Details'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
//           onPressed: Get.back,
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // ── Selected room summary tile ────────────────────
//               _SelectedRoomTile(state: state),
//               const SizedBox(height: 14),

//               // ── Guest details form ────────────────────────────
//               _GuestDetailsCard(
//                 nameController: _nameController,
//                 phoneController: _phoneController,
//                 emailController: _emailController,
//                 onNameChanged: vm.setGuestName,
//                 onPhoneChanged: vm.setGuestPhone,
//                 onEmailChanged: vm.setGuestEmail,
//               ),
//               const SizedBox(height: 12),

//               // ── Price breakdown ───────────────────────────────
//               PriceSummaryCard(
//                 pricePerNight: state.selectedRoom!.pricePerNight,
//                 nights: state.nights,
//                 total: state.totalCost,
//               ),
//               const SizedBox(height: 14),

//               // Show any server-side error (e.g. double-booking rejected)
//               if (state.status == BookingStatus.error) ...[
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: AppColors.error.withValues(alpha: 0.08),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: AppColors.error.withValues(alpha: 0.3),
//                       width: 0.5,
//                     ),
//                   ),
//                   child: Text(
//                     state.errorMessage ?? 'Something went wrong.',
//                     style: const TextStyle(
//                       fontSize: 13,
//                       color: AppColors.error,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//               ],

//               // ── Confirm button ────────────────────────────────
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     // Green for the confirm action (distinct from primary blue)
//                     backgroundColor: AppColors.success,
//                   ),
//                   // Disable the button while the request is in-flight
//                   onPressed: isLoading ? null : () => _onConfirmTapped(vm),
//                   child: isLoading
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2.2,
//                           ),
//                         )
//                       : const Text('Confirm Booking'),
//                 ),
//               ),

//               const SizedBox(height: 28),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// Validates required fields, then calls ViewModel to submit.
//   Future<void> _onConfirmTapped(BookingViewModel vm) async {
//     // validate() calls every field's validator and shows inline errors
//     if (_formKey.currentState?.validate() ?? false) {
//       await vm.confirmBooking();

//       // If confirmed successfully, navigate to Screen 4
//       // offAll() removes all screens so back button can't return to the form
//       if (mounted &&
//           ref.read(bookingProvider).status == BookingStatus.confirmed) {
//         Get.offAll(() => const ConfirmationScreen());
//       }
//     }
//   }
// }

// // ─── Private: Selected Room Tile ────────────────────────────────────────────

// /// Compact summary of the selected room shown above the form
// class _SelectedRoomTile extends StatelessWidget {
//   final BookingState state;

//   const _SelectedRoomTile({required this.state});

//   @override
//   Widget build(BuildContext context) {
//     final room = state.selectedRoom!;
//     final fmt = DateFormat('MMM d');
//     final dateLabel = state.hasValidDates
//         ? '${fmt.format(state.checkInDate!)} – ${fmt.format(state.checkOutDate!)} · ${state.nights} nights'
//         : '';

//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.border, width: 0.5),
//       ),
//       child: Row(
//         children: [
//           // Colored icon box
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: room.type.backgroundColor,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Center(
//               child: Container(
//                 width: 20,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   color: room.type.accentColor.withValues(alpha: 0.65),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),

//           // Room name + date range
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   room.name,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   dateLabel,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: AppColors.textSecondary,
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

// // ─── Private: Guest Details Card ────────────────────────────────────────────

// /// White card containing the three input fields
// class _GuestDetailsCard extends StatelessWidget {
//   final TextEditingController nameController;
//   final TextEditingController phoneController;
//   final TextEditingController emailController;
//   final ValueChanged<String> onNameChanged;
//   final ValueChanged<String> onPhoneChanged;
//   final ValueChanged<String> onEmailChanged;

//   const _GuestDetailsCard({
//     required this.nameController,
//     required this.phoneController,
//     required this.emailController,
//     required this.onNameChanged,
//     required this.onPhoneChanged,
//     required this.onEmailChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.border, width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'GUEST DETAILS',
//             style: TextStyle(
//               fontSize: 10,
//               color: AppColors.textMuted,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 1.0,
//             ),
//           ),
//           const SizedBox(height: 14),

//           // Full name (required)
//           _LabeledField(
//             controller: nameController,
//             label: 'Full name',
//             hint: 'Ahmed Khan',
//             isRequired: true,
//             onChanged: onNameChanged,
//             validator: (v) =>
//                 (v == null || v.trim().isEmpty) ? 'Name is required' : null,
//           ),
//           const SizedBox(height: 10),

//           // Phone (required)
//           _LabeledField(
//             controller: phoneController,
//             label: 'Phone number',
//             hint: '+1 (555) 000-0000',
//             isRequired: true,
//             keyboardType: TextInputType.phone,
//             onChanged: onPhoneChanged,
//             validator: (v) => (v == null || v.trim().isEmpty)
//                 ? 'Phone number is required'
//                 : null,
//           ),
//           const SizedBox(height: 10),

//           // Email (optional)
//           _LabeledField(
//             controller: emailController,
//             label: 'Email address',
//             hint: 'ahmed@example.com',
//             keyboardType: TextInputType.emailAddress,
//             onChanged: onEmailChanged,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Private: Labeled Text Field ─────────────────────────────────────────────

// /// A label + TextFormField combination used throughout the booking form
// class _LabeledField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String hint;
//   final bool isRequired;
//   final TextInputType? keyboardType;
//   final ValueChanged<String> onChanged;
//   final FormFieldValidator<String>? validator;

//   const _LabeledField({
//     required this.controller,
//     required this.label,
//     required this.hint,
//     this.isRequired = false,
//     this.keyboardType,
//     required this.onChanged,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Label — red asterisk marks required fields
//         RichText(
//           text: TextSpan(
//             text: label,
//             style: const TextStyle(
//               fontSize: 11,
//               color: AppColors.textSecondary,
//             ),
//             children: [
//               if (isRequired)
//                 const TextSpan(
//                   text: ' *',
//                   style: TextStyle(color: AppColors.error),
//                 ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 5),

//         // Input field
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           onChanged: onChanged,
//           validator: validator,
//           style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
//           decoration: InputDecoration(hintText: hint),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../models/booking_state.dart';
import '../viewmodels/booking_viewmodel.dart';
import 'confirmation_screen.dart';
import '../widgets/price_summary_card.dart';

class BookingFormScreen extends ConsumerStatefulWidget {
  const BookingFormScreen({super.key});

  @override
  ConsumerState<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends ConsumerState<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingProvider);
    final vm = ref.read(bookingProvider.notifier);

    if (state.selectedRoom == null) {
      return const Scaffold(body: Center(child: Text('No room selected.')));
    }

    final isLoading = state.status == BookingStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Guest Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: Get.back,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _SelectedRoomTile(state: state),
              const SizedBox(height: 20),
              _GuestDetailsCard(
                nameController: _nameController,
                phoneController: _phoneController,
                emailController: _emailController,
                onNameChanged: vm.setGuestName,
                onPhoneChanged: vm.setGuestPhone,
                onEmailChanged: vm.setGuestEmail,
              ),
              const SizedBox(height: 20),
              PriceSummaryCard(
                pricePerNight: state.selectedRoom!.pricePerNight,
                nights: state.nights,
                total: state.totalCost,
              ),
              const SizedBox(height: 24),
              if (state.status == BookingStatus.error) ...[
                _ErrorDisplay(message: state.errorMessage),
                const SizedBox(height: 16),
              ],
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Premium Eucalyptus
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading ? null : () => _onConfirmTapped(vm),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Confirm & Reserve',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onConfirmTapped(BookingViewModel vm) async {
    if (_formKey.currentState?.validate() ?? false) {
      await vm.confirmBooking();
      if (mounted &&
          ref.read(bookingProvider).status == BookingStatus.confirmed) {
        Get.offAll(() => const ConfirmationScreen());
      }
    }
  }
}

class _SelectedRoomTile extends StatelessWidget {
  final BookingState state;
  const _SelectedRoomTile({required this.state});

  @override
  Widget build(BuildContext context) {
    final room = state.selectedRoom!;
    final fmt = DateFormat('MMM d');
    final dateRange =
        '${fmt.format(state.checkInDate!)} – ${fmt.format(state.checkOutDate!)}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.bed_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$dateRange · ${state.nights} nights',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
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

class _GuestDetailsCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onEmailChanged;

  const _GuestDetailsCard({
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.onNameChanged,
    required this.onPhoneChanged,
    required this.onEmailChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CONTACT DETAILS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          _LabeledField(
            controller: nameController,
            label: 'Full Name',
            hint: 'e.g. John Doe',
            isRequired: true,
            onChanged: onNameChanged,
            validator: (v) =>
                (v?.isEmpty ?? true) ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 16),
          _LabeledField(
            controller: phoneController,
            label: 'Phone Number',
            hint: '+61 400 000 000',
            isRequired: true,
            keyboardType: TextInputType.phone,
            onChanged: onPhoneChanged,
            validator: (v) =>
                (v?.isEmpty ?? true) ? 'Phone number required' : null,
          ),
          const SizedBox(height: 16),
          _LabeledField(
            controller: emailController,
            label: 'Email Address (Optional)',
            hint: 'john@example.com',
            keyboardType: TextInputType.emailAddress,
            onChanged: onEmailChanged,
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isRequired;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;

  const _LabeledField({
    required this.controller,
    required this.label,
    required this.hint,
    this.isRequired = false,
    this.keyboardType,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorDisplay extends StatelessWidget {
  final String? message;
  const _ErrorDisplay({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, size: 18, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message ?? 'An error occurred',
              style: const TextStyle(fontSize: 13, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
