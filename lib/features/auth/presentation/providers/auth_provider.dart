import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importar flutter_dotenv
import 'package:ceeja_app/env.dart'; // Importar o arquivo env.dart

class AuthProvider with ChangeNotifier {
  final SupabaseClient _supabaseClient;
  final SupabaseClient?
  _adminSupabaseClient; // Cliente para operações administrativas
  String? _userRole; // Adiciona a propriedade para armazenar a role do usuário

  SupabaseClient? get adminSupabaseClient =>
      _adminSupabaseClient; // Getter público

  AuthProvider({required SupabaseClient supabaseClient, String? serviceRoleKey})
    : _supabaseClient = supabaseClient,
      _adminSupabaseClient =
          serviceRoleKey != null
              ? SupabaseClient(
                AppEnv.supabaseUrl, // Usa AppEnv para consistência
                serviceRoleKey!, // Usa a serviceRoleKey passada para o construtor
                headers: {'Authorization': 'Bearer $serviceRoleKey'},
              )
              : null {
    // Inicializa o listener de mudanças de autenticação
    _setupAuthListener();
    // Tenta carregar o perfil do usuário se já estiver logado na inicialização
    if (currentUser != null) {
      fetchUserProfile();
    }
  }

  User? get currentUser => _supabaseClient.auth.currentUser;
  bool get isLoggedIn => currentUser != null;
  String? get userRole => _userRole; // Getter para a role do usuário

  // Retorna a resposta para que a UI possa verificar user/session ou null em caso de exceção não tratada aqui
  // As exceções específicas de autenticação (AuthException) devem ser tratadas na UI para feedback ao usuário
  Future<AuthResponse?> signUp(
    String email,
    String password, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: data,
      );

      if (response.user != null) {
        // INSERÇÃO NA TABELA PROFILES
        final userId = response.user!.id;
        final String? fullName = data?["full_name"];

        try {
          await _supabaseClient.from("profiles").insert({
            "user_id": userId,
            "email": email,
            "full_name": fullName ?? "Nome não informado",
            "role": "aluno",
          });
          print("✅ Perfil criado com sucesso!");
        } catch (profileError) {
          print("❌ Erro ao criar perfil: $profileError");
          // Opcional: desfazer cadastro no auth.users se desejar
          await _supabaseClient.auth.admin.deleteUser(userId);
          rethrow;
        }
      }

      notifyListeners(); // Atualiza a UI após mudanças
      return response;
    } on AuthException catch (e) {
      print('AuthException no signUp: ${e.message}');
      rethrow; // Permite que a UI capture e trate a AuthException
    } catch (e) {
      print('Erro genérico no signUp: $e');
      return null; // Para outros tipos de erro não esperados
    }
  }

  Future<User?> createStudentUser({
    required String email,
    required String password,
    String? fullName,
  }) async {
    if (_adminSupabaseClient == null) {
      throw Exception(
        'Service Role Key não configurada para criar usuário aluno.',
      );
    }
    try {
      final response = await _adminSupabaseClient!.auth.admin.createUser(
        AdminUserAttributes(
          email: email,
          password: password,
          emailConfirm: true, // Opcional: confirma o email automaticamente
          userMetadata: {'full_name': fullName, 'role': 'aluno'},
        ),
      );

      if (response.user != null) {
        // INSERÇÃO NA TABELA PROFILES
        // Se a tabela 'profiles' tem RLS que impede admin de inserir, ou se já tem trigger,
        // essa parte pode ser removida. Mas para garantir, vamos manter.
        try {
          await _adminSupabaseClient!.from("profiles").insert({
            "user_id": response.user!.id,
            "email": email,
            "full_name": fullName ?? "Nome não informado",
            "role": "aluno",
          });
          print("✅ Perfil de aluno criado com sucesso!");
        } catch (profileError) {
          print("❌ Erro ao criar perfil de aluno: $profileError");
          // Opcional: desfazer criação do usuário se o perfil falhar
          await _adminSupabaseClient!.auth.admin.deleteUser(response.user!.id);
          rethrow;
        }
      }
      return response.user;
    } on AuthException catch (e) {
      print('AuthException ao criar usuário aluno: ${e.message}');
      rethrow;
    } catch (e) {
      print('Erro genérico ao criar usuário aluno: $e');
      return null;
    }
  }

  Future<AuthResponse?> signInWithPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        await fetchUserProfile(); // Busca a role após o login
      }
      return response;
    } on AuthException catch (e) {
      print('AuthException no signIn: ${e.message}');
      rethrow; // Permite que a UI capture e trate a AuthException
    } catch (e) {
      print('Erro genérico no signIn: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
      _userRole = null; // Limpa a role ao fazer logout
      notifyListeners(); // Notifica a UI sobre a mudança de estado
    } on AuthException catch (e) {
      print('AuthException no signOut: ${e.message}');
      rethrow;
    } catch (e) {
      print('Erro genérico no signOut: $e');
    }
  }

  // Método para buscar o perfil do usuário e sua role
  Future<void> fetchUserProfile() async {
    try {
      final userId = currentUser?.id;
      if (userId == null) {
        _userRole = null;
        notifyListeners();
        return;
      }
      final response =
          await _supabaseClient
              .from('profiles')
              .select('role')
              .eq('user_id', userId)
              .maybeSingle(); // Usar maybeSingle para lidar com 0 ou 1 resultado
      _userRole = response?['role'] as String?; // Acessa a role com segurança
      notifyListeners();
    } catch (e) {
      print('Erro ao buscar perfil do usuário: $e');
      _userRole = null; // Garante que a role seja nula em caso de erro
      notifyListeners();
    }
  }

  void _setupAuthListener() {
    _supabaseClient.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      print(
        "AuthProvider: onAuthStateChange - Event: $event, Session: ${session?.toJson()}",
      );

      if (event == AuthChangeEvent.signedIn) {
        await fetchUserProfile(); // Busca a role quando o usuário faz login
      } else if (event == AuthChangeEvent.signedOut) {
        _userRole = null; // Limpa a role quando o usuário faz logout
      }
      notifyListeners(); // Notifica sobre qualquer mudança de autenticação
    });
  }
}
