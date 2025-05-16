import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider with ChangeNotifier {
  final SupabaseClient _supabaseClient;

  AuthProvider({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  User? get currentUser => _supabaseClient.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

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

  Future<AuthResponse?> signInWithPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      // onAuthStateChange cuidará de notificar os listeners se o estado mudar
      // notifyListeners();
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
      // onAuthStateChange cuidará de notificar os listeners
      // notifyListeners();
    } on AuthException catch (e) {
      print('AuthException no signOut: ${e.message}');
      rethrow;
    } catch (e) {
      print('Erro genérico no signOut: $e');
    }
  }

  void listenToAuthChanges() {
    _supabaseClient.auth.onAuthStateChange.listen((data) {
      // final AuthChangeEvent event = data.event;
      // final Session? session = data.session;
      print(
        "AuthProvider: onAuthStateChange - Event: ${data.event}, Session: ${data.session?.toJson()}",
      );
      notifyListeners(); // Notifica sobre qualquer mudança de autenticação
    });
  }

  // Chamar listenToAuthChanges no construtor
  // AuthProvider({required SupabaseClient supabaseClient}) : _supabaseClient = supabaseClient {
  //   listenToAuthChanges();
  // }
  // Ou, melhor ainda, chame no main.dart após inicializar o provider se necessário,
  // ou garanta que o provider seja instanciado cedo o suficiente.
  // Para este exemplo, o listener será chamado quando o provider for criado.

  // No construtor, para iniciar o listener assim que o provider for criado.
  // AuthProvider({required SupabaseClient supabaseClient}) : _supabaseClient = supabaseClient {
  //   listenToAuthChanges();
  // }
  // A inicialização do listener pode ser feita no main.dart após a criação do provider
  // ou aqui mesmo, mas garanta que não cause múltiplos listeners se o provider for recriado.
  // Uma forma simples é chamar no construtor se o provider for um singleton ou gerenciado pelo MultiProvider.

  // Ajuste: O listener é bom, mas o notifyListeners() deve ser chamado quando o estado que a UI observa muda.
  // O currentUser e isLoggedIn já refletem o estado do _supabaseClient.auth.currentUser.
  // O onAuthStateChange é mais para reações globais ou atualizações de sessão.
  // O notifyListeners() no onAuthStateChange é bom para atualizar a UI que depende do estado de login.
}
