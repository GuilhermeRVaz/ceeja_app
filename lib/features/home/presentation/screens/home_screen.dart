import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importa Supabase
import 'package:ceeja_app/features/auth/presentation/providers/user_profile_provider.dart'; // Importa o novo provider

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileState = ref.watch(userProfileProvider);
    final userRole = userProfileState.userRole;
    final currentUser = userProfileState.currentUser;
    final isLoading = userProfileState.isLoading;
    final errorMessage = userProfileState.errorMessage;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Inicial CEEJA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Para logout, podemos usar o AuthProvider original se ele tiver a lógica de signOut
              // Ou, se o UserProfileNotifier for o único a gerenciar o estado de autenticação,
              // o logout deve ser feito através do SupabaseClient diretamente ou de um método no UserProfileNotifier.
              // Por simplicidade, vou usar o SupabaseClient diretamente para o signOut.
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
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
            Image.asset('assets/LOGOTIPO_CEEJA.png', height: 172.5),
            const SizedBox(height: 20),
            const Text('Bem-vindo(a)!'),
            if (isLoading) const CircularProgressIndicator(),
            if (errorMessage != null)
              Text(
                'Erro: $errorMessage',
                style: const TextStyle(color: Colors.red),
              ),
            if (currentUser != null) Text('Logado como: ${currentUser.email}'),
            if (userRole != null) Text('Papel: $userRole'),
            const SizedBox(height: 20),
            // Placeholder para a lista de documentos
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Lista de Documentos do Usuário (Em breve...)'),
                    const SizedBox(height: 20), // Espaçamento
                    ElevatedButton.icon(
                      onPressed: () {
                        context.goNamed(
                          'enrollment_stepper',
                        ); // Navega para a tela de matrícula
                      },
                      icon: const Icon(Icons.add_task),
                      label: const Text('Iniciar Matrícula'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                    // Aqui você adicionaria a lógica para carregar e exibir os documentos
                    // Ex: ListView.builder para documentos
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          userRole == 'administrador'
              ? FloatingActionButton(
                onPressed: () {
                  context.goNamed(
                    'admin_dashboard',
                  ); // Rota para o painel de administração
                },
                child: const Icon(Icons.admin_panel_settings),
              )
              : null, // Não mostra o botão se não for administrador
    );
  }
}
