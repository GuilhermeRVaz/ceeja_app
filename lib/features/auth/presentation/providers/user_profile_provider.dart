import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Define o estado do perfil do usuário
class UserProfileState {
  final String? userRole;
  final User? currentUser;
  final bool isLoading;
  final String? errorMessage;

  UserProfileState({
    this.userRole,
    this.currentUser,
    this.isLoading = false,
    this.errorMessage,
  });

  UserProfileState copyWith({
    String? userRole,
    User? currentUser,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserProfileState(
      userRole: userRole ?? this.userRole,
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// StateNotifier para gerenciar o perfil do usuário
class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final SupabaseClient _supabaseClient;

  UserProfileNotifier(this._supabaseClient) : super(UserProfileState()) {
    _init();
  }

  void _init() {
    _supabaseClient.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn) {
        _fetchUserProfile();
      } else if (event == AuthChangeEvent.signedOut) {
        state = UserProfileState(userRole: null, currentUser: null);
      }
    });

    // Tenta carregar o perfil do usuário se já estiver logado na inicialização
    if (_supabaseClient.auth.currentUser != null) {
      _fetchUserProfile();
    }
  }

  Future<void> _fetchUserProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        state = state.copyWith(
          userRole: null,
          currentUser: null,
          isLoading: false,
        );
        return;
      }
      final response =
          await _supabaseClient
              .from('profiles')
              .select('role')
              .eq('user_id', userId)
              .maybeSingle();

      state = state.copyWith(
        userRole: response?['role'] as String?,
        currentUser: _supabaseClient.auth.currentUser,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        userRole: null,
        currentUser: null,
        isLoading: false,
        errorMessage: 'Erro ao buscar perfil: $e',
      );
      print('Erro ao buscar perfil do usuário no UserProfileNotifier: $e');
    }
  }
}

// Provider para o UserProfileNotifier
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
      final supabaseClient = Supabase.instance.client;
      return UserProfileNotifier(supabaseClient);
    });

// Opcional: um provider para o AuthProvider existente, se ainda for necessário
// final authProvider = ChangeNotifierProvider((ref) {
//   final supabaseClient = Supabase.instance.client;
//   // Você precisaria passar a serviceRoleKey aqui se o AuthProvider precisar dela.
//   // Para simplificar, vou assumir que a HomePage não precisa do adminSupabaseClient.
//   return AuthProvider(supabaseClient: supabaseClient);
// });
