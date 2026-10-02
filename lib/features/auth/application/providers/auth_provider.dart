import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trazza/core/providers/supabase_client_provider.dart';

abstract class AuthController {
  Future<void> signIn({required String email, required String password});

  Future<void> signOut();

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });
}

final authProvider = Provider<AuthController>(
  (ref) => SupabaseAuthController(ref.watch(supabaseClientProvider)),
);

final currentUserProvider = Provider<User?>(
  (ref) {
    ref.watch(authStateProvider);
    return ref.watch(supabaseClientProvider).auth.currentUser;
  },
);

final authStateProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(supabaseClientProvider).auth.onAuthStateChange,
);

class SupabaseAuthController implements AuthController {
  final SupabaseClient client;

  const SupabaseAuthController(this.client);

  @override
  Future<void> signIn({required String email, required String password}) async {
    await client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );
  }
}
