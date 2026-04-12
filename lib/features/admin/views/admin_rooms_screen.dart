import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../booking/models/room_model.dart';
import '../viewmodels/admin_bookings_viewmodel.dart';
import '../../../core/constants/app_colors.dart';

/// ── Admin Screen 4: Rooms ─────────────────────────────────────────────────────
///
/// Lists all rooms. Admin can delete rooms.
/// "Add Room" FAB opens a bottom sheet form.
///
/// In production, edits and new rooms are persisted to Supabase's rooms table.
class AdminRoomsScreen extends ConsumerWidget {
  const AdminRoomsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminRoomsProvider);
    final vm = ref.read(adminRoomsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: Get.back,
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: state.rooms.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final room = state.rooms[i];
                return _RoomAdminTile(
                  room: room,
                  onDelete: () => _confirmDelete(ctx, vm, room),
                  onEdit: () => _showRoomForm(ctx, room: room),
                );
              },
            ),

      // FAB to add a new room
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRoomForm(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Room', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    AdminRoomsViewModel vm,
    RoomModel room,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Delete ${room.name}?',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'This cannot be undone. Active bookings for this room will be affected.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              vm.deleteRoom(room.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  /// Opens a bottom sheet with the room add/edit form.
  void _showRoomForm(BuildContext context, {RoomModel? room}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      // Adjust for keyboard so form fields aren't hidden
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _RoomFormSheet(existing: room),
      ),
    );
  }
}

// ─── Private: Room Tile ───────────────────────────────────────────────────────

class _RoomAdminTile extends StatelessWidget {
  final RoomModel room;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RoomAdminTile({
    required this.room,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          // Colored icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: room.type.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: room.type.accentColor.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Room info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '\$${room.pricePerNight.toStringAsFixed(0)}/night  ·  Up to ${room.capacity} guests',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Edit
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              size: 18,
              color: AppColors.textSecondary,
            ),
            onPressed: onEdit,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 4),

          // Delete
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              size: 18,
              color: AppColors.error,
            ),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

// ─── Private: Room Add/Edit Form ─────────────────────────────────────────────

class _RoomFormSheet extends StatefulWidget {
  final RoomModel? existing; // null = adding new room

  const _RoomFormSheet({this.existing});

  @override
  State<_RoomFormSheet> createState() => _RoomFormSheetState();
}

class _RoomFormSheetState extends State<_RoomFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();
  RoomType _selectedType = RoomType.standard;

  @override
  void initState() {
    super.initState();
    // Pre-fill fields when editing an existing room
    if (widget.existing != null) {
      _nameCtrl.text = widget.existing!.name;
      _priceCtrl.text = widget.existing!.pricePerNight.toStringAsFixed(0);
      _capacityCtrl.text = '${widget.existing!.capacity}';
      _selectedType = widget.existing!.type;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _capacityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              isEdit ? 'Edit Room' : 'Add New Room',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 18),

            // Room name
            _FormField(
              ctrl: _nameCtrl,
              label: 'Room name',
              hint: 'e.g. Ocean Suite',
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 10),

            // Price per night
            _FormField(
              ctrl: _priceCtrl,
              label: 'Price per night (USD)',
              hint: '50',
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Price is required';
                if (double.tryParse(v) == null) return 'Enter a valid number';
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Capacity
            _FormField(
              ctrl: _capacityCtrl,
              label: 'Max guests',
              hint: '2',
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Capacity is required';
                if (int.tryParse(v) == null) return 'Enter a whole number';
                return null;
              },
            ),
            const SizedBox(height: 14),

            // Room type selector
            const Text(
              'Room type',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: RoomType.values.map((type) {
                final isSelected = type == _selectedType;
                return GestureDetector(
                  onTap: () => setState(() => _selectedType = type),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? type.backgroundColor
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? type.accentColor : AppColors.border,
                        width: isSelected ? 1.2 : 0.5,
                      ),
                    ),
                    child: Text(
                      type.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? type.accentColor
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSave,
                // TODO: call adminRoomsProvider.notifier.addRoom() / updateRoom()
                child: Text(isEdit ? 'Save Changes' : 'Add Room'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Pass data to ViewModel
      // final vm = ref.read(adminRoomsProvider.notifier);
      // vm.addRoom(name: _nameCtrl.text, price: double.parse(_priceCtrl.text), ...);
      Get.back();
      Get.snackbar(
        'Saved',
        'Room saved successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.successLight,
        colorText: AppColors.success,
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        duration: const Duration(seconds: 2),
      );
    }
  }
}

// ─── Private: Reusable form field ────────────────────────────────────────────

class _FormField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  const _FormField({
    required this.ctrl,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
