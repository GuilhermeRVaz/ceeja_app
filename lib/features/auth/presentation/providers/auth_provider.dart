// COPIE E COLE TUDO ABAIXO NO ARQUIVO:
// lib/features/auth/presentation/providers/auth_provider.dart

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// MUDANÇA: Adicionado o alias 'as supabase' para evitar conflito de nomes.
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:ceeja_app/env.dart';

// ESTADO DE AUTENTICAÇÃO
class AuthState {
  // MUDANÇA: Usando o tipo User com o alias.
  final supabase.User? user;
  final String? userRole;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.userRole,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    supabase.User? user,
    String? userRole,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      userRole: userRole ?? this.userRole,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

// NOTIFICADOR (LÓGICA DE NEGÓCIO)
class AuthNotifier extends StateNotifier<AuthState> {
  // MUDANÇA: Usando o tipo SupabaseClient com o alias.
  final supabase.SupabaseClient _supabase;
  // MUDANÇA: Usando o tipo AuthState do pacote Supabase com o alias.
  late final StreamSubscription<supabase.AuthState> _authStateSubscription;

  AuthNotifier(this._supabase) : super(const AuthState()) {
    _authStateSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      if (user != null) {
        _fetchUserProfile(user);
      } else {
        state = const AuthState();
      }
    });

    final initialUser = _supabase.auth.currentUser;
    if (initialUser != null) {
      _fetchUserProfile(initialUser);
    }
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  Future<void> _fetchUserProfile(supabase.User user) async {
    state = state.copyWith(isLoading: true, user: user, clearError: true);
    try {
      final response =
          await _supabase
              .from('profiles')
              .select('role')
              .eq('user_id', user.id)
              .maybeSingle();
      state = state.copyWith(
        userRole: response?['role'] as String?,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao buscar perfil do usuário.',
      );
    }
  }

  Future<void> signInWithPassword(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null)
        throw const supabase.AuthException(
          'Credenciais inválidas ou erro desconhecido.',
        );
    } on supabase.AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Ocorreu um erro inesperado.',
      );
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String fullName) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      if (response.user == null)
        throw const supabase.AuthException('Não foi possível criar o usuário.');
      await _supabase.from('profiles').insert({
        'user_id': response.user!.id,
        'email': email,
        'full_name': fullName,
        'role': 'aluno',
      });
      state = state.copyWith(isLoading: false);
    } on supabase.AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Ocorreu um erro inesperado durante o cadastro.',
      );
      rethrow;
    }
  }

  Future<supabase.User> createStudentUser({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final adminClient = supabase.SupabaseClient(
      AppEnv.supabaseUrl,
      AppEnv.supabaseServiceRoleKey,
    );
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await adminClient.auth.admin.createUser(
        supabase.AdminUserAttributes(
          email: email,
          password: password,
          emailConfirm: true,
          userMetadata: {'full_name': fullName, 'role': 'aluno'},
        ),
      );
      final newUser = response.user;
      if (newUser == null)
        throw const supabase.AuthException(
          'Falha ao criar usuário no sistema de Auth.',
        );
      await adminClient.from('profiles').insert({
        'user_id': newUser.id,
        'email': email,
        'full_name': fullName,
        'role': 'aluno',
      });
      state = state.copyWith(isLoading: false);
      return newUser;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await _supabase.auth.signOut();
  }
}

// PROVIDER GLOBAL
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // MUDANÇA: Usando o tipo SupabaseClient com o alias.
  return AuthNotifier(supabase.Supabase.instance.client);
});
