import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ceeja_app/features/auth/presentation/providers/auth_provider.dart'; // Verifique se este caminho está correto
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Inicial CEEJA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              if (context.mounted) {
                // Use goNamed para mais segurança e clareza, ou go se preferir.
                // Certifique-se que 'login' é o nome da sua rota de login em app_router.dart
                context.goNamed('login');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bem-vindo(a)!'),
            if (authProvider.currentUser != null)
              Text('Logado como: ${authProvider.currentUser!.email}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Adicione navegação para outras funcionalidades aqui
                // Exemplo: context.go('/matriculas');
              },
              child: const Text('Ir para Matrículas (Exemplo)'),
            ),
          ],
        ),
      ),
    );
  }
}
