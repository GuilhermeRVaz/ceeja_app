import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ceeja_app/features/auth/presentation/screens/login_screen.dart';
import 'package:ceeja_app/features/auth/presentation/screens/register_screen.dart';
import 'package:ceeja_app/features/home/presentation/screens/home_screen.dart';
import 'package:ceeja_app/features/enrollment/presentation/screens/admin_enrollment_screen.dart';
import 'package:ceeja_app/features/enrollment/presentation/screens/enrollment_stepper_screen.dart'; // Importar EnrollmentStepperScreen

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login', // Rota inicial
    debugLogDiagnostics: true, // Útil para debug de rotas
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/admin-enrollment',
        name: 'admin-enrollment',
        builder: (BuildContext context, GoRouterState state) {
          return const AdminEnrollmentScreen();
        },
      ),
      GoRoute(
        path: '/enrollment-stepper',
        name: 'enrollment_stepper',
        builder: (BuildContext context, GoRouterState state) {
          return const EnrollmentStepperScreen();
        },
      ),
      // Adicionar outras rotas aqui
    ],
    // Lógica de redirecionamento (ex: se não estiver logado, redirecionar para /login)
    // redirect: (BuildContext context, GoRouterState state) {
    //   // Aqui você pode verificar o estado de autenticação (ex: usando Provider)
    //   // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    //   // final bool loggedIn = authProvider.isLoggedIn;
    //   // final String loginLocation = state.namedLocation('login');
    //   // final bool loggingIn = state.matchedLocation == loginLocation;

    //   // if (!loggedIn && !loggingIn) return loginLocation;
    //   // if (loggedIn && loggingIn) return '/home'; // ou a rota principal

    //   return null; // Sem redirecionamento
    // },
  );
}
