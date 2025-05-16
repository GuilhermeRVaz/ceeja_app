import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ceeja_app/features/auth/presentation/screens/login_screen.dart';
import 'package:ceeja_app/features/auth/presentation/screens/register_screen.dart';
// Certifique-se que o caminho para home_screen.dart está correto
import 'package:ceeja_app/features/home/presentation/screens/home_screen.dart';

// Você precisará de um AuthProvider para a lógica de redirecionamento.
// Se ainda não o tem, precisará criá-lo e configurá-lo com Provider.
// Exemplo: import 'package:ceeja_app/features/auth/presentation/providers/auth_provider.dart';
// Exemplo: import 'package:provider/provider.dart';

class AppRouter {
  // Adicione uma referência ao seu AuthProvider se for usar o redirect
  // final AuthProvider authProvider;
  // AppRouter(this.authProvider); // Modifique o construtor se necessário

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        name: 'login', // Nomear rotas é uma boa prática
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register', // Nomear rotas
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
    ],
    // Exemplo de lógica de redirecionamento (descomente e adapte conforme necessário)
    // redirect: (BuildContext context, GoRouterState state) {
    //   // Esta é uma forma simplificada. Você precisará de um AuthProvider
    //   // para verificar o estado de autenticação.
    //   // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    //   // final bool loggedIn = authProvider.isLoggedIn; // Supondo que seu AuthProvider tenha `isLoggedIn`

    //   // Obtenha o estado de login de alguma forma (ex: Supabase, Provider)
    //   final supabase = Supabase.instance.client; // Exemplo com Supabase
    //   final bool loggedIn = supabase.auth.currentUser != null;

    //   final String loginLocation = state.namedLocation('login');
    //   final bool loggingIn = state.matchedLocation == loginLocation;
    //   final String homeLocation = state.namedLocation('home');

    //   if (!loggedIn && !loggingIn) {
    //     // Se não estiver logado E não estiver tentando acessar a tela de login,
    //     // redireciona para login.
    //     return loginLocation;
    //   }

    //   if (loggedIn && loggingIn) {
    //     // Se estiver logado E estiver na tela de login,
    //     // redireciona para home.
    //     return homeLocation;
    //   }

    //   // Em outros casos, não redireciona.
    //   return null;
    // },
  );
}
