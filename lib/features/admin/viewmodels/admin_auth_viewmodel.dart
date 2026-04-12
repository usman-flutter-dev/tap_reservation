import 'package:flutter_riverpod/legacy.dart';
import '../models/admin_auth_state.dart';

// ─── Admin Auth ViewModel ─────────────────────────────────────────────────────
//
// Handles admin login / logout.
// No UI logic — screens call methods and react to state changes.

class AdminAuthViewModel extends StateNotifier<AdminAuthState> {
  AdminAuthViewModel() : super(const AdminAuthState());

  // ── Login ─────────────────────────────────────────────────────────────────
  //
  // TODO: Replace mock with Supabase auth:
  //   final res = await supabase.auth.signInWithPassword(
  //     email: email, password: password,
  //   );
  //   if (res.user != null) { /* set authenticated */ }

  Future<void> login(String email, String password) async {
    // Show loading spinner
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // Mock: simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock credential check — replace with Supabase in production
      if (email == 'admin@serenity.com' && password == 'admin123') {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          adminEmail: email,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid email or password.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Network error. Please try again.',
      );
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  //
  // TODO: Add: await supabase.auth.signOut();

  void logout() {
    state = const AdminAuthState(); // Reset to idle / unauthenticated
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final adminAuthProvider =
    StateNotifierProvider<AdminAuthViewModel, AdminAuthState>(
      (ref) => AdminAuthViewModel(),
    );
