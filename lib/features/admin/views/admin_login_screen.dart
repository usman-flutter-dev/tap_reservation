import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../models/admin_auth_state.dart';
import '../viewmodels/admin_auth_viewmodel.dart';
import '../../../core/constants/app_colors.dart';
import 'admin_dashboard_screen.dart';

/// ── Admin Screen 1: Login ─────────────────────────────────────────────────────
///
/// Full-screen login form for the admin.
/// On success navigates to the Dashboard.
///
/// Demo credentials:
///   Email:    admin@serenity.com
///   Password: admin123
class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _formKey     = GlobalKey<FormState>();
  final _emailCtrl   = TextEditingController();
  final _passwordCtrl= TextEditingController();
  bool _obscurePassword = true; // Toggle password visibility

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(adminAuthProvider);
    final isLoading = authState.status == AuthStatus.loading;

    // When auth succeeds, navigate to dashboard
    // Using ref.listen avoids calling Get.to inside build()
    ref.listen<AdminAuthState>(adminAuthProvider, (_, next) {
      if (next.status == AuthStatus.authenticated) {
        Get.off(() => const AdminDashboardScreen());
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // ── Branding header ───────────────────────────
              const _LoginHeader(),
              const SizedBox(height: 36),

              // ── Login form card ───────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ADMIN LOGIN',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Email field
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          hintText: 'admin@serenity.com',
                          prefixIcon: Icon(Icons.email_outlined, size: 18, color: AppColors.textMuted),
                        ),
                        validator: (v) => (v == null || !v.contains('@'))
                            ? 'Enter a valid email' : null,
                      ),
                      const SizedBox(height: 12),

                      // Password field with show/hide toggle
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.textMuted),
                          // Tap the eye icon to reveal/hide password
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                            child: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        validator: (v) => (v == null || v.length < 6)
                            ? 'Password must be at least 6 characters' : null,
                      ),

                      // Server-side error message
                      if (authState.status == AuthStatus.error) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded, size: 15, color: AppColors.error),
                              const SizedBox(width: 7),
                              Expanded(
                                child: Text(
                                  authState.errorMessage ?? 'Login failed.',
                                  style: const TextStyle(fontSize: 12, color: AppColors.error),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _onLoginTapped,
                          child: isLoading
                              ? const SizedBox(
                                  width: 20, height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.2,
                                  ),
                                )
                              : const Text('Sign In'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Demo hint — remove in production
              const SizedBox(height: 20),
              const _DemoHint(),
            ],
          ),
        ),
      ),
    );
  }

  void _onLoginTapped() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(adminAuthProvider.notifier).login(
        _emailCtrl.text.trim(),
        _passwordCtrl.text,
      );
    }
  }
}

// ─── Private: Header ─────────────────────────────────────────────────────────

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo placeholder — replace with Image.asset('assets/logo.png')
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.hotel_rounded, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome back',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Sign in to manage your guest house',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ─── Private: Demo Hint ───────────────────────────────────────────────────────

class _DemoHint extends StatelessWidget {
  const _DemoHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Demo credentials',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 4),
          Text('Email:    admin@serenity.com', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          Text('Password: admin123',           style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
