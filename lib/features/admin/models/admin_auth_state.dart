// ─── Admin Auth State ─────────────────────────────────────────────────────────
//
// Tracks whether the admin is logged in or not.
// In production, Supabase Auth fills these fields after signInWithPassword().

enum AuthStatus {
  idle,       // Initial state — login form is shown
  loading,    // Sign-in request in-flight
  authenticated, // Login succeeded
  error,      // Wrong credentials or network failure
}

class AdminAuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String? adminEmail; // Set after successful login

  const AdminAuthState({
    this.status = AuthStatus.idle,
    this.errorMessage,
    this.adminEmail,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AdminAuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? adminEmail,
  }) {
    return AdminAuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      adminEmail: adminEmail ?? this.adminEmail,
    );
  }
}
