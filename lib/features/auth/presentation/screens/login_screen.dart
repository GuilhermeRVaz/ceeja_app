import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ceeja_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ceeja_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:ceeja_app/core/theme/app_theme.dart';

// MUDANÇA: A classe já é um ConsumerStatefulWidget, o que é ótimo.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // MUDANÇA: Não precisamos mais de um `_isLoading` local. O provider vai gerenciar isso.
  // bool _isLoading = false;

  // MUDANÇA: A lógica de submit fica mais limpa.
  Future<void> _submitAuthForm(
    String email,
    String password,
    String? fullName, // Não usado no login
    bool isLogin,
  ) async {
    // Acessamos o notifier para chamar a função de login.
    final authNotifier = ref.read(authProvider.notifier);

    try {
      // Chamamos o método de login. O try/catch é para lidar com a UI.
      await authNotifier.signInWithPassword(email, password);

      // Se o login for bem-sucedido, o GoRouter e o listener de autenticação
      // cuidarão do redirecionamento para a tela 'home'.
      // Podemos apenas mostrar uma mensagem de sucesso.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login bem-sucedido! Redirecionando...'),
            backgroundColor: Colors.green,
          ),
        );
        // O GoRouter deve ter um listener de autenticação para redirecionar
        // automaticamente. Mas podemos forçar aqui para garantir.
        context.goNamed('home');
      }
    } catch (e) {
      // Se o método signInWithPassword lançar uma exceção, pegamos aqui.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // O provider já formatou a mensagem de erro para nós.
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // MUDANÇA: Usamos 'ref.watch' para observar o estado de autenticação.
    // Isso reconstruirá o widget quando o estado de 'isLoading' mudar.
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppTheme.lightGreyColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/LOGOTIPO_CEEJA.png', height: 172.5),
              const SizedBox(height: 20),
              Text(
                'Bem-vindo ao CEEJA de Lins',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Acesse sua conta para continuar',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // MUDANÇA: Passamos o `isLoading` diretamente do estado do provider.
              AuthForm(
                submitFn: _submitAuthForm,
                isLogin: true,
                isLoading: authState.isLoading,
              ),
              const SizedBox(height: 20),
              // Desabilita o botão se estiver carregando.
              TextButton(
                onPressed:
                    authState.isLoading
                        ? null
                        : () {
                          context.goNamed('register');
                        },
                child: const Text(
                  'Não tem uma conta? Cadastre-se',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
