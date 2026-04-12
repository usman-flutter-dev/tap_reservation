import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:tap_reservation/features/shared/root_router.dart';
import '../viewmodels/admin_auth_viewmodel.dart';
import '../viewmodels/admin_bookings_viewmodel.dart';
import '../widgets/dashboard_metric_card.dart';
import '../../../core/constants/app_colors.dart';
import 'admin_bookings_screen.dart';
import 'admin_rooms_screen.dart';
import 'admin_calendar_screen.dart';

/// ── Admin Screen 2: Dashboard ─────────────────────────────────────────────────
///
/// Overview screen showing key metrics and quick-navigation tiles.
/// The admin lands here after logging in.
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(adminAuthProvider);
    final bookingsState = ref.watch(adminBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          // Logout button
          TextButton.icon(
            onPressed: () {
              // ref.read(adminAuthProvider.notifier).logout();
              // // Return to login screen, removing all screens from stack
              // Get.offAll(() => const AdminLoginScreen());
              // Logout: clear auth + reset app mode → back to splash
              ref.read(adminAuthProvider.notifier).logout();
              ref.read(appModeProvider.notifier).state = null;
              Get.offAll(() => const RootRouter());
            },
            icon: const Icon(
              Icons.logout_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
            label: const Text(
              'Logout',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
      body: bookingsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Welcome heading ─────────────────────────
                  Text(
                    'Hello, Admin 👋',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authState.adminEmail ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Metric cards grid (2 columns) ───────────
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      DashboardMetricCard(
                        label: 'Total bookings',
                        value: '${bookingsState.totalBookings}',
                        icon: Icons.calendar_month_rounded,
                        iconBg: AppColors.primary.withValues(alpha: 0.1),
                        iconColor: AppColors.primary,
                      ),
                      DashboardMetricCard(
                        label: 'Pending approval',
                        value: '${bookingsState.pendingCount}',
                        icon: Icons.pending_actions_rounded,
                        iconBg: AppColors.warningLight,
                        iconColor: AppColors.warning,
                        valueColor: bookingsState.pendingCount > 0
                            ? AppColors.warning
                            : null,
                      ),
                      DashboardMetricCard(
                        label: 'Confirmed stays',
                        value: '${bookingsState.confirmedCount}',
                        icon: Icons.check_circle_outline_rounded,
                        iconBg: AppColors.successLight,
                        iconColor: AppColors.success,
                        valueColor: AppColors.success,
                      ),
                      DashboardMetricCard(
                        label: 'Total revenue',
                        value:
                            '\$${bookingsState.totalRevenue.toStringAsFixed(0)}',
                        icon: Icons.attach_money_rounded,
                        iconBg: const Color(0xFFF3E8FF), // Light purple
                        iconColor: const Color(0xFF7C3AED),
                        valueColor: const Color(0xFF7C3AED),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Quick actions ───────────────────────────
                  const Text(
                    'MANAGE',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Column(
                    children: [
                      _NavTile(
                        icon: Icons.event_note_rounded,
                        title: 'Bookings',
                        subtitle:
                            '${bookingsState.totalBookings} total · ${bookingsState.pendingCount} pending',
                        onTap: () => Get.to(() => const AdminBookingsScreen()),
                      ),
                      const SizedBox(height: 10),
                      _NavTile(
                        icon: Icons.bed_rounded,
                        title: 'Rooms',
                        subtitle: 'Add, edit, remove rooms',
                        onTap: () => Get.to(() => const AdminRoomsScreen()),
                      ),
                      const SizedBox(height: 10),
                      _NavTile(
                        icon: Icons.calendar_view_month_rounded,
                        title: 'Calendar',
                        subtitle: 'Visual booking overview',
                        onTap: () => Get.to(() => const AdminCalendarScreen()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

// ─── Private: Navigation Tile ────────────────────────────────────────────────

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
